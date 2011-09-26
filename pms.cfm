<cfsetting enablecfoutputonly=true>

<cfif not request.udf.isLoggedOn()>
	<cfset thisPage = cgi.script_name & "?" & cgi.query_string>
	<cflocation url="login.cfm?ref=#urlEncodedFormat(thisPage)#" addToken="false">
</cfif>

<cfif structKeyExists(url, "del")>
	<cfset application.user.deletePrivateMessage(url.del,getAuthUser())>
</cfif>

<cfparam name="url.sort" default="sent">
<cfparam name="url.sortdir" default="dir">

<cfset data = application.user.getPrivateMessages(getAuthUser(),sort,sortdir)>

<!--- Loads header --->
<cfmodule template="tags/layout.cfm" templatename="main" title="#application.settings.title# : Private Messages">

<!--- determine max pages --->
<cfif data.recordCount and data.recordCount gt application.settings.perpage>
	<cfset pages = ceiling(data.recordCount / application.settings.perpage)>
<cfelse>
	<cfset pages = 1>
</cfif>

<!--- clean up possible CSS attack --->
<cfset qs = replaceList(cgi.query_string,"<,>",",")>

<cfparam name="url.page" default=1>

<cfmodule template="tags/pagination.cfm" pages="#pages#" mode="messages" showButtons="false" />

<!--- Now display the table. This changes based on what our data is. --->
<cfoutput>	

	<!-- Content Start -->
	<div class="content_box">
		
		<div class="row_title">
			<p>Private Messages</p>
		</div>
		
		<div class="row_name">
			
			<div class="left_45 keep_on border_right"><p>#request.udf.headerLink("Subject","subject")#</p></div>
			<div class="left_15 keep_on border_right"><p>#request.udf.headerLink("Sender","sender")#</p></div>
			<div class="left_15 keep_on border_right"><p>#request.udf.headerLink("Sent","sent")#</p></div>			
			<div class="left_auto keep_on">&nbsp;</div>			
		</div>
		
		<cfif data.recordCount>
		<cfloop query="data" startrow="#(url.page-1)*application.settings.perpage+1#" endrow="#(url.page-1)*application.settings.perpage+application.settings.perpage#">
		<div class="row_#currentRow mod 2#">
			
			<div class="left_45 keep_on border_right"><p><cfif unread><b></cfif><a href="pm.cfm?id=#id#">#subject#</a><cfif unread></b></cfif></p></div>
			<div class="left_15 keep_on border_right"><p>#sender#</p></div>
			<div class="left_15 keep_on border_right"><p>#dateFormat(sent,"m/d/yy")# #timeFormat(sent,"h:mm tt")#</p></div>
			<div class="left_24 keep_on"><p><a href="pms.cfm?del=#id#">Delete</a></p></div>
			
		</div>
		</cfloop>
		<cfelse>
		<div class="row_1">
			<p>Sorry, but there are no messages for you.</p>
		</div>
		</cfif>	
		
	</div>
	<!-- Content End -->


</cfoutput>
	
</cfmodule>
<cfsetting enablecfoutputonly=false>
