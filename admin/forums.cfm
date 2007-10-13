<cfsetting enablecfoutputonly=true>
<!---
	Name         : forums.cfm
	Author       : Raymond Camden 
	Created      : June 01, 2004
	Last Updated : October 12, 2007
	History      : Reset for V2
	Purpose		 : 
--->

<cfmodule template="../tags/layout.cfm" templatename="admin" title="Forum Editor">

<!--- handle deletions --->
<cfif isDefined("form.mark") and len(form.mark)>
	<cfloop index="id" list="#form.mark#">
		<cfset application.forum.deleteForum(id)>
	</cfloop>
	<cfoutput>
	<p>
	<b>Forum(s) deleted.</b>
	</p>
	</cfoutput>
</cfif>

<!--- get forums --->
<cfset forums = application.forum.getForums(false)>

<cfmodule template="../tags/datatable.cfm" 
		  data="#forums#" list="name,description,conference,lastpostcreated,messages,active" 
		  classList="left_20,left_25,left_15 align_center,left_15 align_center,left_10 align_center,right_10 align_center"
		  editlink="forums_edit.cfm" linkcol="name" label="Forum" />


</cfmodule>

<cfsetting enablecfoutputonly=false>