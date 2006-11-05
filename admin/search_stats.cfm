<cfsetting enablecfoutputonly=true>
<!---
	Name         : index.cfm
	Author       : Raymond Camden 
	Created      : January 31, 2005
	Last Updated : August 27, 2005
	History      : Removed mappings, use of prefix (rkc 8/27/05)
	Purpose		 : 
--->

<cfset prefix = application.settings.tableprefix>

<!--- will be used to generate general stats - so we get all from the last 365 days --->
<cfset oldest = dateAdd("d", -365, now())>
<cfquery datasource="#application.settings.dsn#" name="searchstats">
	select	searchterms, datesearched
	from	#prefix#search_log
	where	datesearched > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#oldest#">
</cfquery>

<!--- ineffecient - but gets around the lack of a limit op in ms access --->
<cfquery name="latest" dbtype="query" maxrows="1">
	select searchterms, datesearched
	from	searchstats
	order by datesearched desc
</cfquery>

<cfset today = createDateTime(year(now()), month(now()), day(now()), 0,0,0)>
<cfquery name="todaysbest" dbtype="query" maxrows="1">
	select	searchterms, count(searchterms) as score
	from	searchstats
	where	datesearched > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#today#">
	group by searchterms
	order by score desc
</cfquery>

<cfset past30 = dateAdd("d", -30, now())>
<cfquery name="thismonth" dbtype="query" maxrows="1">
	select	searchterms, count(searchterms) as score
	from	searchstats
	where	datesearched > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#past30#">
	group by searchterms
	order by score desc
</cfquery>

<cfset past365 = dateAdd("d", -365, now())>
<cfquery name="thisyear" dbtype="query" maxrows="1">
	select	searchterms, count(searchterms) as score
	from	searchstats
	where	datesearched > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#past365#">
	group by searchterms
	order by score desc
</cfquery>

<cfquery name="top30" dbtype="query" maxrows="30">
	select	searchterms, count(searchterms) as score
	from	searchstats
	group by searchterms
	order by score desc
</cfquery>
	
<cfmodule template="../tags/layout.cfm" templatename="admin" title="Galleon Search Stats">

<cfoutput>
<p>
<table class="adminListTable" width="500">
<tr class="adminListHeader">
	<td colspan="2"><b>General Stats</b></td>
</tr>
<tr>
	<td><b>Latest Search:</b></td>
	<td>#latest.searchterms[1]# (#dateFormat(latest.dateSearched[1],"m/d/yy")# at #timeFormat(latest.dateSearched[1],"h:mm tt")#)</td>
</tr>
<tr>
	<td><b>Most Popular (Today):</b></td>
	<td>#todaysbest.searchterms# (#todaysbest.score#)</td>
</tr>
<tr>
	<td><b>Most Popular (Past 30 Days):</b></td>
	<td>#thismonth.searchterms# (#thismonth.score#)</td>
</tr>
<tr>
	<td><b>Most Popular (Past 365 Days):</b></td>
	<td>#thisyear.searchterms# (#thisyear.score#)</td>
</tr>
</table>
</p>

<p>
<table class="adminListTable" width="500">
<tr class="adminListHeader">
	<td colspan="2"><b>Top 30 Search Terms</b></td>
</tr>
<cfloop query="top30">
	<tr>
		<td>#searchTerms#</td>
		<td>#score#</td>
	</tr>
</cfloop>
</table>
</p>

</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly=false>