<!---
	Name         : permission.cfc
	Author       : Raymond Camden 
	Created      : August 19, 2007
	Last Updated : 
	History      : 
	Purpose		 : 
--->
<cfcomponent displayName="Permissio" hint="Handles all permissions issues.">

	<cfset variables.dsn = "">
	<cfset variables.dbtype = "">
	<cfset variables.tableprefix = "">	

	<cffunction name="init" access="public" returnType="permission" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfreturn this>
		
	</cffunction>

	<cffunction name="allowed" access="public" output="false" returnType="boolean" hint="For a resource and right, see if any of the passed groups is allowed.">
		<cfargument name="right" type="uuid" required="true">
		<cfargument name="resource" type="uuid" required="true">
		<cfargument name="groups" type="string" required="true">
		
		<!--- get allowed --->
		<cfset var allowedgroups = getAllowed(arguments.right, arguments.resource)>
		<cfset var g = "">
		
		<cfif allowedgroups.recordCount is 0>
			<cfreturn true>
		</cfif>
		
		<cfloop index="g" list="#valueList(allowedgroups.group)#">
			<cfif listFind(arguments.groups, g)>
				<cfreturn true>
			</cfif>
		</cfloop>
	
		<cfreturn false>
	</cffunction>
	
	<cffunction name="filter" access="public" output="false" returnType="query"
				hint="This is utility function. Given a query, a right, and your groups, it can remove what you don't have a right to.">
		<cfargument name="query" type="query" required="true">
		<cfargument name="groups" type="string" required="true">
		<cfargument name="right" type="uuid" required="true">
		<cfargument name="resourcecol" type="string" required="false" default="id" hint="What column in the query refers to the resource.">

		<cfset var resource = "">
		<cfset var allowedgroup = "">
		<cfset var toKill = "">
		<cfset var allowed = "">
		<cfset var result = "">
		<cfset var validgroups = "">
		
		<cfif not listFindNoCase(arguments.query.columnlist, arguments.resourcecol)>
			<cfthrow message="Invalid resourcecol (#arguments.resourcecol#) - valid columns are #arguments.query.columnlist#">
		</cfif>
		
		<!--- 
		So this is the idea. For each resource, we look in the permissions table.
		If there are NO rows, anyone can do it.
		if there ARE rows, and you aren't in the list, you are blocked.
		--->
		<cfloop query="arguments.query">
			<cfset resource = arguments.query[arguments.resourcecol][currentrow]>
			<cfset validgroups = getAllowed(arguments.right, resource)>
			<cfif validgroups.recordCount>
				<cfset allowed = false>
				<cfloop index="allowedgroup" list="#valueList(validgroups.group)#">
					<cfif listFind(arguments.groups, allowedgroup)>
						<cfset allowed = true>
						<cfbreak>
					</cfif>		
				</cfloop>
				<cfif not allowed>
					<cfset toKill = listAppend(toKill, resource)>
				</cfif>	
			</cfif>		
		</cfloop>
		
		<cfif len(toKill)>
			<cfquery name="result" dbtype="query">
			select	*
			from	arguments.query
			where	#arguments.resourcecol# not in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#toKill#">)
			</cfquery>
			
			<cfreturn result>
		<cfelse>
			<cfreturn arguments.query>
		</cfif>
	</cffunction>

	<cffunction name="getAllowed" access="public" output="false" returnType="query" hint="Returns all groups that have a right to a resource.">
		<cfargument name="right" type="uuid" required="true">
		<cfargument name="resource" type="uuid" required="true">
		<cfset var q = "">
		
		<cfquery name="q" datasource="#variables.dsn#">
		select	groupidfk as 
		<cfswitch expression="#lCase(variables.dbtype)#" >
        	<cfcase value="mysql">
            	`group`
            </cfcase>
            <cfcase value="oracle">
            	"GROUP"
            </cfcase>
            <cfdefaultcase>
            	[group]
            </cfdefaultcase>
        </cfswitch>
		from	#variables.tableprefix#permissions
		where	rightidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.right#" maxlength="35">
		and		resourceidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.resource#" maxlength="35">
		</cfquery>
		
		<cfreturn q>
	</cffunction>

	<cffunction name="setAllowed" access="public" output="false" returnType="void" hint="Sets all groups that have a right to a resource.">
		<cfargument name="right" type="uuid" required="true">
		<cfargument name="resource" type="uuid" required="true">
		<cfargument name="grouplist" type="string" required="true">
		<cfset var q = "">
		<cfset var g = "">
		
		<!--- first remove all --->
		<cfquery datasource="#variables.dsn#">
		delete from #variables.tableprefix#permissions
		where	rightidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.right#" maxlength="35">
		and		resourceidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.resource#" maxlength="35">
		</cfquery>
		
		<!--- now add each one --->
		<cfloop index="g" list="#arguments.grouplist#">

			<cfquery name="q" datasource="#variables.dsn#">
			insert into #variables.tableprefix#permissions(id,rightidfk,resourceidfk,groupidfk)
			values(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#createUUID()#" maxlength="35">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.right#" maxlength="35">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.resource#" maxlength="35">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#g#" maxlength="35">)
			</cfquery>

		</cfloop>
				
	</cffunction>
	
	<cffunction name="setSettings" access="public" output="No" returntype="void">
		<cfargument name="settings" required="true" hint="Setting">

		<cfset var cfg = arguments.settings.getSettings() />
		<cfset variables.dsn = cfg.dsn>
		<cfset variables.dbtype = cfg.dbtype>
		<cfset variables.tableprefix = cfg.tableprefix>
		
	</cffunction>
	
</cfcomponent>