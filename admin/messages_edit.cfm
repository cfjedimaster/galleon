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

<cfif isDefined("form.cancel.x") or not isDefined("url.id") or not len(url.id)>
	<cflocation url="messages.cfm" addToken="false">
</cfif>

<!--- Adds no longer supported, link is gone, but be anal --->
<cfif url.id eq 0>
	<cflocation url="messages.cfm" addToken="false">
</cfif>

<cfif isDefined("form.save.x")>
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

		<cfset message = application.message.getMessage(url.id)>
		<cfset message.title = trim(htmlEditFormat(form.title))>
		<cfset message.body = trim(htmlEditFormat(form.body))>
		<cfset message.posted = trim(form.posted)>
		<cfset message.threadidfk = form.threadidfk>
		<cfif structKeyExists(variables, "attachment")>
			<cfset message.attachment = attachment>
			<cfset message.filename = filename>
		<cfelse>
			<cfset message.attachment = "">
			<cfset message.filename = "">
		</cfif>
			
		<cfset application.message.saveMessage(url.id, message)>
		<cfset msg = "Message, #message.title#, has been updated.">
		<cflocation url="messages.cfm?msg=#urlEncodedFormat(msg)#" addToken="false">
	</cfif>
</cfif>

<cfset message = application.message.getMessage(url.id)>
<cfset thread = application.thread.getThread(message.threadidfk)>
<cfset threads = application.thread.getThreads(forumidfk=thread.forumidfk,sort="name")>
<cfparam name="form.title" default="#message.title#">
<cfparam name="form.body" default="#message.body#">
<cfparam name="form.threadidfk" default="#message.threadidfk#">
<cfparam name="form.posted" default="#dateFormat(message.posted,"m/dd/yy")# #timeFormat(message.posted,"h:mm tt")#">

<cfmodule template="../tags/layout.cfm" templatename="admin" title="Message Editor">

<cfoutput>
<form action="#cgi.script_name#?#cgi.query_string#" method="post">
<div class="clearer"></div>
<cfif isDefined("errors")><div class="input_error"><ul><b>#errors#</b></ul></div></cfif>

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
	<select name="threadidfk">
		<cfloop query="threads.data">
			<option value="#id#" <cfif form.threadidfk is id>selected</cfif>>#name#</option>
		</cfloop>
	</select><br/>
	You can move this message to another thread in the same forum.
<div class="clearer"></div>
</div>

<div class="row_1">
	<p class="input_name">Posted</p>
	<input type="text" name="posted" value="#form.posted#" class="inputs_01">
	<div class="clearer"></div>
</div>

<div class="row_0">
	<p class="input_name">User</p>
		#message.username#
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
	<input type="image" src="../images/btn_cancel.jpg" name="cancel" value="Cancel">
</div>
</form>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly=false>