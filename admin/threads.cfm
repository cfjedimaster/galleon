<cfsetting enablecfoutputonly=true>
<!---
	Name         : threads.cfm
	Author       : Raymond Camden 
	Created      : June 09, 2004
	Last Updated : October 12, 2007
	History      : Reset for V2
	Purpose		 : 
--->

<cfparam name="url.search" default="">
<cfparam name="form.search" default="#url.search#">

<cfmodule template="../tags/layout.cfm" templatename="admin" title="Thread Editor">

<!--- handle deletions --->
<cfif isDefined("form.mark") and len(form.mark)>
	<cfloop index="id" list="#form.mark#">
		<cfset application.thread.deleteThread(id)>
	</cfloop>
	<cfset url.msg = "Thread(s) deleted.">
</cfif>

<!--- get threads --->
<cfset threads = application.thread.getThreads(false)>

<cfif len(trim(form.search))>
	<cfquery name="threads" dbtype="query">
	select	*
	from	threads
	where	lower(name) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#lcase(form.search)#%"> 
	</cfquery>
</cfif>

<cfoutput>
<div class="top_input_misc">
<form action="#cgi.script_name#?#cgi.query_string#" method="post">
<input type="text" name="search" value="#form.search#" class="filter_input"> <input type="image" src="../images/btn_filter.jpg" value="Filter" class="filter_btn">
</form>
</div>
</cfoutput>

<cfmodule template="../tags/datatable.cfm" 
		  data="#threads#" list="name,lastpostcreated,forum,conference,messages,sticky,active"
		  classList="left_15,left_15,left_20,left_15,left_10 align_center,left_10 align_center,left_10 align_center" 
		  editlink="threads_edit.cfm" linkcol="name" label="Thread" />


</cfmodule>

<cfsetting enablecfoutputonly=false>