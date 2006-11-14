<cfsetting enablecfoutputonly=true>
<!---
	Name         : message_edit.cfm
	Author       : Raymond Camden 
	Created      : July 6, 2004
	Last Updated : November 14, 2006
	History      : Removed mappings (rkc 8/29/05)
				 : title+cfcatch change (rkc 8/4/06)
				 : attachment support (rkc 11/3/06)
				 : fix bug if attachments turned off (rkc 11/14/06)
	Purpose		 : Allows moderators/admins to edit post.
--->

<cfif not request.udf.isLoggedOn() or not application.utils.isUserInAnyRole("forumsadmin,forumsmoderator")>
	<cflocation url="index.cfm" addToken="false">
</cfif>

<cfif not isDefined("url.id") or not len(url.id)>
	<cflocation url="index.cfm" addToken="false">
</cfif>

<!--- get parents --->
<cftry>
	<cfset request.message = application.message.getMessage(url.id)>
	<cfset request.thread = application.thread.getThread(request.message.threadidfk)>
	<cfset request.forum = application.forum.getForum(request.thread.forumidfk)>
	<cfset request.conference = application.conference.getConference(request.forum.conferenceidfk)>
	<cfcatch>
		<cflocation url="index.cfm" addToken="false">
	</cfcatch>
</cftry>

<cfparam name="form.title" default="#request.message.title#">
<cfparam name="form.body" default="#request.message.body#">
<cfparam name="form.oldattachment" default="#request.message.attachment#">
<cfparam name="form.filename" default="#request.message.filename#">
<cfparam name="form.attachment" default="">

<cfif isDefined("form.post")>
	<cfset errors = "">
	<!--- clean the fields --->
	<cfset form.title = trim(htmlEditFormat(form.title))>
	<cfset form.body = trim(form.body)>
	
	<cfif not len(form.title)>
		<cfset errors = errors & "You must enter a title.<br>">
	</cfif>
	
	<cfif not len(form.body)>
		<cfset errors = errors & "You must enter a body.<br>">
	</cfif>

	<cfif len(form.title) gt 50>
		<cfset errors = errors & "Your title is too long.<br>">
	</cfif>
	
	<cfif isBoolean(request.forum.attachments) and request.forum.attachments and len(trim(form.attachment))>
		<cffile action="upload" destination="#expandPath("./attachments")#" filefield="attachment" nameConflict="makeunique">
		
		<cfif cffile.fileWasSaved>
			<!--- Is the extension allowed? --->
			<cfset newFileName = cffile.serverDirectory & "/" & cffile.serverFile>
			<cfset newExtension = cffile.serverFileExt>
			
			<cfif not listFindNoCase(application.settings.safeExtensions, newExtension)>
				<cfset errors = errors & "Your file did not have a extension. Allowed extensions are: #application.settings.safeExtensions#.<br>">
				<cffile action="delete" file="#newFilename#">
				<cfset form.attachment = "">
				<cfset form.filename = "">
			<cfelse>
				<cfset form.oldattachment = cffile.clientFile>
				<cfset form.attachment = cffile.clientFile>
				<cfset form.filename = cffile.serverFile>
			</cfif>
		</cfif>
	<cfelseif structKeyExists(form, "removefile")>
		<cfset form.attachment = "">
		<cffile action="delete" file="#application.settings.attachmentdir#/#form.filename#">
		<cfset form.filename = "">
	<cfelseif len(form.oldattachment)>
		<cfset form.attachment = form.oldattachment>
	</cfif>
	
	<cfif not len(errors)>
		<cfset message = structNew()>
		<cfset message.title = trim(htmlEditFormat(form.title))>
		<cfset message.body = trim(form.body)>
		<cfset message.attachment = form.attachment>
		<cfset message.filename = form.filename>
		<cfset message.posted = request.message.posted>
		<cfset message.threadidfk = request.message.threadidfk>
		<cfset message.useridfk = request.message.useridfk>
		<cfset application.message.saveMessage(url.id, message)>
		<cflocation url="messages.cfm?threadid=#message.threadidfk#" addToken="false">
	</cfif>
</cfif>

<!--- Loads header --->
<cfmodule template="tags/layout.cfm" templatename="main" title="#application.settings.title# : Edit Post">

<cfoutput>
<p>
<table width="500" cellpadding="6" class="tableDisplay" cellspacing="1" border="0">
	<tr class="tableHeader">
		<td class="tableHeader">Edit Post</td>
	</tr>
	<cfif isDefined("errors")>
	<tr class="tableRowMain">
		<td>
		Please correct the following error(s):<ul><b>#errors#</b></ul>
		</td>
	</tr>
	</cfif>
	<tr class="tableRowMain">
		<td>
		<form action="#cgi.script_name#?#cgi.query_string#" method="post" enctype="multipart/form-data">
		<input type="hidden" name="post" value="1">

		<table>
			<tr>
				<td><b>Title: </b></td>
				<td><input type="text" name="title" value="#form.title#" class="formBox" maxlength="50"></td>
			</tr>
			<tr>
				<td colspan="2"><b>Body: </b><br>
				<textarea name="body" cols="50" rows="20">#form.body#</textarea></td>
			</tr>
			<cfif isBoolean(request.forum.attachments) and request.forum.attachments>
				<tr valign="top">
					<td><b>Attach File:</b></td>
					<td>
					<input type="file" name="attachment">
					<cfif len(form.oldattachment)>
					<input type="hidden" name="oldattachment" value="#form.oldattachment#">
					<input type="hidden" name="filename" value="#form.filename#">
					<br>
					File already attached: #form.oldattachment#<br>
					<input type="checkbox" name="removefile"> Remove Attachment
					</cfif>
					</td>
				</tr>
			</cfif>				
			
			<tr>
				<td>&nbsp;</td>
				<td align="right"><input type="image" src="images/btn_update.gif" alt="Update" title="Update" width="59" height="19" name="post"></td>
			</tr>
		</table>
		</form>
		</td>
	</tr>
</table>
</p>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly=false>
