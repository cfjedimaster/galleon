<cfsetting enablecfoutputonly=true>
<!---
	Name         : forums.cfm
	Author       : Raymond Camden 
	Created      : June 10, 2004
	Last Updated : November 10, 2007
	History      : Reset for V2
				 : New link to last past (rkc 11/10/07)
	Purpose		 : Displays forums for conference
--->

<cfif not isDefined("url.conferenceid") or not len(url.conferenceid)>
	<cflocation url="index.cfm" addToken="false">
</cfif>

<!--- get parent conference --->
<cftry>
	<cfset request.conference = application.conference.getConference(url.conferenceid)>
	<cfcatch>
		<cflocation url="index.cfm" addToken="false">
	</cfcatch>
</cftry>

<!--- Am I allowed to look at this? --->
<cfif not application.permission.allowed(application.rights.CANVIEW, url.conferenceid, request.udf.getGroups())>
	<cflocation url="denied.cfm" addToken="false">
</cfif>

<!--- get my forums --->
<cfset data = application.forum.getForums(conferenceid=url.conferenceid)>
<!--- filter by what I can read... --->
<cfset data = application.permission.filter(query=data, groups=request.udf.getGroups(), right=application.rights.CANVIEW)>

<!--- sort --->
<cfset data = request.udf.querySort(data,url.sort,url.sortdir)>

<!--- Loads header --->
<cfmodule template="tags/layout.cfm" templatename="main" title="#application.settings.title# : #request.conference.name#">

<!--- determine max pages --->
<cfif data.recordCount and data.recordCount gt application.settings.perpage>
	<cfset pages = ceiling(data.recordCount / application.settings.perpage)>
<cfelse>
	<cfset pages = 1>
</cfif>

<!--- Displays pagination on right side, plus left side buttons for threads --->
<cfmodule template="tags/pagination.cfm" pages="#pages#" mode="conference" />

<!--- Now display the table. This changes based on what our data is. --->
<cfoutput>
	
	<!-- Content Start -->
	<div class="content_box">
		
		<div class="row_title">
			<p>Conference: #request.conference.name#</p>
		</div>
		
		<div class="row_name">
			
			<div class="left_20 keep_on border_right"><p>#request.udf.headerLink("Forum","name")#</p></div>
			<div class="left_40 keep_on border_right"><p>#request.udf.headerLink("Description")#</p></div>
			<div class="left_10 keep_on border_right"><p>#request.udf.headerLink("Messages","messages")#</p></div>
			<div class="left_auto keep_on"><p>#request.udf.headerLink("Last Post","lastpost")#</p></div>
			
		</div>
		<cfif data.recordCount>
		<cfset cachedUserInfo = request.udf.cachedUserInfo>
		<cfloop query="data" startrow="#(url.page-1)*application.settings.perpage+1#" endrow="#(url.page-1)*application.settings.perpage+application.settings.perpage#">			
		<div class="row_#currentRow mod 2#">
			
			<div class="left_20 keep_on border_right"><p><a href="threads.cfm?forumid=#id#">#name#</a></p></div>
			<div class="left_40 keep_on border_right"><p>#description#</p></div>
			<div class="left_10 keep_on border_right"><p>#messages#</p></div>
			<div class="left_auto keep_on">
				<p><cfif len(lastpostuseridfk)>
				<cfset uinfo = cachedUserInfo(username=lastpostuseridfk,userid=true)>
				<a href="messages.cfm?threadid=#lastpost#&last##last">#dateFormat(lastpostcreated,"m/d/yy")# #timeFormat(lastpostcreated,"h:mm tt")#</a> by #uinfo.username#
				<cfelse>&nbsp;</cfif></p>
			</div>
			
		</div>
		</cfloop>
		<cfelse>
		<div class="row_0">Sorry, but there are no forums available for this conference.</div>						
		</cfif>
				
	</div>
	<!-- Content End -->

</cfoutput>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>
