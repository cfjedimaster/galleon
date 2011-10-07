<cfsetting enablecfoutputonly=true>

<!---
	Name         : threads.cfm
	Author       : Raymond Camden 
	Created      : June 10, 2004
	Last Updated : November 10, 2007
	History      : Reset for V2
				 : New link to last past (rkc 11/10/07)
	Purpose		 : Displays threads for a forum
--->

<cfif not isDefined("url.forumid") or not len(url.forumid)>
	<cflocation url="index.cfm" addToken="false">
</cfif>

<!--- get parents --->

<cftry>
	<cfset request.forum = application.forum.getForum(url.forumid)>
	<cfset request.conference = application.conference.getConference(request.forum.conferenceidfk)>
	<cfcatch>
		<cflocation url="index.cfm" addToken="false">
	</cfcatch>
</cftry>

<!--- Am I allowed to look at this? --->

<cfif not application.permission.allowed(application.rights.CANVIEW, url.forumid, request.udf.getGroups()) or 
		not application.permission.allowed(application.rights.CANVIEW, request.conference.id, request.udf.getGroups())>
	<cflocation url="denied.cfm" addToken="false">
</cfif>



<!--- get my threads --->
<cfset tdata = application.thread.getThreads(forumid=url.forumid)>
<cfset data = tdata.data>
<!--- sort --->
<cfset data = request.udf.querySort(data,url.sort,url.sortdir)>

<!--- Loads header --->

<cfmodule template="tags/layout.cfm" templatename="main" title="#application.settings.title# : #request.conference.name# : #request.forum.name#">

<!--- determine max pages --->

<cfif data.recordCount and data.recordCount gt application.settings.perpage>
	<cfset pages = ceiling(data.recordCount / application.settings.perpage)>
<cfelse>
	<cfset pages = 1>
</cfif>

<!--- Before we call our header, we need to know if we can write. --->
<cfif application.permission.allowed(application.rights.CANPOST, url.forumid, request.udf.getGroups()) and
		application.permission.allowed(application.rights.CANPOST, request.conference.id, request.udf.getGroups())>
	<cfset canPost = true>
<cfelse>
	<cfset canPost = false>
</cfif>

<!--- Displays pagination on right side, plus left side buttons for threads --->
<cfmodule template="tags/pagination.cfm" pages="#pages#" mode="threads" canPost="#canPost#" />

<!--- Now display the table. This changes based on what our data is. --->
<cfoutput>


	<!-- Content Start -->
	<div class="content_box">
		
		<div class="row_title">
			<p>Forum: #request.forum.name#</p>
		</div>
		
		<div class="row_name">
			
			<div class="left_45 keep_on border_right"><p>#request.udf.headerLink("Thread","name")#</p></div>
			<div class="left_15 keep_on border_right"><p>#request.udf.headerLink("Originator","username")#</p></div>
			<div class="left_15 keep_on border_right"><p>#request.udf.headerLink("Replies","messages")#</p></div>
			<div class="left_auto keep_on"><p>#request.udf.headerLink("Last Post","lastpostcreated")#</p></div>
			
		</div>
		<cfif data.recordCount>
		<cfloop query="data" startrow="#(url.page-1)*application.settings.perpage+1#" endrow="#(url.page-1)*application.settings.perpage+application.settings.perpage#">
		<!--- I add this because it is possible for a thread to have 0 posts. --->
			<cfif messages is "" or messages is 0>
				<cfset mcount = 0>
			<cfelse>
				<cfset mcount = messages - 1>
			</cfif>			
		<div class="row_#currentRow mod 2#">
			
			<div class="left_45 keep_on border_right"><p><cfif isBoolean(sticky) and sticky><b>[Sticky]</b></cfif> <a href="messages.cfm?threadid=#id#">#name#</a></p></div>
			<div class="left_15 keep_on border_right"><p>#username#</p></div>
			<div class="left_15 keep_on border_right"><p>#mcount#</p></div>
			<div class="left_24 keep_on">
				<p><cfif len(lastpostuseridfk)>
				<cfset uinfo = cachedUserInfo(username=lastpostuseridfk,userid=true)>
				<a href="messages.cfm?threadid=#id#&last##last">#dateFormat(lastpostcreated,"m/d/yy")# #timeFormat(lastpostcreated,"h:mm tt")#</a> by #uinfo.username#
				<cfelse>&nbsp;</cfif></p>
			</div>
			
		</div>
		</cfloop>
		<cfelse>
		<div class="row_1">
			<p>Sorry, but there are no threads available for this forum.</p>
		</div>
		</cfif>	
		
	</div>
	<!-- Content End -->

</cfoutput>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>
