<cfsetting enablecfoutputonly=true>
<!---
	Name         : gen_stats.cfm
	Author       : Raymond Camden 
	Created      : August 28, 2005
	Last Updated : 
	History      : 
	Purpose		 : general stats used both on home page and stats
--->

<cfset conferences = application.conference.getConferences()>
<cfset forums = application.forum.getForums()>
<cfset threads = application.thread.getThreads()>
<cfset users = application.user.getUsers()>
<cfset messages = application.message.getMessages()>

<!--- get first post --->
<cfquery name="getMinPost" dbtype="query">
select 	min(posted) as earliestPost
from	messages
</cfquery>

<!--- get last post --->
<cfquery name="getMaxPost" dbtype="query">
select 	max(posted) as lastPost
from	messages
</cfquery>

<cfoutput>
<p>
<table class="adminListTable" width="500">
<tr class="adminListHeader">
	<td colspan="2"><b>General Stats</b></td>
</tr>
<tr>
	<td><b>Number of Conferences:</b></td>
	<td>#conferences.recordCount#</td>
</tr>
<tr>
	<td><b>Number of Forums:</b></td>
	<td>#forums.recordCount#</td>
</tr>
<tr>
	<td><b>Number of Threads:</b></td>
	<td>#threads.recordCount#</td>
</tr>
<tr>
	<td><b>Number of Messages:</b></td>
	<td>#messages.recordCount#</td>
</tr>
<tr>
	<td><b>First Post:</b></td>
	<td>#dateFormat(getMinPost.earliestPost, "m/d/yy")# #timeFormat(getMinPost.earliestPost, "h:mm tt")#</td>
</tr>
<tr>
	<td><b>Last Post:</b></td>
	<td>#dateFormat(getMaxPost.lastPost, "m/d/yy")# #timeFormat(getMaxPost.lastPost, "h:mm tt")#</td>
</tr>
<tr>
	<td><b>Number of Users:</b></td>
	<td>#users.recordCount#</td>
</tr>

</table>
</p>
</cfoutput>

<cfsetting enablecfoutputonly=false>