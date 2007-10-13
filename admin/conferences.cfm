<cfsetting enablecfoutputonly=true>
<!---
	Name         : conferences.cfm
	Author       : Raymond Camden 
	Created      : June 01, 2004
	Last Updated : October 12, 2007
	History      : Reset for V2
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
		  data="#conferences#" list="name,description,lastpostcreated,messages,active" 
		  classlist="left_20,left_30,left_20,left_10 align_center,right_10 align_center"
		  editlink="conferences_edit.cfm" linkcol="name" label="Conference" />


</cfmodule>

<cfsetting enablecfoutputonly=false>