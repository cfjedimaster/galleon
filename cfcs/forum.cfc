<!---
	Name         : forum.cfc
	Author       : Raymond Camden 
	Created      : January 26, 2005
	Last Updated : November 19, 2007
	History      : Reset for V2
				 : access fix (rkc 11/19/07)
	Purpose		 : 
--->
<cfcomponent displayName="Forum" hint="Handles Forums which contain a collection of threads.">

	<cfset variables.dsn = "">
	<cfset variales.dbtype = "">
	<cfset variables.tableprefix = "">
		
	<cffunction name="init" access="public" returnType="forum" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfreturn this>
		
	</cffunction>

	<cffunction name="addForum" access="remote" returnType="uuid" roles="forumsadmin" output="false"
				hint="Adds a forum.">				
		<cfargument name="forum" type="struct" required="true">
		<cfset var newforum = "">
		<cfset var newid = createUUID()>
		
		<cfif not validForum(arguments.forum)>
			<cfset variables.utils.throw("ForumCFC","Invalid data passed to addForum.")>
		</cfif>
		
		<cfquery name="newforum" datasource="#variables.dsn#">
			insert into #variables.tableprefix#forums(id,name,description,active,conferenceidfk,attachments,messages)
			values(<cfqueryparam value="#newid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
				   <cfqueryparam value="#arguments.forum.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
				   <cfqueryparam value="#arguments.forum.description#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
				   <cfqueryparam value="#arguments.forum.active#" cfsqltype="CF_SQL_BIT">,
				   <cfqueryparam value="#arguments.forum.conferenceidfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
				   <cfqueryparam value="#arguments.forum.attachments#" cfsqltype="CF_SQL_BIT">,
				   0
				   )
		</cfquery>
		
		<cfreturn newid>
				
	</cffunction>
	
	<cffunction name="deleteForum" access="public" returnType="void" roles="forumsadmin" output="false"
				hint="Deletes a forum along with all of it's children.">
		<cfargument name="id" type="uuid" required="true">
		<cfargument name="runupdate" type="boolean" required="false" default="true">
		
		<cfset var threadKids = "">
		<cfset var f = getForum(arguments.id)>
		
		<!--- first, delete my children --->
		<cfset threadKids = variables.thread.getThreads(false,arguments.id)>
		<cfloop query="threadKids.data">
			<cfset variables.thread.deleteThread(threadKids.data.id[currentRow],false)>
		</cfloop>

		<cfquery datasource="#variables.dsn#">
			delete	from #variables.tableprefix#forums
			where	id = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>

		<!--- clean up subscriptions --->
		<cfquery datasource="#variables.dsn#">
			delete	from #variables.tableprefix#subscriptions
			where	forumidfk = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>
		
		<!--- update stats for my parent --->
		<cfif arguments.runupdate>
			<cfset variables.conference.updateStats(f.conferenceidfk)>
		</cfif>
		
	</cffunction>
	
	<cffunction name="getForum" access="remote" returnType="struct" output="false"
				hint="Returns a struct copy of the forum.">
		<cfargument name="id" type="uuid" required="true">
		<cfset var qGetForum = "">
				
		<cfquery name="qGetForum" datasource="#variables.dsn#">
			select	id, name, description, active, conferenceidfk, attachments, messages, lastpost, lastpostuseridfk, lastpostcreated
			from	#variables.tableprefix#forums
			where	id = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>

		<!--- Throw if invalid id passed --->
		<cfif not qGetForum.recordCount>
			<cfset variables.utils.throw("ForumCFC","Invalid ID")>
		</cfif>
		
		<!--- Only a ForumsAdmin can get bActiveOnly=false --->
		<cfif not qGetForum.active and not isUserInRole("forumsadmin")>
			<cfset variables.utils.throw("ForumCFC","Invalid call to getForum")>
		</cfif>
		
		<cfreturn variables.utils.queryToStruct(qGetForum)>
			
	</cffunction>
		
	<cffunction name="getForums" access="remote" returnType="query" output="false"
				hint="Returns a list of forums.">

		<cfargument name="bActiveOnly" type="boolean" required="false" default="true">
		<cfargument name="conferenceid" type="uuid" required="false">
		
		<cfset var qGetForums = "">
		<cfset var getLastUser = "">
		
		<!--- Only a ForumsAdmin can be bActiveOnly=false --->
		<cfif not arguments.bActiveOnly and not isUserInRole("forumsadmin")>
			<cfset variables.utils.throw("ForumCFC","Invalid call to getForums")>
		</cfif>
		
		<cfquery name="qGetForums" datasource="#variables.dsn#">
			select	f.id, f.name, f.description, f.active, f.attachments, f.conferenceidfk, f.lastpostcreated, 
					f.messages, f.lastpost, f.lastpostuseridfk, c.name as conference
			from	#variables.tableprefix#forums f, #variables.tableprefix#conferences c
			where	f.conferenceidfk = c.id
			<cfif structKeyExists(arguments, "bactiveonly") and arguments.bactiveonly>
			and		f.active <> 0
			</cfif>
			<cfif structKeyExists(arguments, "conferenceid")>
			and		f.conferenceidfk = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#arguments.conferenceid#">
			</cfif>
			order by f.name
		</cfquery>

		
		<cfreturn qGetForums>
			
	</cffunction>
	
	<cffunction name="saveForum" access="remote" returnType="void" roles="forumsadmin" output="false"
				hint="Saves an existing forum.">
				
		<cfargument name="id" type="uuid" required="true">
		<cfargument name="forum" type="struct" required="true">
		
		<cfif not validForum(arguments.forum)>
			<cfset variables.utils.throw("ForumCFC","Invalid data passed to saveForum.")>
		</cfif>
		
		<cfquery datasource="#variables.dsn#">
			update	#variables.tableprefix#forums
			set		name = <cfqueryparam value="#arguments.forum.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
					description = <cfqueryparam value="#arguments.forum.description#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
					active = <cfqueryparam value="#arguments.forum.active#" cfsqltype="CF_SQL_BIT">,
					attachments = <cfqueryparam value="#arguments.forum.attachments#" cfsqltype="CF_SQL_BIT">,
					conferenceidfk = <cfqueryparam value="#arguments.forum.conferenceidfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
			where	id = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>
		
	</cffunction>

	<cffunction name="search" access="remote" returnType="query" output="false"
				hint="Allows you to search forums.">
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
		
		<cfquery name="results" datasource="#variables.dsn#" maxrows="100">
			select	f.id, f.name, f.description, f.conferenceidfk, c.name as conference
			from	#variables.tableprefix#forums f, #variables.tableprefix#conferences c
			where	f.active = 1
			and		f.conferenceidfk = c.id
			and (
				<cfif arguments.searchtype is not "phrase">
					<cfloop index="x" from=1 to="#arrayLen(aTerms)#">
						(f.name like <cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="255" value="%#left(aTerms[x],255)#%"> 
						 or
						 f.description like '%#aTerms[x]#%')
						 <cfif x is not arrayLen(aTerms)>#joiner#</cfif>
					</cfloop>
				<cfelse>
					f.name like <cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="255" value="%#left(arguments.searchTerms,255)#%">
					or
					f.description like '%#arguments.searchTerms#%'
				</cfif>
			)
		</cfquery>
		
		<cfreturn results>
	</cffunction>

	<cffunction name="updateLastMessage" access="public" returnType="void" output="false" hint="Updates last message stats">
		<cfargument name="id" type="uuid" required="true">
		<cfargument name="threadid" type="uuid" required="true">
		<cfargument name="userid" type="uuid" required="true">
		<cfargument name="posted" type="date" required="true">
			
		<cfquery datasource="#variables.dsn#">
		update	#variables.tableprefix#forums
		set		lastpost = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#arguments.threadid#">,
				lastpostuseridfk = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#arguments.userid#">,
				lastpostcreated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.posted#">,
				messages = messages + 1
		where	id = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#arguments.id#">
		</cfquery>
		
	</cffunction>

	<cffunction name="updateStats" access="public" returnType="void" output="false" hint="Reset stats for forums">
		<cfargument name="id" type="uuid" required="true">
		<cfset var me = getForum(arguments.id)>
		<cfset var threadKids = "">
		<cfset var total = 0>
		<cfset var last = createDate(1900,1,1)>
		<cfset var lastu = "">
		<cfset var lasti = "">
		<cfset var haveSome = false>
		
		<!---
		Rather simple. Get my kids. Count total msgs, and pick latest date 
		--->

		<cfset threadKids = variables.thread.getThreads(true,arguments.id)>
		<cfset haveSome = threadKids.total gte 1>

		<cfloop query="threadKids.data">
			<cfset total = total + messages>
			<cfif isDate(lastPostCreated) and dateCompare(last, lastPostCreated) is -1>
				<cfset last = lastpostcreated>
				<cfset lastu = lastpostuseridfk>
				<cfset lasti = threadKids.data.id[currentRow]>
			</cfif>
		</cfloop>

		<!--- now update this conf --->
		<cfif haveSome>
			<cfquery datasource="#variables.dsn#">
			update	#variables.tableprefix#forums
			set		lastpost = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#lasti#">,
					lastpostuseridfk = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#lastu#">,
					lastpostcreated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last#">,
					messages = <cfqueryparam cfsqltype="cf_sql_numeric" value="#total#">
			where	id = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#arguments.id#">
			</cfquery>
		<cfelse>
			<cfquery datasource="#variables.dsn#">
			update	#variables.tableprefix#forums
			set		lastpost = <cfqueryparam cfsqltype="cf_sql_varchar" null="true">,
					lastpostuseridfk = <cfqueryparam cfsqltype="cf_sql_varchar" null="true">,
					lastpostcreated = <cfqueryparam cfsqltype="cf_sql_timestamp" null="true">,
					messages = <cfqueryparam cfsqltype="cf_sql_numeric" value="0">
			where	id = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#arguments.id#">
			</cfquery>
		</cfif>
		
		<!--- now update my parent --->
		<cfset variables.conference.updateStats(me.conferenceidfk)>
		
	</cffunction>
	
	<cffunction name="validForum" access="private" returnType="boolean" output="false"
				hint="Checks a structure to see if it contains all the proper keys/values for a forum.">
		
		<cfargument name="cData" type="struct" required="true">
		<cfset var rList = "name,description,active,conferenceidfk">
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
		<cfset variables.dsn = arguments.settings.getSettings().dsn>
		<cfset variables.dbtype = arguments.settings.getSettings().dbtype>
		<cfset variables.tableprefix = arguments.settings.getSettings().tableprefix>
	</cffunction>
	
	<cffunction name="setUtils" access="public" output="No" returntype="void">
		<cfargument name="utils" required="true" hint="utils">
		<cfset variables.utils = arguments.utils />
	</cffunction>

	<cffunction name="setThread" access="public" output="No" returntype="void">
		<cfargument name="thread" required="true" hint="thread">
		<cfset variables.thread = arguments.thread />
	</cffunction>

	<cffunction name="setConference" access="public" output="No" returntype="void">
		<cfargument name="conference" required="true" hint="conference">
		<cfset variables.conference = arguments.conference />
	</cffunction>
	
</cfcomponent>