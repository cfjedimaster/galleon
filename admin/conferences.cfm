<cfsetting enablecfoutputonly=true>
<!---
	Name         : conferences.cfm
	Author       : Raymond Camden 
	Created      : June 01, 2004
	Last Updated : September 9, 2005
	History      : Removed mappings (rkc 8/27/05)
				   Changed cols (rkc 9/9/05)
	Purpose		 : 
--->

<cfmodule template="../tags/layout.cfm" templatename="admin" title="Conference Editor">

<!--- handle deletions --->
<cfif isDefined("form.mark") and len(form.mark)>
	<cfloop index="id" list="#form.mark#">
		<cfset application.conference.deleteConference(id)>
	</cfloop>
	<cfoutput>
	<p>
	<b>Conference(s) deleted.</b>
	</p>
	</cfoutput>
</cfif>

<!--- get conferences --->
<cfset conferences = application.conference.getConferences(false)>

<cfmodule template="../tags/datatable.cfm" 
		  data="#conferences#" list="name,description,lastpost,messagecount,active" 
		  editlink="conferences_edit.cfm" linkcol="name" label="Conference" />


</cfmodule>

<cfsetting enablecfoutputonly=false>