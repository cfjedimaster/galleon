<cfsetting enablecfoutputonly=true>
<!---
	Name         : index.cfm
	Author       : Raymond Camden 
	Created      : June 10, 2004
	Last Updated : October 12, 2007
	History      : Reset for V2
	Purpose		 : Displays conferences
--->

<!--- get my conferences --->
<cfset data = application.conference.getConferences()>
<!--- filter by what I can read... --->
<cfset data = application.permission.filter(query=data, groups=request.udf.getGroups(), right=application.rights.CANVIEW)>

<!--- if just one, auto go to a forums for it --->
<cfif data.recordCount is 1>
	<cflocation url="forums.cfm?conferenceid=#data.id#" addToken="false">
</cfif>

<!--- sort --->
<cfset data = request.udf.querySort(data,url.sort,url.sortdir)>

<!--- Loads header --->
<cfmodule template="tags/layout.cfm" templatename="main" title="#application.settings.title#">

<!--- determine max pages --->
<cfif data.recordCount and data.recordCount gt application.settings.perpage>
	<cfset pages = ceiling(data.recordCount / application.settings.perpage)>
<cfelse>
	<cfset pages = 1>
</cfif>

<!--- Displays pagination on right side, plus left side buttons for threads --->
<cfmodule template="tags/pagination.cfm" pages="#pages#" />

<!--- Now display the table. This changes based on what our data is. --->
<cfoutput>
	
	
<!-- Content Start -->
	<div class="content_box">
		
		<div class="row_title">
			<p>Conferences</p>
		</div>
		
		<div class="row_name">
			
			<div class="left_20 keep_on border_right"><p>#request.udf.headerLink("Name")#</p></div>
			<div class="left_40 keep_on border_right"><p>#request.udf.headerLink("Description")#</p></div>
			<div class="left_10 keep_on border_right"><p>#request.udf.headerLink("Messages","messages")#</p></div>
			<div class="left_auto keep_on"><p>#request.udf.headerLink("Last Post","lastpost")#</p></div>
			
		</div>

		<cfif data.recordCount>
		<!--- Have to 'fake out' CF since it doesn't like named params with udfs in a struct --->
		<cfset cachedUserInfo = request.udf.cachedUserInfo>
		<cfloop query="data" startrow="#(url.page-1)*application.settings.perpage+1#" endrow="#(url.page-1)*application.settings.perpage+application.settings.perpage#">		
		<div class="row_#currentRow mod 2#">	
			<div class="left_20 keep_on border_right"><p><a href="forums.cfm?conferenceid=#id#">#name#</a></p></div>
			<div class="left_40 keep_on border_right"><p>#description#</p></div>
			<div class="left_10 keep_on border_right"><p>#messages#</p></div>
			<div class="left_auto keep_on"><p><cfif len(lastpostuseridfk)>
				<cfset uinfo = cachedUserInfo(username=lastpostuseridfk,userid=true)>
				<a href="messages.cfm?threadid=#lastpost###last">#dateFormat(lastpostcreated,"m/d/yy")# #timeFormat(lastpostcreated,"h:mm tt")#</a> by #uinfo.username#
				<cfelse>&nbsp;</cfif></p>
			</div>
		</div>
		</cfloop>
		<cfelse>
		<div class="row_0">	
			<p>Sorry, but there are no conferences available.</p>
		</div>
		</cfif>

	</div>
	<!-- Content End -->
	

</cfoutput>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>
