<cfsetting enablecfoutputonly=true>
<!---
	Name         : pagination.cfm
	Author       : Raymond Camden 
	Created      : June 02, 2004
	Last Updated : October 12, 2007
	History      : Reset for V2
	Purpose		 : 
--->

<!--- Number of items per page and tracker variable. --->

<!--- used to determine if we show thread buttons --->
<cfparam name="attributes.mode" default="na">

<!--- used to determine if we show a new topic --->
<cfparam name="attributes.canpost" default="true">

<!--- what page am I on? --->
<cfparam name="url.page" default=1>
<cfif not isNumeric(url.page) or url.page lte 0>
	<cfset url.page = 1>
</cfif>

<!--- how many pages do I have? --->
<cfparam name="attributes.pages">


<cfoutput>
	
<!-- Pages and Button Start -->
	<div id="pages_btn">
	
		<!-- Top Button Start -->
		<div class="top_btn">
			<cfif (attributes.mode is "threads" or attributes.mode is "messages") and attributes.canpost>
				<a href="newpost.cfm?forumid=#request.forum.id#"><img src="/images/btn_new_topic.gif" alt="New Topic" title="New Topic"/></a>
				<cfif attributes.mode is "messages">
					<cfif not request.udf.isLoggedOn()>
						<cfset thisPage = cgi.script_name & "?" & cgi.query_string & "&##newpost">
						<cfset link = "login.cfm?ref=#urlEncodedFormat(thisPage)#">
						<a href="#link#"><img src="/images/btn_reply.gif" alt="Reply" title="New Topic"/></a>
					<cfelse>
						<a href="##newpost"><img src="/images/btn_reply.gif" alt="Reply" title="New Topic"/></a>
					</cfif>
				</cfif>
			</cfif>
			<cfif request.udf.isLoggedOn() and attributes.mode is not "na">
				<a href="profile.cfm?#cgi.query_string#&s=1"><img src="/images//btn_subscribe.gif" alt="Reply" title="New Topic"/></a>
			</cfif>
		</div>
		<!-- Top Button Ender -->
			
		<!-- Pages Start -->
		<div class="pages">
			<cfif url.page is attributes.pages>
				<img src="images/arrow_right_grey.gif" alt="Next Page"/>
			<cfelse>
				<a href="#cgi.script_name#?#qs#&page=#url.page+1#"><img src="images/arrow_right_active.gif" alt="Next Page"/></a>
			</cfif>
			<p>Page:
				<cfloop index="x" from=1 to="#attributes.pages#">
					<cfif url.page is not x><a href="#cgi.script_name#?#qs#&page=#x#">#x#</a><cfelse>#x#</cfif>
				</cfloop>
			</p>	
			<cfset qs = reReplaceNoCase(cgi.query_string,"\&*page=[^&]*","")>
			<cfif url.page is 1>
				<img src="images/arrow_left_grey.gif" alt="Previous Page"/>
			<cfelse>
				<a href="#cgi.script_name#?#qs#&page=#url.page-1#"><img src="images/arrow_left_active.gif" alt="Previous Page"/></a>
			</cfif>
		</div>
		<!-- Pages Ender -->
		
	</div>
<!-- Pages and Button Ender -->

</cfoutput>

<cfsetting enablecfoutputonly=false>

<cfexit method="EXITTAG">