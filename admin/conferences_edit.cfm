<cfsetting enablecfoutputonly=true>
<!---
	Name         : conferences_edit.cfm
	Author       : Raymond Camden 
	Created      : June 01, 2004
	Last Updated : July 27, 2006
	History      : Removed mappings (rkc 8/27/05)
				 : Simple size change (rkc 7/27/06)
	Purpose		 : 
--->

<cfif isDefined("form.cancel") or not isDefined("url.id") or not len(url.id)>
	<cflocation url="conferences.cfm" addToken="false">
</cfif>

<cfif isDefined("form.save")>
	<cfset errors = "">
	<cfif not len(trim(form.name))>
		<cfset errors = errors & "You must specify a name.<br>">
	</cfif>
	<cfif not len(trim(form.description))>
		<cfset errors = errors & "You must specify a description.<br>">
	</cfif>
	<cfif not len(errors)>
		<cfset conference = structNew()>
		<cfset conference.name = trim(htmlEditFormat(form.name))>
		<cfset conference.description = trim(htmlEditFormat(form.description))>
		<cfset conference.active = trim(htmlEditFormat(form.active))>
		<cfif url.id neq 0>
			<cfset application.conference.saveConference(url.id, conference)>
		<cfelse>
			<cfset application.conference.addConference(conference)>
		</cfif>
		<cfset msg = "Conferfence, #conference.name#, has been updated.">
		<cflocation url="conferences.cfm?msg=#urlEncodedFormat(msg)#">
	</cfif>
</cfif>

<!--- get conference if not new --->
<cfif url.id neq "0">
	<cfset conference = application.conference.getConference(url.id)>
	<cfparam name="form.name" default="#conference.name#">
	<cfparam name="form.description" default="#conference.description#">
	<cfparam name="form.active" default="#conference.active#">
<cfelse>
	<cfparam name="form.name" default="">
	<cfparam name="form.description" default="">
	<cfparam name="form.active" default="false">
</cfif>

<cfmodule template="../tags/layout.cfm" templatename="admin" title="Conference Editor">

<cfoutput>
<p>
<cfif isDefined("errors")><ul><b>#errors#</b></ul></cfif>
<form action="#cgi.script_name#?#cgi.query_string#" method="post">
<table width="100%" cellspacing=0 cellpadding=5 class="adminEditTable">
	<tr valign="top">
		<td align="right"><b>Name:</b></td>
		<td><input type="text" name="name" value="#form.name#" size="100"></td>
	</tr>
	<tr valign="top">
		<td align="right"><b>Description:</b></td>
		<td><textarea name="description" rows=6 cols=35 wrap="soft">#form.description#</textarea></td>
	</tr>
	<tr valign="top">
		<td align="right"><b>Active:</b></td>
		<td><select name="active">
		<option value="1" <cfif form.active>selected</cfif>>Yes</option>
		<option value="0" <cfif not form.active>selected</cfif>>No</option>
		</select></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td><input type="submit" name="save" value="Save"> <input type="submit" name="cancel" value="Cancel"></td>
	</tr>
</table>
</form>
</p>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly=false>