<cfsetting enablecfoutputonly=true>
<!---
	Name         : Application.cfm
	Author       : Raymond Camden 
	Created      : June 01, 2004
	Last Updated : October 12, 2007
	History      : Reset for V2
	Purpose		 : 
--->

<!--- include root app --->
<cfset variables.isAdmin = true>
<cfinclude template="../Application.cfm">

<cfif not request.udf.isLoggedOn()>
	<cfinclude template="login.cfm">
	<cfabort>
</cfif>

<!--- must be the correct authentication --->
<cfif not isUserInRole("forumsadmin")>
	<cflocation url="../" addtoken="false">
	<cfabort>
</cfif>

<cfsetting enablecfoutputonly=false>