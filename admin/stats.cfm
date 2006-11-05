<cfsetting enablecfoutputonly=true>
<!---
	Name         : stats.cfm
	Author       : Raymond Camden 
	Created      : July 5, 2004
	Last Updated : August 30, 2005
	History      : Removed mappings, abstracted stats (rkc 8/27/05)
				   Moved out charts for BD (rkc 8/30/05)
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