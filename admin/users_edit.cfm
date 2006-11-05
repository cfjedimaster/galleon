<cfsetting enablecfoutputonly=true>
<!---
	Name         : users_edit.cfm
	Author       : Raymond Camden 
	Created      : July 5, 2004
	Last Updated : July 17, 2006
	History      : Fixed bugs related to sendnotifications change (rkc 8/3/05)
				   Removed mappings (rkc 8/27/05)
				   Handle confirmation, and require one group (rkc 7/12/06)
				   Fix error thrown when requireconfirmation=false (rkc 7/17/06)
	Purpose		 : 
--->

<cfif isDefined("form.cancel") or not isDefined("url.id")>
	<cflocation url="users.cfm" addToken="false">
</cfif>

<cfif isDefined("form.save")>
	<cfset errors = "">

	<cfif not len(trim(form.username))>
		<cfset errors = errors & "You must specify a username.<br>">
	</cfif>
	<cfif not len(trim(form.emailaddress)) or not request.udf.isEmail(trim(form.emailaddress))>
		<cfset errors = errors & "You must specify an emailaddress.<br>">
	</cfif>
	<cfif not len(trim(form.password))>
		<cfset errors = errors & "You must specify a password.<br>">
	</cfif>
	<cfif not len(trim(form.datecreated)) or not isDate(form.datecreated)>
		<cfset errors = errors & "You must specify a creation date.<br>">
	</cfif>
	<cfif not structKeyExists(form,"groups") or not len(form.groups)>
		<cfset errors = errors & "You must specify at least one group for the user.<br>">
	</cfif>
	<cfif not len(errors)>
		<cfset user = structNew()>
		<cfset form.username = trim(htmlEditFormat(form.username))>
		<cfset form.emailaddress = trim(htmlEditFormat(form.emailaddress))>
		<cfset form.password = trim(htmlEditFormat(form.password))>
		<cfset form.datecreated = trim(htmlEditFormat(form.datecreated))>
		<cfparam name="form.groups" default="">
		<!--- set confirmed to true if not passed --->
		<cfparam name="form.confirmed" default="true">
		<cfif url.id neq 0>
			<cfset application.user.saveUser(form.username, form.password, form.emailaddress, form.datecreated,form.groups,form.confirmed)>
		<cfelse>
			<cftry>
				<cfset application.user.addUser(form.username, form.password, form.emailaddress, form.groups,form.confirmed)>
				<cfcatch><cfdump var="#cfcatch#">
					<cfset errors = cfcatch.message>
				</cfcatch>
			</cftry>
		</cfif>
		<cfif not len(errors)>
			<cfset msg = "User, #form.username#, has been updated.">
			<cflocation url="users.cfm?msg=#urlEncodedFormat(msg)#">
		</cfif>
	</cfif>
</cfif>

<!--- get user if not new --->
<cfif url.id gte 1>
	<cfset user = application.user.getUser(url.id)>
	<cfparam name="form.username" default="#user.username#">
	<cfparam name="form.emailaddress" default="#user.emailaddress#">
	<cfparam name="form.password" default="#user.password#">
	<cfparam name="form.datecreated" default="#dateFormat(user.datecreated,"m/dd/yy")# #timeFormat(user.datecreated,"h:mm tt")#">
	<cfparam name="form.groups" default="#user.groups#">
	<cfparam name="form.confirmed" default="#user.confirmed#">
<cfelse>
	<cfparam name="form.username" default="">
	<cfparam name="form.emailaddress" default="">
	<cfparam name="form.password" default="">
	<cfparam name="form.datecreated" default="#dateFormat(now(),"m/dd/yy")# #timeFormat(now(),"h:mm tt")#">
	<cfparam name="form.groups" default="">
	<cfparam name="form.confirmed" default="0">
</cfif>

<cfset groups = application.user.getGroups()>

<cfmodule template="../tags/layout.cfm" templatename="admin" title="User Editor">

<cfoutput>
<p>
<cfif isDefined("errors")><ul><b>#errors#</b></ul></cfif>
<form action="#cgi.script_name#?#cgi.query_string#" method="post">
<table width="100%" cellspacing=0 cellpadding=5 class="adminEditTable">
	<tr valign="top">
		<td align="right"><b>User Name:</b></td>
		<td>
			<cfif url.id is not "0">
				<input type="hidden" name="username" value="#form.username#">#form.username#
			<cfelse>
				<input type="text" name="username" value="#form.username#" size="50"></td>
			</cfif>
		</td>
	</tr>
	<tr valign="top">
		<td align="right"><b>Email Address:</b></td>
		<td><input type="text" name="emailaddress" value="#form.emailaddress#" size="50"></td>
	</tr>
	<tr valign="top">
		<td align="right"><b>Password:</b></td>
		<td><input type="text" name="password" value="#form.password#" size="50"></td>
	</tr>
	<tr valign="top">
		<td align="right"><b>Date Created:</b></td>
		<td><input type="text" name="datecreated" value="#form.datecreated#" size="50"></td>
	</tr>
	<tr valign="top">
		<td align="right"><b>Groups:</b></td>
		<td>
		<select name="groups" multiple size="3">
		<cfloop query="groups">
		<option value="#group#" <cfif listFindNoCase(form.groups, group)>selected</cfif>>#group#</option>
		</cfloop>
		</select>
		</td>
	</tr>
	<cfif application.settings.requireconfirmation>
	<tr valign="top">
		<td align="right"><b>Confirmed:</b></td>	
		<td><select name="confirmed">
		<option value="0" <cfif not form.confirmed>selected</cfif>>No</option>
		<option value="1" <cfif form.confirmed>selected</cfif>>Yes</option>
		</select></td>
	</tr>
	</cfif>
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