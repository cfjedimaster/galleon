<cfsetting enablecfoutputonly=true>
<!---
	Name         : index.cfm
	Author       : Raymond Camden 
	Created      : June 10, 2004
	Last Updated : August 4, 2006
	History      : show msgcount, last msg (rkc 4/6/05)
				   Fixed code that gets # of pages (rkc 4/8/05)
				   Right colspan if no data (rkc 4/15/05)
				   use addToken=false in auto-push (rkc 4/15/05)
				   Remove mappings (rkc 8/27/05)
				   support sorting, fix pages (rkc 9/15/05)
				   show last user (rkc 7/12/06)
				   show right title (rkc 8/4/06)
	Purpose		 : Displays conferences
--->

<!--- get my conferences --->
<cfset data = application.conference.getConferences()>

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
<p>
<table width="100%" cellpadding="6" class="tableDisplay" cellspacing="1" border="0">
	<tr class="tableHeader">
		<td colspan="4" class="tableHeader">Conferences</td>
	</tr>
	<tr class="tableSubHeader">
		<td class="tableSubHeader">#request.udf.headerLink("Name")#</td>
		<td class="tableSubHeader">#request.udf.headerLink("Description")#</td>
		<td class="tableSubHeader">#request.udf.headerLink("Messages","messagecount")#</td>
		<td class="tableSubHeader">#request.udf.headerLink("Last Post","lastpost")#</td>
	</tr>
	<cfif data.recordCount>
		<!--- Have to 'fake out' CF since it doesn't like named params with udfs in a struct --->
		<cfset cachedUserInfo = request.udf.cachedUserInfo>
		<cfloop query="data" startrow="#(url.page-1)*application.settings.perpage+1#" endrow="#(url.page-1)*application.settings.perpage+application.settings.perpage#">
			<tr class="tableRow#currentRow mod 2#">
				<td><a href="forums.cfm?conferenceid=#id#">#name#</a></td>
				<td>#description#</td>
				<td>#messagecount#</td>
				<td><cfif len(useridfk)>
				<cfset uinfo = cachedUserInfo(username=useridfk,userid=true)>
				<a href="messages.cfm?threadid=#threadidfk###last">#dateFormat(lastpost,"m/d/yy")# #timeFormat(lastpost,"h:mm tt")#</a> by #uinfo.username#
				<cfelse>&nbsp;</cfif></td>
			</tr>
		</cfloop>
	<cfelse>
		<tr class="tableRow1">
			<td colspan="4">Sorry, but there are no conferences available.</td>
		</tr>
	</cfif>
</table>
</p>
</cfoutput>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>
