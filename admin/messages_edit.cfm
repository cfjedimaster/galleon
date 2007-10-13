<cfsetting enablecfoutputonly=true>
<!---
	Name         : messages_edit.cfm
	Author       : Raymond Camden 
	Created      : July 5, 2004
	Last Updated : October 12, 2007
	History      : Reset for V2
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
		<cflocation url="messages.cfm?msg=#urlEncodedFormat(msg)#" addToken="false">
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
<form action="#cgi.script_name#?#cgi.query_string#" method="post">
<cfif isDefined("errors")><ul><b>#errors#</b></ul></cfif>

<div class="name_row">
<p class="left_100"></p>
</div>

<div class="row_0">
	<p class="input_name">Title</p>
	<input type="text" name="title" value="#form.title#" class="inputs_01">
	<div class="clearer"></div>
</div>

<div class="row_1">
	<p class="input_name">Body</p>
	<textarea name="body" class="ta_edit">#form.body#</textarea>
	<div class="clearer"></div>
</div>

<div class="row_0">
	<p class="input_name">Thread</p>
		<select name="threadidfk" class="inputs_02">
			<cfloop query="threads">
			<option value="#id#" <cfif form.threadidfk is id>selected</cfif>>#name#</option>
			</cfloop>
		</select>
<div class="clearer"></div>
</div>

<div class="row_1">
	<p class="input_name">Posted</p>
	<input type="text" name="posted" value="#form.posted#" class="inputs_01">
	<div class="clearer"></div>
</div>

<div class="row_0">
	<p class="input_name">User</p>
		<select name="useridfk" class="inputs_02">
			<cfloop query="users">
			<option value="#id#" <cfif form.useridfk is id>selected</cfif>>#username#</option>
			</cfloop>
		</select>
<div class="clearer"></div>
</div>

<cfif isDefined("message.attachment") and len(message.attachment)>
<div class="row_1">
	<p class="input_name">Attachment</p>
	<a href="../attachment.cfm?id=#url.id#" class="cb_text">#message.attachment#</a>
	<div class="cb_remove">Remove File</div>
	<input type="checkbox" name="removeFile" class="inputs_cb">
	<div class="clearer"></div>
</div>
</cfif>

<div id="input_btns">	
	<input type="image" src="../images/btn_save.jpg"  name="save" value="Save">
	<input type="image" src="../images/btn_cancel.jpg" type="submit" name="cancel" value="Cancel">
</div>
</form>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly=false>