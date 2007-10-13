<cfsetting enablecfoutputonly=true>
<!---
	Name         : stats.cfm
	Author       : Raymond Camden 
	Created      : July 5, 2004
	Last Updated : October 12, 2007
	History      : Reset for V2
	Purpose		 : 
--->

<cfset charts = true>
<cfif server.coldfusion.productname is "BlueDragon">
	<cfset charts = false>
</cfif>

<cfmodule template="../tags/layout.cfm" templatename="admin" title="Galleon Stats">

<cfinclude template="gen_stats.cfm">

<cfif charts>
	<cfinclude template="stats_charts.cfm">
<cfelse>
	<cfoutput>
	Sorry, CFCHART is not available in BlueDragon.
	</cfoutput>
</cfif>

</cfmodule>

<cfsetting enablecfoutputonly=false>