<cfcomponent output="false">

<cffunction name="sendmail" access="public" output="false" returnType="void">
	<cfargument name="from" type="string" required="true">
	<cfargument name="to" type="string" required="true">
	<cfargument name="subject" type="string" required="true">
	<cfargument name="body" type="string" required="false" default="">
	<cfargument name="htmlbody" type="string" required="false" default="">
	
	<cfif variables.server is "">
		<cfmail to="#arguments.to#" from="#arguments.from#" subject="#arguments.subject#">
			<cfif len(arguments.body)>
				<cfmailpart type="text">#arguments.body#</cfmailpart>
			</cfif>
			<cfif len(arguments.htmlbody)>
				<cfmailpart type="html">#arguments.htmlbody#</cfmailpart>
			</cfif>
		</cfmail>
	<cfelse>
		<cfmail to="#arguments.to#" from="#arguments.from#" subject="#arguments.subject#" server="#variables.server#" username="#variables.username#" password="#variables.password#">
			<cfif len(arguments.body)>
				<cfmailpart type="text">#arguments.body#</cfmailpart>
			</cfif>
			<cfif len(arguments.htmlbody)>
				<cfmailpart type="html">#arguments.htmlbody#</cfmailpart>
			</cfif>
		</cfmail>
	</cfif>

</cffunction>
	
<cffunction name="setSettings" access="public" output="No" returntype="void">
	<cfargument name="settings" required="true" hint="Setting">
	<cfset var mySettings = arguments.settings.getSettings()>
	<cfset variables.server = mySettings.mailServer>
	<cfset variables.username = mySettings.mailUsername>
	<cfset variables.password = mySettings.mailPassword>
</cffunction>
		
</cfcomponent>