<cfsetting enablecfoutputonly=true>
<!---
	Name         : forums_edit.cfm
	Author       : Raymond Camden 
	Created      : June 01, 2004
	Last Updated : November 11, 2006
	History      : Removed mappings (rkc 8/27/05)
				 : Simple size change (rkc 7/27/06)	
				 : Allow attachments (rkc 11/6/06)
	Purpose		 : 
--->

<cfif isDefined("form.cancel") or not isDefined("url.id") or not len(url.id)>
	<cflocation url="forums.cfm" addToken="false">
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
		<cfset forum = structNew()>
		<cfset forum.name = trim(htmlEditFormat(form.name))>
		<cfset forum.description = trim(htmlEditFormat(form.description))>
		<cfset forum.readonly = trim(htmlEditFormat(form.readonly))>
		<cfset forum.active = trim(htmlEditFormat(form.active))>
		<cfset forum.attachments = trim(htmlEditFormat(form.attachments))>
		<cfset forum.conferenceidfk = trim(htmlEditFormat(form.conferenceidfk))>
		<cfif url.id neq 0>
			<cfset application.forum.saveForum(url.id, forum)>
		<cfelse>
			<cfset application.forum.addForum(forum)>
		</cfif>
		<cfset msg = "Forum, #forum.name#, has been updated.">
		<cflocation url="forums.cfm?msg=#urlEncodedFormat(msg)#">
	</cfif>
</cfif>

<!--- get forum if not new --->
<cfif url.id neq 0>
	<cfset forum = application.forum.getForum(url.id)>
	<cfparam name="form.name" default="#forum.name#">
	<cfparam name="form.description" default="#forum.description#">
	<cfparam name="form.readonly" default="#forum.readonly#">
	<cfparam name="form.active" default="#forum.active#">
	<cfparam name="form.attachments" default="#forum.attachments#">
	<cfparam name="form.conferenceidfk" default="#forum.conferenceidfk#">
<cfelse>
	<cfparam name="form.name" default="">
	<cfparam name="form.description" default="">
	<cfparam name="form.readonly" default="false">
	<cfparam name="form.active" default="false">
	<cfparam name="form.attachments" default="false">
	<cfparam name="form.conferenceidfk" default="">
</cfif>

<!--- get all conferences --->
<cfset conferences = application.conference.getConferences(false)>

<cfmodule template="../tags/layout.cfm" templatename="admin" title="Forum Editor">

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
		<td align="right"><b>Conference:</b></td>
		<td>
			<select name="conferenceidfk">
			<cfloop query="conferences">
			<option value="#id#" <cfif form.conferenceidfk is id>selected</cfif>>#name#</option>
			</cfloop>
			</select>
		</td>
	</tr>
	<tr valign="top">
		<td align="right"><b>Description:</b></td>
		<td><textarea name="description" rows=6 cols=35 wrap="soft">#form.description#</textarea></td>
	</tr>
	<tr valign="top">
		<td align="right"><b>Read Only:</b></td>
		<td><select name="readonly">
		<option value="1" <cfif form.readonly>selected</cfif>>Yes</option>
		<option value="0" <cfif not form.readonly>selected</cfif>>No</option>
		</select></td>
	</tr>
	<tr valign="top">
		<td align="right"><b>Active:</b></td>
		<td><select name="active">
		<option value="1" <cfif form.active>selected</cfif>>Yes</option>
		<option value="0" <cfif not form.active>selected</cfif>>No</option>
		</select></td>
	</tr>
	<tr valign="top">
		<td align="right"><b>Attachments:</b></td>
		<td><select name="attachments">
		<option value="1" <cfif isBoolean(form.attachments) and form.attachments>selected</cfif>>Yes</option>
		<option value="0" <cfif (isBoolean(form.attachments) and not form.attachments) or form.attachments is "">selected</cfif>>No</option>
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