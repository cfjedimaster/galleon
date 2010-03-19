<!---
	Name         : stats_charts.cfm
	Author       : Raymond Camden 
	Created      : August 30, 2004
	Last Updated : October 12, 2007
	History      : Reset for V2
	Purpose		 : 
--->

<!--- Disabling for now --->
<cfabort/>
<cfquery name="conferences" datasource="#application.settings.dsn#">
select	id, name
from	#application.settings.tableprefix#conferences
</cfquery>

<cfquery name="forums" datasource="#application.settings.dsn#">
select	id, name, conferenceidfk
from	#application.settings.tableprefix#forums
</cfquery>

<!---<cfset threads = application.thread.getThreads()>--->
<!---<cfset users = application.user.getUsers()>--->

<cfoutput>
<div class="title_row">
<p>Number of Forums Per Conference</p>
</div>

<cfchart format="flash" chartheight="400" chartwidth="400" seriesplacement="default" 
		 labelformat="number" tipstyle="mouseOver" pieslicestyle="sliced">
	<cfchartseries type="pie">
		<cfloop query="conferences">
			<cfquery name="fcount" dbtype="query">
			select	count(id) as total
			from	forums
			where	conferenceidfk = '#id#'
			</cfquery>
			<cfif fcount.total is "">
				<cfset total = 0>
			<cfelse>
				<cfset total = fcount.total>
			</cfif>
			<cfchartdata item="#name#" value="#total#">
		</cfloop>
	</cfchartseries>
</cfchart>
<cfdump var="#forums#">
<div class="title_row">
<p>Number of Threads Per Forum</p>
</div>
<!---
<cfchart format="flash" chartheight="400" chartwidth="400" seriesplacement="default" 
		 labelformat="number" tipstyle="mouseOver" pieslicestyle="sliced">
	<cfchartseries type="pie">
		<cfloop query="forums">			
			<cfquery name="fcount" dbtype="query">
			select	count(id) as total
			from	threads
			where	forumidfk = '#id#'
			</cfquery>
			<cfif fcount.total is "">
				<cfset total = 0>
			<cfelse>
				<cfset total = fcount.total>
			</cfif>
			<cfchartdata item="#name#" value="#total#">
		</cfloop>
	</cfchartseries>
</cfchart>
--->
<!---
<cfquery name="sortedThreads" dbtype="query">
	select		*
	from		threads
	order by	messages desc
</cfquery>

<div class="title_row">
	<p>Top 10 Threads by Message Count</p>
</div>

<div class="secondary_row">
	<p class="left_50"><span><strong>Thread Name</strong></span></p>
	<p class="left_40"><strong>Message Count</strong></p>
<div class="clearer"></div>
</div>

<cfloop query="sortedThreads" endrow="10">
	<cfif currentRow mod 2>
<div class="row_0">
	<cfelse>
<div class="row_1">
	</cfif>	
	<p class="left_50"><span>#name#</span></p>
	<p class="left_40">#messages#</p>
	<div class="clearer"></div>
</div>				
</cfloop>
--->
<!---
<cfquery name="sortedUsers" dbtype="query">
	select		*
	from		users
	order by	postcount desc
</cfquery>

<div class="title_row">
	<p>Top 10 Users by Post Count</p>
</div>

<div class="secondary_row">
	<p class="left_50"><span><strong>User Name</strong></span></p>
	<p class="left_40"><strong>Post Count</strong></p>
<div class="clearer"></div>
</div>

<cfloop query="sortedUsers" endrow="10">
	<cfif currentRow mod 2>
<div class="row_0">
	<cfelse>
<div class="row_1">
	</cfif>	
	<p class="left_50"><span>#username#</span></p>
	<p class="left_40">#postcount#</p>
	<div class="clearer"></div>
</div>				
</cfloop>
--->

</cfoutput>


