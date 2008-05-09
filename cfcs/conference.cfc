<!---
	Name         : message.cfc
	Author       : Raymond Camden 
	Created      : January 25, 2005
	Last Updated : November 10, 2007
	History      : Reset for V2
				 : mod to get latest posts (rkc 11/10/07)
	Purpose		 : 
--->
<cfcomponent displayName="Conference" hint="Handles Conferences, the highest level container for Forums.">

	<cfset variables.dsn = "">
	<cfset variables.dbtype = "">
	<cfset variables.tableprefix = "">
		
	<cffunction name="init" access="public" returnType="conference" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">

		<cfreturn this>
		
	</cffunction>

	<cffunction name="addConference" access="remote" returnType="uuid" roles="forumsadmin" output="false"
				hint="Adds a conference.">
				
		<cfargument name="conference" type="struct" required="true">
		<cfset var newconference = "">
		<cfset var newid = createUUID()>
		
		<cfif not validConference(arguments.conference)>
			<cfset variables.utils.throw("ConferenceCFC","Invalid data passed to addConference.")>
		</cfif>
		
		<cfquery name="newconference" datasource="#variables.dsn#">
			insert into #variables.tableprefix#conferences(id,name,description,active,messages)
			values(<cfqueryparam value="#newid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
				   <cfqueryparam value="#arguments.conference.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
				   <cfqueryparam value="#arguments.conference.description#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
				   <cfqueryparam value="#arguments.conference.active#" cfsqltype="CF_SQL_BIT">,
				   0
				   )
		</cfquery>
		
		<cfreturn newid>
		
	</cffunction>
	
	<cffunction name="deleteConference" access="public" returnType="void" roles="forumsadmin" output="false"
				hint="Deletes a conference along with all of it's children.">

		<cfargument name="id" type="uuid" required="true">
		<cfset var forumKids = "">
				
		<!--- first, delete my children --->
		<cfset forumKids = variables.forum.getForums(false,arguments.id)>
		<cfloop query="forumKids">
			<cfset variables.forum.deleteForum(forumKids.id,false)>
		</cfloop>
		
		<cfquery datasource="#variables.dsn#">
			delete	from #variables.tableprefix#conferences
			where	id = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>

		<!--- clean up subscriptions --->
		<cfquery datasource="#variables.dsn#">
			delete	from #variables.tableprefix#subscriptions
			where	conferenceidfk = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>
		
	</cffunction>

	<cffunction name="getConference" access="remote" returnType="struct" output="false"
				hint="Returns a struct copy of the conferene.">
		<cfargument name="id" type="uuid" required="true">
		<cfset var qGetConference = "">
				
		<cfquery name="qGetConference" datasource="#variables.dsn#">
			select	id, name, description, active, messages, lastpost, lastpostuseridfk, lastpostcreated
			from	#variables.tableprefix#conferences
			where	id = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>

		<!--- Throw if invalid id passed --->
		<cfif not qGetConference.recordCount>
			<cfset variables.utils.throw("ConferenceCFC","Invalid ID")>
		</cfif>
		
		<!--- Only a ForumsAdmin can get bActiveOnly=false --->
		<cfif not qGetConference.active and not isUserInRole("forumsadmin")>
			<cfset variables.utils.throw("ConferenceCFC","Invalid call to getConference")>
		</cfif>
		
		<cfreturn variables.utils.queryToStruct(qGetConference)>
			
	</cffunction>
		
	<cffunction name="getConferences" access="remote" returnType="query" output="false"
				hint="Returns a list of conferences.">

		<cfargument name="bActiveOnly" type="boolean" required="false" default="true">
		
		<cfset var qGetConferences = "">
		
		<!--- Only a ForumsAdmin can be bActiveOnly=false --->
		<cfif not arguments.bActiveOnly and not isUserInRole("forumsadmin")>
			<cfset variables.utils.throw("ConferenceCFC","Invalid call to getConferences")>
		</cfif>
		
		<cfquery name="qGetConferences" datasource="#variables.dsn#">
			select	id, name, description, active, messages, lastpost, lastpostuseridfk, lastpostcreated
			from	#variables.tableprefix#conferences
			order by name
		</cfquery>
				
		<cfreturn qGetConferences>
			
	</cffunction>
	
	<cffunction name="getLatestPosts" access="remote" returnType="query" output="false"
				hint="Retrieve the last 20 posts to any threads in forums in this conference.">
		<cfargument name="conferenceid" type="uuid" required="true">
		<cfset var qLatestPosts = "">
		
		<cfquery name="qLatestPosts" datasource="#variables.dsn#">
			<cfif variables.dbtype is "oracle">
            	select * from (
        	</cfif>
			select		
				<cfif not listFindNoCase("mysql,oracle",variables.dbtype)>
				top 20 
				</cfif>
						#variables.tableprefix#messages.title, #variables.tableprefix#threads.name as thread, 
						#variables.tableprefix#messages.posted, #variables.tableprefix#users.username, 
						#variables.tableprefix#messages.threadidfk as threadid, 
						#variables.tableprefix#messages.body,
						#variables.tableprefix#threads.forumidfk,
						#variables.tableprefix#forums.conferenceidfk
			from		#variables.tableprefix#messages, #variables.tableprefix#threads, #variables.tableprefix#users, #variables.tableprefix#forums
			where		#variables.tableprefix#messages.threadidfk = #variables.tableprefix#threads.id
			and			#variables.tableprefix#messages.useridfk = #variables.tableprefix#users.id
			and			#variables.tableprefix#threads.forumidfk = #variables.tableprefix#forums.id
			and			#variables.tableprefix#forums.conferenceidfk = <cfqueryparam value="#arguments.conferenceid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
			order by	#variables.tableprefix#messages.posted desc
				<cfif variables.dbtype is "mysql">
				limit 20
            <cfelseif variables.dbtype is "oracle">
            	) where rownum <= 20
        	</cfif>
		</cfquery>
		
		<cfreturn qLatestPosts>
	</cffunction>
	
	<cffunction name="saveConference" access="remote" returnType="void" roles="forumsadmin" output="false"
				hint="Saves an existing conference.">
				
		<cfargument name="id" type="uuid" required="true">
		<cfargument name="conference" type="struct" required="true">
		
		<cfif not validConference(arguments.conference)>
			<cfset variables.utils.throw("ConferenceCFC","Invalid data passed to saveConference.")>
		</cfif>
		
		<cfquery datasource="#variables.dsn#">
			update	#variables.tableprefix#conferences
			set		name = <cfqueryparam value="#arguments.conference.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
					description = <cfqueryparam value="#arguments.conference.description#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
					active = <cfqueryparam value="#arguments.conference.active#" cfsqltype="CF_SQL_BIT">
			where	id = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>
		
	</cffunction>
	
	<cffunction name="search" access="remote" returnType="query" output="false"
				hint="Allows you to search conferences.">
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
			select	id, name, description
			from	#variables.tableprefix#conferences
			where	active = 1
			and (
				<cfif arguments.searchtype is not "phrase">
					<cfloop index="x" from=1 to="#arrayLen(aTerms)#">
						(name like <cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="255" value="%#left(aTerms[x],255)#%"> 
						 or
						 description like '%#aTerms[x]#%')
						 <cfif x is not arrayLen(aTerms)>#joiner#</cfif>
					</cfloop>
				<cfelse>
					name like <cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="255" value="%#left(arguments.searchTerms,255)#%">
					or
					description like '%#arguments.searchTerms#%'
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
		update	#variables.tableprefix#conferences
		set		lastpost = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#arguments.threadid#">,
				lastpostuseridfk = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#arguments.userid#">,
				lastpostcreated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.posted#">,
				messages = messages + 1
		where	id = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#arguments.id#">
		</cfquery>
		
	</cffunction>

	<cffunction name="updateStats" access="public" returnType="void" output="false" hint="Reset stats for conferences">
		<cfargument name="id" type="uuid" required="true">
		<cfset var forumKids = "">
		<cfset var total = 0>
		<cfset var last = createDate(1900,1,1)>
		<cfset var lastu = "">
		<cfset var lasti = "">
		<cfset var haveSome = false>
		
		<!---
		Rather simple. Get my kids. Count total msgs, and pick latest date 
		--->

		<cfset forumKids = variables.forum.getForums(true,arguments.id)>
		<cfset haveSome = forumKids.recordCount gte 1>
		
		<cfloop query="forumKids">
			<cfset total = total + messages>
			<cfif isDate(lastPostCreated) and dateCompare(last, lastPostCreated) is -1>
				<cfset last = lastpostcreated>
				<cfset lastu = lastpostuseridfk>
				<cfset lasti = lastpost>
			</cfif>
		</cfloop>
		<cflog file="galleon" text="havesome=#havesome#, last=#last#, lastu=#lastu#, lasti=#lasti#">
		<!--- now update this conf --->
		<cfif haveSome and lastu neq "">
			<!---
			As a user reported, it is possible the last X for a forum is null. This
			can happen if you kill the last thread in a forum.
			So haveSome is kinda meh now.
			--->
			<cfquery datasource="#variables.dsn#">
			update	#variables.tableprefix#conferences
			set		lastpost = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#lasti#">,
					lastpostuseridfk = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#lastu#">,
					lastpostcreated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last#">,
					messages = <cfqueryparam cfsqltype="cf_sql_numeric" value="#total#">
			where	id = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#arguments.id#">
			</cfquery>
		<cfelse>
			<cfquery datasource="#variables.dsn#">
			update	#variables.tableprefix#conferences
			set		lastpost = <cfqueryparam cfsqltype="cf_sql_varchar" null="true">,
					lastpostuseridfk = <cfqueryparam cfsqltype="cf_sql_varchar" null="true">,
					lastpostcreated = <cfqueryparam cfsqltype="cf_sql_timestamp" null="true">,
					messages = <cfqueryparam cfsqltype="cf_sql_numeric" value="0">
			where	id = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#arguments.id#">
			</cfquery>
		</cfif>
	</cffunction>
		
	<cffunction name="validConference" access="private" returnType="boolean" output="false"
				hint="Checks a structure to see if it contains all the proper keys/values for a conference.">
		
		<cfargument name="cData" type="struct" required="true">
		<cfset var rList = "name,description,active">
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

	<cffunction name="setForum" access="public" output="No" returntype="void">
		<cfargument name="forum" required="true" hint="forum">
		<cfset variables.forum = arguments.forum />
	</cffunction>
	
</cfcomponent>