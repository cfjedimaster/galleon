<cfsetting enablecfoutputonly=true>
<!---
	Name         : gen_stats.cfm
	Author       : Raymond Camden 
	Created      : August 28, 2005
	Last Updated : October 12, 2007
	History      : Reset for V2
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
select	count(id) as messages, min(posted) as earliestpost,
		max(posted) as lastpost
from	#application.settings.tableprefix#messages
</cfquery>

<cfoutput>
<div class="clearer"></div>
<div class="title_row">
	<p>General Stats</p>
</div>

<div class="row_0">
	<p class="left_50"><span>Number of Conferences:</span></p>
	<p class="left40">#cstats.conferenceCount#</p>

<div class="clearer"></div>
</div>

<div class="row_1">
	<p class="left_50"><span>Number of Forums:</span></p>
	<p class="left40">#fstats.forumCount#</p>
<div class="clearer"></div>
</div>

<div class="row_0">
	<p class="left_50"><span>Number of Threads:</span></p>
	<p class="left40">#tstats.threadCount#</p>
<div class="clearer"></div>
</div>

<div class="row_1">
	<p class="left_50"><span>Number of Messages:</span></p>
	<p class="left40">#mstats.messages#</p>

<div class="clearer"></div>
</div>

<div class="row_0">
	<p class="left_50"><span>First Post:</span></p>
	<p class="left40">#dateFormat(mstats.earliestPost, "m/d/yy")# #timeFormat(mstats.earliestPost, "h:mm tt")#</p>
<div class="clearer"></div>
</div>

<div class="row_1">
	<p class="left_50"><span>Last Post:</span></p>
	<p class="left40">#dateFormat(mstats.lastPost, "m/d/yy")# #timeFormat(mstats.lastPost, "h:mm tt")#</p>
<div class="clearer"></div>
</div>

<div class="row_0">
	<p class="left_50"><span>Number of Users:</span></p>
	<p class="left40">#ustats.userCount#</p>

<div class="clearer"></div>
</div>

<br /><br />
</cfoutput>

<cfsetting enablecfoutputonly=false>