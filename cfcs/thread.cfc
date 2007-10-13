<!---
	Name         : thread.cfc
	Author       : Raymond Camden 
	Created      : January 26, 2005
	Last Updated : October 12, 2007
	History      : Reset for V2
	Purpose		 : 
--->
<cfcomponent displayName="Thread" hint="Handles Threads which contain a collection of message.">

	<cfset variables.dsn = "">
	<cfset variables.dbtype = "">
	<cfset variables.tableprefix = "">
	<cfset variables.settings = "">
	
		
	<cffunction name="init" access="public" returnType="thread" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfreturn this>
		
	</cffunction>

	<cffunction name="addThread" access="remote" returnType="uuid" output="false"
				hint="Adds a thread.">
				
		<cfargument name="thread" type="struct" required="true">
		<cfset var newthread = "">
		<cfset var newid = createUUID()>
				
		<!--- First see if we can add a thread. Because roles= doesn't allow for OR, we use a UDF --->
		<cfif not variables.utils.isTheUserInAnyRole("forumsadmin,forumsmoderator,forumsmember")>
			<cfset variables.utils.throw("ThreadCFC","Unauthorized execution of addThread.")>
		</cfif>
		
		<cfif not validThread(arguments.thread)>
			<cfset variables.utils.throw("ThreadCFC","Invalid data passed to addThread.")>
		</cfif>
		
		<cfquery name="newthread" datasource="#variables.dsn#">
			insert into #variables.tableprefix#threads(id,name,active,forumidfk,useridfk,datecreated,sticky,messages)
			values(<cfqueryparam value="#newid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
				   <cfqueryparam value="#arguments.thread.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
				   <cfqueryparam value="#arguments.thread.active#" cfsqltype="CF_SQL_BIT">,
				   <cfqueryparam value="#arguments.thread.forumidfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
   				   <cfqueryparam value="#arguments.thread.useridfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
				   <cfqueryparam value="#arguments.thread.datecreated#" cfsqltype="CF_SQL_TIMESTAMP">,
   				   <cfqueryparam value="#arguments.thread.sticky#" cfsqltype="CF_SQL_BIT">,
					0
				   )
		</cfquery>
		
		<cfreturn newid>
	</cffunction>
	
	<cffunction name="deleteThread" access="public" returnType="void" roles="forumsadmin" output="false"
				hint="Deletes a thread along with all of it's children.">

		<cfargument name="id" type="uuid" required="true">
		<cfargument name="runupdate" type="boolean" required="false" default="true">
		
		<cfset var t = getThread(arguments.id)>
		
		<!--- delete kids --->
		<cfset var msgKids = variables.message.getMessages(arguments.id)>
		
		<cfloop query="msgKids">
			<cfset variables.message.deleteMessage(msgKids.id,false)>
		</cfloop>

		<cfquery datasource="#variables.dsn#">
			delete	from #variables.tableprefix#threads
			where	id = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>
		
		<!--- clean up subscriptions --->
		<cfquery datasource="#variables.dsn#">
			delete	from #variables.tableprefix#subscriptions
			where	threadidfk = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>
		
		<!--- update my parent --->
		<cfif arguments.runupdate>
			<cfset variables.forum.updateStats(t.forumidfk)>
		</cfif>
		
	</cffunction>
	
	<cffunction name="getThread" access="remote" returnType="struct" output="false"
				hint="Returns a struct copy of the thread.">
		<cfargument name="id" type="uuid" required="true">
		<cfset var qGetThread = "">
				
		<cfquery name="qGetThread" datasource="#variables.dsn#">
			select	id, name, active, forumidfk, useridfk, datecreated, sticky, lastpostuseridfk, lastpostcreated
			from	#variables.tableprefix#threads
			where	id = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>

		<!--- Throw if invalid id passed --->
		<cfif not qGetThread.recordCount>
			<cfset variables.utils.throw("ThreadCFC","Invalid ID")>
		</cfif>
		
		<!--- Only a ForumsAdmin can get bActiveOnly=false --->
		<cfif not qGetThread.active and not isUserInRole("forumsadmin")>
			<cfset variables.utils.throw("ThreadCFC","Invalid call to getThread")>
		</cfif>
		
		<cfreturn variables.utils.queryToStruct(qGetThread)>
			
	</cffunction>
		
	<cffunction name="getThreads" access="remote" returnType="query" output="false"
				hint="Returns a list of threads.">

		<cfargument name="bActiveOnly" type="boolean" required="false" default="true">
		<cfargument name="forumid" type="uuid" required="false">
		
		<cfset var qGetThreads = "">
		<cfset var getLastUser = "">
		
		<!--- Only a ForumsAdmin can be bActiveOnly=false --->
		<cfif not arguments.bActiveOnly and not isUserInRole("forumsadmin")>
			<cfset variables.utils.throw("ThreadCFC","Invalid call to getThreads")>
		</cfif>
		
		<cfquery name="qGetThreads" datasource="#variables.dsn#">
		select	t.id, t.name, t.active, t.forumidfk, t.useridfk, t.datecreated, t.messages, t.lastpostuseridfk,
			   	t.lastpostcreated, f.name as forum, u.username, sticky, c.name as conference
		
		from	#variables.tableprefix#threads t
		inner join #variables.tableprefix#forums f on t.forumidfk = f.id
		inner join #variables.tableprefix#conferences c on f.conferenceidfk = c.id
		inner join #variables.tableprefix#users u on t.useridfk = u.id
		
		where 1=1 
		<cfif arguments.bActiveOnly>
			and		t.active = 1
		</cfif>
		<cfif isDefined("arguments.forumid")>
			and		t.forumidfk = <cfqueryparam value="#arguments.forumid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfif>
		order by t.sticky <cfif variables.dbtype is not "msaccess">desc<cfelse>asc</cfif>, t.messages
		</cfquery>
		
		<cfreturn qGetThreads>
			
	</cffunction>
	
	<cffunction name="saveThread" access="remote" returnType="void" roles="forumsadmin" output="false"
				hint="Saves an existing thread.">
				
		<cfargument name="id" type="uuid" required="true">
		<cfargument name="thread" type="struct" required="true">
		
		<cfif not validThread(arguments.thread)>
			<cfset variables.utils.throw("ThreadCFC","Invalid data passed to saveThread.")>
		</cfif>
		
		<cfquery datasource="#variables.dsn#">
			update	#variables.tableprefix#threads
			set		name = <cfqueryparam value="#arguments.thread.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
					active = <cfqueryparam value="#arguments.thread.active#" cfsqltype="CF_SQL_BIT">,
					forumidfk = <cfqueryparam value="#arguments.thread.forumidfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
					useridfk = <cfqueryparam value="#arguments.thread.useridfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
					datecreated = <cfqueryparam value="#arguments.thread.datecreated#" cfsqltype="CF_SQL_TIMESTAMP">,
					sticky = <cfqueryparam value="#arguments.thread.sticky#" cfsqltype="CF_SQL_BIT">
			where	id = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>
		
	</cffunction>

	<cffunction name="search" access="remote" returnType="query" output="false"
				hint="Allows you to search threads.">
		<cfargument name="searchterms" type="string" required="true">
		<cfargument name="searchtype" type="string" required="false" default="phrase" hint="Must be: phrase,any,all">
		
		<cfset var results  = "">
		<cfset var x = "">
		<cfset var joiner = "">	
		<cfset var aTerms = "">

		<cfset arguments.searchTerms = variables.utils.searchSafe(arguments.searchTerms)>
	
		<!--- massage search terms into an array --->		
		<cfset aTerms = listToArray(arguments.searchTerms," ")>
		
		
		<!--- confirm searchtype is ok --->
		<cfif not listFindNoCase("phrase,any,all", arguments.searchtype)>
			<cfset arguments.searchtype = "phrase">
		<cfelseif arguments.searchtype is "any">
			<cfset joiner = "OR">
		<cfelseif arguments.searchtype is "all">
			<cfset joiner = "AND">
		</cfif>
		
		<cfquery name="results" datasource="#variables.dsn#">
			select	t.id, t.name, t.forumidfk, f.conferenceidfk
			from	#variables.tableprefix#threads t, #variables.tableprefix#forums f
			where	t.active = 1
			and		t.forumidfk = f.id
			and (
				<cfif arguments.searchtype is not "phrase">
					<cfloop index="x" from=1 to="#arrayLen(aTerms)#">
						(t.name like <cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="255" value="%#left(aTerms[x],255)#%">)
						 <cfif x is not arrayLen(aTerms)>#joiner#</cfif>
					</cfloop>
				<cfelse>
					t.name like <cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="255" value="%#left(arguments.searchTerms,255)#%">
				</cfif>
			)
		</cfquery>
		
		<cfreturn results>
	</cffunction>

	<cffunction name="updateLastMessage" access="public" returnType="void" output="false" hint="Updates last message stats">
		<cfargument name="id" type="uuid" required="true">
		<cfargument name="userid" type="uuid" required="true">
		<cfargument name="posted" type="date" required="true">
			
		<cfquery datasource="#variables.dsn#">
		update	#variables.tableprefix#threads
		set		lastpostuseridfk = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#arguments.userid#">,
				lastpostcreated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.posted#">,
				messages = messages + 1
		where	id = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#arguments.id#">
		</cfquery>
		
	</cffunction>

	<cffunction name="updateStats" access="public" returnType="void" output="false" hint="Reset stats for thread">
		<cfargument name="id" type="uuid" required="true">
		<cfset var threadKids = "">
		<cfset var me = getThread(arguments.id)>
		<cfset var total = 0>
		<cfset var last = createDate(1900,1,1)>
		<cfset var lastu = "">
		<cfset var lasti = "">
		<cfset var haveSome = false>
		
		<!---
		Rather simple. Get my kids. Count total msgs, and pick latest date 
		--->

		<cfset msgKids = variables.message.getMessages(arguments.id)>
		<cfset haveSome = msgKids.recordCount gte 1>

		<!--- last msg is latest --->
		<cfif haveSome>
			<cfset total = msgKids.recordCount>
			<cfset last = msgKids.posted[msgKids.recordCount]>
			<cfset lastu = msgKids.useridfk[msgKids.recordCount]>
			<cfset lasti = msgKids.id[msgKids.recordCount]>
			<!--- lasti is NOT used. I know this. keeping this anyway for now. --->
		</cfif>

		<!--- now update this conf --->
		<cfif haveSome>
			<cfquery datasource="#variables.dsn#">
			update	#variables.tableprefix#threads
			set		
					lastpostuseridfk = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#lastu#">,
					lastpostcreated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last#">,
					messages = <cfqueryparam cfsqltype="cf_sql_numeric" value="#total#">
			where	id = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#arguments.id#">
			</cfquery>
		<cfelse>
			<cfquery datasource="#variables.dsn#">
			update	#variables.tableprefix#forums
			set		
					lastpostuseridfk = <cfqueryparam cfsqltype="cf_sql_varchar" null="true">,
					lastpostcreated = <cfqueryparam cfsqltype="cf_sql_timestamp" null="true">,
					messages = <cfqueryparam cfsqltype="cf_sql_numeric" value="0">
			where	id = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#arguments.id#">
			</cfquery>
		</cfif>
		
		<!--- now update my parent --->
		<cfset variables.forum.updateStats(me.forumidfk)>
		
	</cffunction>
	
	<cffunction name="validThread" access="private" returnType="boolean" output="false"
				hint="Checks a structure to see if it contains all the proper keys/values for a thread.">
		
		<cfargument name="cData" type="struct" required="true">
		<cfset var rList = "name,active,forumidfk,useridfk,datecreated,sticky">
		<cfset var x = "">
		
		<cfloop index="x" list="#rList#">
			<cfif not structKeyExists(cData,x)>
				<cfreturn false>
			</cfif>
		</cfloop>
		
		<cfreturn true>
		
	</cffunction>

	<cffunction name="setSettings" access="public" output="No" returntype="void">
		<cfargument name="settings" required="true" hint="Setting">
		<cfset variables.dsn = arguments.settings.getSettings().dsn />
		<cfset variables.dbtype = arguments.settings.getSettings().dbtype />
		<cfset variables.tableprefix = arguments.settings.getSettings().tableprefix />
		<!--- keep a global copy to pass later on --->
		<cfset variables.settings = arguments.settings.getSettings() />
	</cffunction>
	
	<cffunction name="setUtils" access="public" output="No" returntype="void">
		<cfargument name="utils" required="true" hint="utils">
		<cfset variables.utils = arguments.utils />
	</cffunction>

	<cffunction name="setMessage" access="public" output="No" returntype="void">
		<cfargument name="message" required="true" hint="message">
		<cfset variables.message = arguments.message />
	</cffunction>

	<cffunction name="setForum" access="public" output="No" returntype="void">
		<cfargument name="forum" required="true" hint="forum">
		<cfset variables.forum = arguments.forum />
	</cffunction>

</cfcomponent>