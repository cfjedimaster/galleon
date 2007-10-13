<cfsetting enablecfoutputonly=true>
<!---
	Name         : error.cfm
	Author       : Raymond Camden 
	Created      : September 15, 2005
	Last Updated : June 22 2005
	History      : 	
	Purpose		 : Handles errors
--->

<!--- Send the error report --->
<cfsavecontent variable="mail">
<cfoutput>
Error Occured:<br>
<table border="1" width="100%">
	<tr>
		<td>Date:</td>
		<td>#dateFormat(now(),"m/d/yy")# #timeFormat(now(),"h:mm tt")#</td>
	</tr>
	<tr>
		<td>Script Name:</td>
		<td>#cgi.script_name#?#cgi.query_string#</td>
	</tr>
	<tr>
		<td>Browser:</td>
		<td>#error.browser#</td>
	</tr>
	<tr>
		<td>Referer:</td>
		<td>#error.httpreferer#</td>
	</tr>
	<tr>
		<td>Message:</td>
		<td>#error.message#</td>
	</tr>
	<tr>
		<td>Type:</td>
		<td>#error.type#</td>
	</tr>
	<cfif structKeyExists(error,"rootcause")>
	<tr>
		<td>Root Cause:</td>
		<td><cfdump var="#error.rootcause#"></td>
	</tr>
	</cfif>
	<tr>
		<td>Tag Context:</td>
		<td><cfdump var="#error.tagcontext#"></td>
	</tr>
</table>
</cfoutput>
</cfsavecontent>

<cfmail to="#application.settings.sendonpost#" from="#application.settings.sendonpost#" type="html" subject="Error Report">#mail#</cfmail>

<cfmodule template="tags/layout.cfm" templatename="main" title="Error">

	<cfoutput>
	<p>
	We are sorry, but an error has occured.<br>
	The administrator has been notified.
	</p>
	</cfoutput>
	
	<cfif isUserInRole("forumsadmin") or 1>
		<cfoutput>#mail#</cfoutput>
	</cfif>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>