<cfsetting enablecfoutputonly=true>
<!---
	Name         : threads_edit.cfm
	Author       : Raymond Camden 
	Created      : June 09, 2004
	Last Updated : July 27, 2006
	History      : Removed mappings, added sticky (rkc 8/27/05)
				 : Simple size change (rkc 7/27/06)
	Purpose		 : 
--->

<cfif isDefined("form.cancel") or not isDefined("url.id") or not len(url.id)>
	<cflocation url="threads.cfm" addToken="false">
</cfif>

<cfif isDefined("form.save")>
	<cfset errors = "">
	<cfif not len(trim(form.name))>
		<cfset errors = errors & "You must specify a name.<br>">
	</cfif>
	<cfif not len(trim(form.datecreated)) or not isDate(form.datecreated)>
		<cfset errors = errors & "You must specify a valid creation date.<br>">
	</cfif>

	<cfif not len(errors)>
		<cfset thread = structNew()>
		<cfset thread.name = trim(htmlEditFormat(form.name))>
		<cfset thread.readonly = trim(htmlEditFormat(form.readonly))>
		<cfset thread.active = trim(htmlEditFormat(form.active))>
		<cfset thread.forumidfk = trim(htmlEditFormat(form.forumidfk))>
		<cfset thread.datecreated = trim(htmlEditFormat(form.datecreated))>
		<cfset thread.useridfk = trim(htmlEditFormat(form.useridfk))>
		<cfset thread.sticky = trim(htmlEditFormat(form.sticky))>
		<cfif url.id neq 0>
			<cfset application.thread.saveThread(url.id, thread)>
		<cfelse>
			<cfset application.thread.addThread(thread)>
		</cfif>
		<cfset msg = "Thread, #thread.name#, has been updated.">
		<cflocation url="threads.cfm?msg=#urlEncodedFormat(msg)#">
	</cfif>
</cfif>

<!--- get thread if not new --->
<cfif url.id neq 0>
	<cfset thread = application.thread.getThread(url.id)>
	<cfparam name="form.name" default="#thread.name#">
	<cfparam name="form.readonly" default="#thread.readonly#">
	<cfparam name="form.active" default="#thread.active#">
	<cfparam name="form.forumidfk" default="#thread.forumidfk#">
	<cfparam name="form.datecreated" default="#dateFormat(thread.datecreated,"m/dd/yy")#">
	<cfparam name="form.useridfk" default="#thread.useridfk#">
	<cfparam name="form.sticky" default="#thread.sticky#">
<cfelse>
	<cfparam name="form.name" default="">
	<cfparam name="form.readonly" default="false">
	<cfparam name="form.active" default="false">
	<cfparam name="form.forumidfk" default="">
	<cfparam name="form.datecreated" default="#dateFormat(now(),"m/dd/yy")#">
	<cfparam name="form.useridfk" default="">
	<cfparam name="form.sticky" default="false">
</cfif>

<!--- get all forums --->
<cfset forums = application.forum.getForums(false)>

<!--- get all users --->
<cfset users = application.user.getUsers()>

<cfmodule template="../tags/layout.cfm" templatename="admin" title="Thread Editor">

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
		<td align="right"><b>Forum:</b></td>
		<td>
			<select name="forumidfk">
			<cfloop query="forums">
			<option value="#id#" <cfif form.forumidfk is id>selected</cfif>>#name#</option>
			</cfloop>
			</select>
		</td>
	</tr>
	<tr valign="top">
		<td align="right"><b>Date Created:</b></td>
		<td><input type="text" name="datecreated" value="#form.datecreated#" size="50"></td>
	</tr>
	<tr valign="top">
		<td align="right"><b>User:</b></td>
		<td>
			<select name="useridfk">
			<cfloop query="users">
			<option value="#id#" <cfif form.useridfk is id>selected</cfif>>#username#</option>
			</cfloop>
			</select>
		</td>
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
		<td align="right"><b>Sticky:</b></td>
		<td><select name="sticky">
		<option value="1" <cfif isBoolean(form.sticky) and form.sticky>selected</cfif>>Yes</option>
		<option value="0" <cfif (isBoolean(form.sticky) and not form.sticky) or not isBoolean(form.sticky)>selected</cfif>>No</option>
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