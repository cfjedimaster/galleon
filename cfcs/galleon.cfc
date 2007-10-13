<cfcomponent displayName="Galleon" hint="Core CFC for the application. Main purpose is to handle settings.">

	<cffunction name="getSettings" access="public" returnType="struct" output="false"
				hint="Returns application settings as a structure.">
		
		<!--- load the settings from the ini file --->
		<cfset var settingsFile = replace(getDirectoryFromPath(getCurrentTemplatePath()),"\","/","all") & "/settings.ini.cfm">
		<cfset var iniData = getProfileSections(settingsFile)>
		<cfset var r = structNew()>
		<cfset var key = "">
		
		<cfloop index="key" list="#iniData.settings#">
			<cfset r[key] = getProfileString(settingsFile,"settings",key)>
		</cfloop>
		
		<cfreturn r>
		
	</cffunction>
	
	<cffunction name="setSetting" access="public" returnType="void" output="false">
		<cfargument name="name" type="string" required="true">
		<cfargument name="value" type="string" required="true">

		<cfset var settingsFile = replace(getDirectoryFromPath(getCurrentTemplatePath()),"\","/","all") & "/settings.ini.cfm">

		<cfset setProfileString(settingsFile, "settings", arguments.name, arguments.value)>
				
	</cffunction>
	
</cfcomponent>