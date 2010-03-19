<cfsetting enablecfoutputonly=true>
<!---
	Name         : threads.cfm
	Author       : Raymond Camden 
	Created      : June 09, 2004
	Last Updated : December 13, 2007
	History      : Reset for V2
				   Fixed filtering code (rkc 12/13/07)
	Purpose		 : 
--->

<cfparam name="url.search" default="">
<cfparam name="form.search" default="#url.search#">
<cfparam name="url.start" default="1">
<cfparam name="url.sort" default="lastpostcreated">
<cfparam name="url.dir" default="desc">

<cfmodule template="../tags/layout.cfm" templatename="admin" title="Thread Editor">

<!--- handle deletions --->
<cfif isDefined("form.mark") and len(form.mark)>
	<cfloop index="id" list="#form.mark#">
		<cfset application.thread.deleteThread(id)>
	</cfloop>
	<cfset url.msg = "Thread(s) deleted.">
</cfif>

<!--- get threads --->
<cfset threads = application.thread.getThreads(bActiveOnly=false,start=url.start, max=10, sort="#url.sort# #url.dir#", search=form.search)>

<cfoutput>
<div class="top_input_misc">
	<cfset qs = cgi.query_string>
	<cfset qs = rereplace(qs, "&*page=[0-9]+", "")>
<form action="#cgi.script_name#?#qs#" method="post">
<input type="text" name="search" value="#form.search#" class="filter_input"> <input type="image" src="../images/btn_filter.jpg" value="Filter" class="filter_btn">
</form>
</div>
</cfoutput>

<cfmodule template="../tags/datatablenew.cfm" 
		  data="#threads.data#" list="name,lastpostcreated,forum,conference,messages,sticky,active"
		  		  total="#threads.total#" perpage=10 start="#url.start#"
			nosort="forum,conference,sticky"
		  classList="left_15,left_15,left_20,left_15,left_10 align_center,left_10 align_center,left_10 align_center" 
		  editlink="threads_edit.cfm" linkcol="name" label="Thread" linkappend="&search=#urlEncodedFormat(form.search)#"/>


</cfmodule>

<cfsetting enablecfoutputonly=false>