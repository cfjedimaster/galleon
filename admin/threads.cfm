<cfsetting enablecfoutputonly=true>
<!---
	Name         : threads.cfm
	Author       : Raymond Camden 
	Created      : June 09, 2004
	Last Updated : February 26, 2007
	History      : Removed mappings, changed cols (rkc 8/27/05)
				   Changed cols (rkc 9/9/05)
				   added filtering (rkc 2/26/07)				   
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
	<cfoutput>
	<p>
	<b>Thread(s) deleted.</b>
	</p>
	</cfoutput>
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
<p>
<form action="#cgi.script_name#?#cgi.query_string#" method="post">
<input type="text" name="search" value="#form.search#"> <input type="submit" value="Filter">
</form>
</p>
</cfoutput>

<cfmodule template="../tags/datatable.cfm" 
		  data="#threads#" list="name,lastpost,forum,conference,messagecount,sticky,active" 
		  editlink="threads_edit.cfm" linkcol="name" label="Thread" />


</cfmodule>

<cfsetting enablecfoutputonly=false>