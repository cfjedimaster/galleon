<cfsetting enablecfoutputonly=true>
<!---
	Name         : messages_edit.cfm
	Author       : Raymond Camden 
	Created      : July 5, 2004
	Last Updated : November 6, 2006
	History      : Simple size change (rkc 7/27/06)
				 : Attachments support (rkc 11/6/06)
	Purpose		 : 
	
	Note: In the admin I don't let folks upload attachments, but 
	I do let them remove them.
--->

<cfif isDefined("form.cancel") or not isDefined("url.id") or not len(url.id)>
	<cflocation url="messages.cfm" addToken="false">
</cfif>

<!--- get all threads --->
<cfset threads = application.thread.getThreads(false)>

<!--- get all users --->
<cfset users = application.user.getUsers()>

<cfif isDefined("form.save")>
	<cfset errors = "">
	<cfif not len(trim(form.title))>
		<cfset errors = errors & "You must specify a title.<br>">
	</cfif>
	<cfif not len(trim(form.body))>
		<cfset errors = errors & "You must specify a body.<br>">
	</cfif>
	<cfif not len(trim(form.posted)) or not isDate(form.posted)>
		<cfset errors = errors & "You must specify a valid creation date.<br>">
	</cfif>
	
	<cfif not len(errors)>
		
		<cfif structKeyExists(form, "removefile") and isDefined("message.attachment") and fileExists(application.settings.attachmentdir & "/" & message.filename)>
			<cffile action="delete" file="#application.settings.attachmentdir#/#message.filename#">
		<cfelseif isDefined("message.attachment")>
			<cfset attachment = message.attachment>
			<cfset filename = message.filename>
		</cfif>

		<cfset message = structNew()>

		<cfset message.title = trim(htmlEditFormat(form.title))>
		<cfset message.body = trim(htmlEditFormat(form.body))>
		<cfset message.posted = trim(form.posted)>
		<cfset message.threadidfk = form.threadidfk>
		<cfset message.useridfk = form.useridfk>
		<cfif structKeyExists(variables, "attachment")>
			<cfset message.attachment = attachment>
			<cfset message.filename = filename>
		<cfelse>
			<cfset message.attachment = "">
			<cfset message.filename = "">
		</cfif>
			
		<cfif url.id neq 0>
			<cfset application.message.saveMessage(url.id, message)>
		<cfelse>
			<cfset threadPicked = application.thread.getThread(form.threadidfk)>
			<!--- translate the user id to the username for addMessage --->
			<cfloop query="users">
				<cfif id is form.useridfk>
					<cfset theusername = username>
				</cfif>
			</cfloop>
			<cfset application.message.addMessage(message,threadPicked.forumidfk,theusername,form.threadidfk)>
		</cfif>
		<cfset msg = "Message, #message.title#, has been updated.">
		<cflocation url="messages.cfm?msg=#urlEncodedFormat(msg)#">
	</cfif>
</cfif>

<!--- get message if not new --->
<cfif url.id neq 0>
	<cfset message = application.message.getMessage(url.id)>
	<cfparam name="form.title" default="#message.title#">
	<cfparam name="form.body" default="#message.body#">
	<cfparam name="form.posted" default="#dateFormat(message.posted,"m/dd/yy")# #timeFormat(message.posted,"h:mm tt")#">
	<cfparam name="form.useridfk" default="#message.useridfk#">
	<cfparam name="form.threadidfk" default="#message.threadidfk#">
<cfelse>
	<cfparam name="form.title" default="">
	<cfparam name="form.body" default="">
	<cfparam name="form.posted" default="#dateFormat(now(),"m/dd/yy")# #timeFormat(now(),"h:mm tt")#">
	<cfparam name="form.useridfk" default="">
	<cfparam name="form.threadidfk" default="">
</cfif>

<cfmodule template="../tags/layout.cfm" templatename="admin" title="Message Editor">

<cfoutput>
<p>
<cfif isDefined("errors")><ul><b>#errors#</b></ul></cfif>
<form action="#cgi.script_name#?#cgi.query_string#" method="post">
<table width="100%" cellspacing=0 cellpadding=5 class="adminEditTable">
	<tr valign="top">
		<td align="right"><b>Title:</b></td>
		<td><input type="text" name="title" value="#form.title#" size="100"></td>
	</tr>
	<tr valign="top">
		<td align="right"><b>Body:</b></td>
		<td>
		<textarea name="body" cols=50 rows=20>#form.body#</textarea>
		</td>
	</tr>
	<cfif isDefined("message.attachment") and len(message.attachment)>
	<tr valign="top">
		<td align="right"><b>Attachment:</b></td>
		<td><a href="../attachment.cfm?id=#url.id#">#message.attachment#</a>
		<br><input type="checkbox" name="removefile">Remove File</a></td>
	</tr>
	</cfif>
	<tr valign="top">
		<td align="right"><b>Thread:</b></td>
		<td>
			<select name="threadidfk">
			<cfloop query="threads">
			<option value="#id#" <cfif form.threadidfk is id>selected</cfif>>#name#</option>
			</cfloop>
			</select>
		</td>
	</tr>
	<tr valign="top">
		<td align="right"><b>Posted:</b></td>
		<td><input type="text" name="posted" value="#form.posted#" size="50"></td>
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