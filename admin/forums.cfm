<cfsetting enablecfoutputonly=true>
<!---
	Name         : forums.cfm
	Author       : Raymond Camden 
	Created      : June 01, 2004
	Last Updated : November 3, 2006
	History      : Removed mappings (rkc 8/27/05)
				   changed cols (rkc 9/9/05)
				   show attachments value (rkc 11/3/06)
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
		  data="#forums#" list="name,description,conference,messagecount,readonly,attachments,active" 
		  editlink="forums_edit.cfm" linkcol="name" label="Forum" />


</cfmodule>

<cfsetting enablecfoutputonly=false>