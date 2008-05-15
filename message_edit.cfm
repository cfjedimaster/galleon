<cfsetting enablecfoutputonly=true>
<!---
	Name         : message_edit.cfm
	Author       : Raymond Camden 
	Created      : July 6, 2004
	Last Updated : October 12, 2007
	History      : Reset for V2
	Purpose		 : Allows moderators/admins to edit post.
--->

<cfif not isDefined("url.id") or not len(url.id)><cflocation url="index.cfm" addToken="false"></cfif>
<cftry>
	<cfset request.message = application.message.getMessage(url.id)>
	<cfcatch>
		<cflocation url="index.cfm" addToken="false">
	</cfcatch>    
</cftry>

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

<!--- Must be logged in. --->
<cfif not request.udf.isLoggedOn()>
	<cflocation url="index.cfm" addToken="false">
</cfif>

<!--- Am I allowed to edit here? --->
<cfif application.permission.allowed(application.rights.CANEDIT, request.forum.id, request.udf.getGroups()) and
	  application.permission.allowed(application.rights.CANEDIT, request.conference.id, request.udf.getGroups())>
	<cfset canEdit = true>
<cfelse>
	<cfset canEdit = false>
</cfif>

<!--- ignore canedit if I have canPost and it's my post --->
<!--- Am I allowed to post here? --->
<cfif application.permission.allowed(application.rights.CANPOST, request.forum.id, request.udf.getGroups()) and
	  application.permission.allowed(application.rights.CANPOST, request.conference.id, request.udf.getGroups())>
	<cfset canPost = true>
<cfelse>
	<cfset canPost = false>
</cfif>

<cfif not canEdit and  not (canPost and request.message.useridfk eq session.user.id)>
	<cflocation url="index.cfm" addToken="false">
</cfif>

<cfparam name="form.title" default="#request.message.title#">
<cfparam name="form.body" default="#request.message.body#">
<cfparam name="form.oldattachment" default="#request.message.attachment#">
<cfparam name="form.filename" default="#request.message.filename#">
<cfparam name="form.attachment" default="">
<cfset form.body = rereplace(form.body,'\n\[i\]\* Last updated by: .* on .* @ .* \*\[\/i\]','','ALL')>

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
	
	
	
	<!-- Content Start -->
	<div class="content_box">
					
		<!-- Message Edit Start -->
		<div class="row_title">
			<p>Edit Post</p>
		</div>
		<cfif isDefined("errors")>
		<div class="row_1">
			<p>Please correct the following error(s):</p>
			<div class="submit_errors"><p><b>#errors#</b></p></div>
		</div>	
		</cfif>
		
		<div class="row_1 top_pad">
			<form action="#cgi.script_name#?#cgi.query_string#" method="post" enctype="multipart/form-data" class="basic_forms">
			<input type="hidden" name="post" value="1">
				
			<p class="input_name">Title:</p>
			<input type="text" name="title" value="#form.title#"  class="input_box" maxlength="50">
			
			<div class="clearer"><br /></div>
			
			<p class="input_name">Body:</p><br />
			<textarea id="markitup" name="body" class="edit_textarea">#form.body#</textarea>
			
			<div class="clearer"><br /></div>
			<cfif isBoolean(request.forum.attachments) and request.forum.attachments>
			
			<div class="avatar_title">Attach File:</div>
				
				<div class="avatar_options">
								
				<div class="clearer"><br /></div>
				<input type="file" name="attachment" class="input_file">
				<cfif len(form.oldattachment)>
				<p class="file_text">File already attached: #form.oldattachment#</p>

				<input type="hidden" name="oldattachment" value="#form.oldattachment#">
				<input type="hidden" name="filename" value="#form.filename#">
					
				<p><input type="checkbox" name="removefile">Remove Attachment</p>
				</cfif>
				
				<div class="clearer"></div>
				</cfif>
				
			</div>
			
			<div class="clearer"><br /></div>
			<input type="image" src="images/btn_update.gif" alt="Update" title="Update" class="submit_btns"  name="post">
			<div class="clearer"><br /></div>
			
			</form>
			
		</div>	
		<!-- Message Edit Ender -->
						
	</div>
	<!-- Content End -->

</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly=false>
