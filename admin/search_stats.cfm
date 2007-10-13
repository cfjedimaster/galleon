<cfsetting enablecfoutputonly=true>
<!---
	Name         : index.cfm
	Author       : Raymond Camden 
	Created      : January 31, 2005
	Last Updated : October 12, 2007
	History      : Reset for V2
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
<div class="clearer"></div>
<div class="title_row">
<p>General Stats</p>
</div>

<div class="row_0">
	<p class="left_50"><span>Latest Search</span></p>
	<p class="left40"><cfif latest.searchterms[1] neq "">#latest.searchterms[1]# (#dateFormat(latest.dateSearched[1],"m/d/yy")# at #timeFormat(latest.dateSearched[1],"h:mm tt")#)<cfelse>No data</cfif>
</p>
<div class="clearer"></div>
</div>

<div class="row_1">
	<p class="left_50"><span>Most Popular (Today)</span></p>
	<p class="left40">
<cfif todaysbest.searchterms neq "">#todaysbest.searchterms# (#todaysbest.score#)<cfelse>No data</cfif>
	</p>
<div class="clearer"></div>
</div>

<div class="row_0">
	<p class="left_50"><span>Most Popular (Past 30 Days)</span></p>
	<p class="left40">
<cfif thismonth.searchterms neq "">#thismonth.searchterms# (#thismonth.score#)<cfelse>No data</cfif>
	</p>
<div class="clearer"></div>
</div>

<div class="row_1">
	<p class="left_50"><span>Most Popular (Past 365 Days)</span></p>
	<p class="left40">
<cfif thisyear.searchterms neq "">#thisyear.searchterms# (#thisyear.score#)<cfelse>No data</cfif>
	</p>
<div class="clearer"></div>
</div>


<div class="title_row">
<p>Top 30 Search Terms</p>
</div>

<cfif top30.recordCount>
	<cfloop query="top30">
		<cfif currentRow mod 2>
	<div class="row_0">
		<cfelse>
	<div class="row_1">
		</cfif>		
	<p class="left_50"><span>#searchTerms#</span></p>
	<p class="left40">#score#</p>
	</div>
	<div class="clearer"></div>
	</cfloop>
<cfelse>
No data.
</cfif>

</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly=false>