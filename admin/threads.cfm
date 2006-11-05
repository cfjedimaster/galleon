<cfsetting enablecfoutputonly=true>
<!---
	Name         : threads.cfm
	Author       : Raymond Camden 
	Created      : June 09, 2004
	Last Updated : September 9, 2005
	History      : Removed mappings, changed cols (rkc 8/27/05)
				   Changed cols (rkc 9/9/05)
	Purpose		 : 
--->

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

<cfmodule template="../tags/datatable.cfm" 
		  data="#threads#" list="name,lastpost,forum,conference,messagecount,sticky,active" 
		  editlink="threads_edit.cfm" linkcol="name" label="Thread" />


</cfmodule>

<cfsetting enablecfoutputonly=false>