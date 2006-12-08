<cfsetting enablecfoutputonly=true>
<!---
	Name         : gen_stats.cfm
	Author       : Raymond Camden 
	Created      : August 28, 2005
	Last Updated : December 8, 2006
	History      : Added a few &nbsp; (rkc 11/6/06)
				 : Changed how I got data to make it quicker (rkc 12/8/06)
	Purpose		 : general stats used both on home page and stats
--->

<cfquery name="cstats" datasource="#application.settings.dsn#">
select	count(id) as conferencecount
from	#application.settings.tableprefix#conferences
</cfquery>

<cfquery name="fstats" datasource="#application.settings.dsn#">
select	count(id) as forumcount
from	#application.settings.tableprefix#forums
</cfquery>

<cfquery name="tstats" datasource="#application.settings.dsn#">
select	count(id) as threadcount
from	#application.settings.tableprefix#threads
</cfquery>

<cfquery name="ustats" datasource="#application.settings.dsn#">
select	count(id) as usercount
from	#application.settings.tableprefix#users
</cfquery>


<cfquery name="mstats" datasource="#application.settings.dsn#">
select	count(id) as messagecount, min(posted) as earliestpost,
		max(posted) as lastpost
from	#application.settings.tableprefix#messages
</cfquery>

<cfoutput>
<p>
<table class="adminListTable" width="500">
<tr class="adminListHeader">
	<td colspan="2"><b>General Stats</b></td>
</tr>
<tr>
	<td><b>Number of Conferences:</b></td>
	<td>#cstats.conferenceCount#</td>
</tr>
<tr>
	<td><b>Number of Forums:</b></td>
	<td>#fstats.forumCount#</td>
</tr>
<tr>
	<td><b>Number of Threads:</b></td>
	<td>#tstats.threadCount#</td>
</tr>
<tr>
	<td><b>Number of Messages:</b></td>
	<td>#mstats.messageCount#</td>
</tr>
<tr>
	<td><b>First Post:</b></td>
	<td>#dateFormat(mstats.earliestPost, "m/d/yy")# #timeFormat(mstats.earliestPost, "h:mm tt")#&nbsp;</td>
</tr>
<tr>
	<td><b>Last Post:</b></td>
	<td>#dateFormat(mstats.lastPost, "m/d/yy")# #timeFormat(mstats.lastPost, "h:mm tt")#&nbsp;</td>
</tr>
<tr>
	<td><b>Number of Users:</b></td>
	<td>#ustats.userCount#</td>
</tr>

</table>
</p>
</cfoutput>

<cfsetting enablecfoutputonly=false>