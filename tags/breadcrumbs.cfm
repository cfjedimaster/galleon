<cfsetting enablecfoutputonly=true>
<!---
	Name         : breadcrumbs.cfm
	Author       : Raymond Camden 
	Created      : June 10, 2004
	Last Updated : July 12, 2004
	History      : minor layout mod (rkc 7/12/06)
	Purpose		 : Used by the main page template to generate a bread crumb. 
--->

<cfoutput>
<div class="topMenu">
<a href="index.cfm">Home</a>
<cfif isDefined("request.conference")>
	&gt; <a href="forums.cfm?conferenceid=#request.conference.id#">#request.conference.name#</a>
</cfif>
<cfif isDefined("request.forum")>
	&gt; <a href="threads.cfm?forumid=#request.forum.id#">#request.forum.name#</a>
</cfif>
<cfif isDefined("request.thread")>
	&gt; <a href="messages.cfm?threadid=#request.thread.id#">#request.thread.name#</a>
</cfif>
</div>
</cfoutput>

<cfsetting enablecfoutputonly=false>

<cfexit method="EXITTAG">