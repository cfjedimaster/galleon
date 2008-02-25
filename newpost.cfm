<cfsetting enablecfoutputonly=true>
<!---
	Name         : newpost.cfm
	Author       : Raymond Camden 
	Created      : June 10, 2004
	Last Updated : October 12, 2007
	History      : Reset for V2
	Purpose		 : Displays form to add a thread.
--->

<cfif not request.udf.isLoggedOn()>
	<cfset thisPage = cgi.script_name & "?" & cgi.query_string>
	<cflocation url="login.cfm?ref=#urlEncodedFormat(thisPage)#" addToken="false">
</cfif>

<cfif not isDefined("url.forumid") or not len(url.forumid)>
	<cflocation url="index.cfm" addToken="false">
</cfif>

<!--- checks to see if we can post --->
<cfset blockedAttempt = false>

<!--- get parents --->
<cftry>
	<cfset request.forum = application.forum.getForum(url.forumid)>
	<cfset request.conference = application.conference.getConference(request.forum.conferenceidfk)>
	<cfif not application.permission.allowed(application.rights.CANPOST, url.forumid, request.udf.getGroups()) or 
		not application.permission.allowed(application.rights.CANPOST, request.conference.id, request.udf.getGroups())>
			<cfset blockedAttempt = true>
	</cfif>
	<cfcatch>
		<cflocation url="index.cfm" addToken="false">
	</cfcatch>
</cftry>

<cfparam name="form.title" default="">
<cfparam name="form.body" default="">
<cfparam name="form.subscribe" default="false">
<cfparam name="form.oldattachment" default="">
<cfparam name="form.attachment" default="">
<cfparam name="form.filename" default="">

<cfif isDefined("form.post") and not blockedAttempt>
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
	
	<cfif len(form.title) gt 255>
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
	<cfelseif len(form.oldattachment)>
		<cfset form.attachment = form.oldattachment>
	</cfif>

	<cfif not len(errors)>
	
		<cfset message = structNew()>
		<cfset message.title = form.title>
		<cfset message.body = form.body>
		<cfset message.attachment = form.attachment>
		<cfset message.filename = form.filename>
		
		<cfset args = structNew()>
		<cfset args.message = message>
		<cfset args.forumid = url.forumid>
		<cfset msgid = application.message.addMessage(argumentCollection=args)>
		<!--- get the message so we can get thread id --->
		<cfset message = application.message.getMessage(msgid)>
		
		<cfif form.subscribe>
			<cfset application.user.subscribe(getAuthUser(), "thread", message.threadidfk)>
		</cfif>

		<!--- clear my user info --->
		<cfset uinfo = request.udf.cachedUserInfo(getAuthUser(), false)>

		<cflocation url="messages.cfm?threadid=#message.threadidfk#" addToken="false">
	</cfif>
	
</cfif>

<!--- Loads header --->
<cfmodule template="tags/layout.cfm" templatename="main" title="#application.settings.title# : New Post">

<cfoutput>
	
	
	
<!-- Edit Message Container Start -->
	<div class="content_box">
	
		<!-- Message Edit Start -->
		<div class="row_title">
			<p>New Post</p>
		</div>
		<cfif isDefined("errors") and len(errors)>
		<div class="row_0">
			<div class="clearer"></div>
			<p>Please correct the following error(s):</p>
			<div class="submit_error"><p><b>#errors#</b></p></div><br />
		</div>
		</cfif>
		
		<div class="row_1 top_pad">
			<form action="#cgi.script_name#?#cgi.query_string#" method="post" enctype="multipart/form-data" class="basic_forms">
			<input type="hidden" name="post" value="1">
			
			<cfif not blockedAttempt>
			<p class="input_name">Title:</p>
			<div class="clearer"></div>
			<input type="text" name="title" value="#form.title#" class="formBox">
			<div class="clearer"><br /></div>
			
			
			<p class="input_name">Body:</p>
			<div class="clearer"></div>
			#application.message.renderHelp()#
			<textarea class="edit_textarea" name="body" cols="100" rows="20">#form.body#</textarea>
			
			<div class="clearer"><br /></div>
			
			<p class="input_name">Subscribe:</p>
			<input type="checkbox" name="subscribe" value="true" <cfif form.subscribe>checked</cfif>>
			<div class="clearer"><br /></div>
			<cfif isBoolean(request.forum.attachments) and request.forum.attachments>
			<p>Attach File:</p>
			<input type="file" name="attachment">
			<cfif len(form.oldattachment)>
			<input type="hidden" name="oldattachment" value="#form.oldattachment#">
			<input type="hidden" name="filename" value="#form.filename#">
			<br>
			File already attached: #form.oldattachment#
			</cfif>
			<div class="clearer"><br /></div>								
			</cfif>
			<cfif not isDefined("request.thread")><input type="image" src="images/btn_new_topic.gif" alt="New Topic" title="New Topic" name="post" class="submit_btns"><cfelse><input type="image" src="images/btn_reply.gif" alt="Reply" title="Reply" name="post" class="submit_btns"></cfif>
			<div class="clearer"><br /></div>
			<cfelse>
			<div class="row_0">
			<div class="clearer"></div>
			<p><b>Sorry, but you may not post here.</b></p>
			</div>
			</cfif>
			</form>
		</div>
		
		<!-- Message Edit Ender -->
		
	</div>
	<!-- Edit Message Container Ender -->

</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly=false>
