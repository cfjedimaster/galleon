<cfsetting enablecfoutputonly=true>
<!---
	Name         : newpost.cfm
	Author       : Raymond Camden 
	Created      : June 10, 2004
	Last Updated : November 6, 2006
	History      : Maxlength on title (rkc 8/30/04)
				   Support for UUID (rkc 1/27/05)
				   Now only does new threads (rkc 3/28/05)
				   Subscribe (rkc 7/29/05)
				   Refresh user cache on post (rkc 8/3/05)
				   Removed mappings (rkc 8/27/05)
				   Simple size change (rkc 7/27/06)				   
				   title fix (rkc 8/4/06)
				   attachment support (rkc 11/3/06)
				   error if attachments disabled (rkc 11/6/06)
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
	<!--- check both thread and forum for readonly and not admin --->
	<cfif request.forum.readonly or (isDefined("request.thread") and request.thread.readonly)>
		<cfif not application.utils.isUserInAnyRole("forumsadmin,forumsmoderator")>
			<cfset blockedAttempt = true>
		</cfif>
	</cfif>
	<cfcatch>
		<cflocation url="index.cfm" addToken="false">
	</cfcatch>
</cftry>

<cfparam name="form.title" default="">
<cfparam name="form.body" default="">
<cfparam name="form.subscribe" default="true">
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
<p>
<table width="500" cellpadding="6" class="tableDisplay" cellspacing="1" border="0">
	<tr class="tableHeader">
		<td class="tableHeader">New Post</td>
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
			<cfif not blockedAttempt>
				<tr>
					<td><b>Title: </b></td>
					<td><input type="text" name="title" value="#form.title#" class="formBox"></td>
				</tr>
				<tr>
					<td colspan="2"><b>Body: </b><br>
					<p>
					#application.message.renderHelp()#
					</p>
					<textarea name="body" cols="50" rows="20">#form.body#</textarea></td>
				</tr>
				<tr>
					<td><b>Subscribe to Thread: </b></td>
					<td><select name="subscribe">
					<option value="true" <cfif form.subscribe>selected</cfif>>Yes</option>
					<option value="false" <cfif not form.subscribe>selected</cfif>>No</option>
					</select></td>
				</tr>
				<cfif isBoolean(request.forum.attachments) and request.forum.attachments>
				<tr>
					<td><b>Attach File:</b></td>
					<td>
					<input type="file" name="attachment">
					<cfif len(form.oldattachment)>
					<input type="hidden" name="oldattachment" value="#form.oldattachment#">
					<input type="hidden" name="filename" value="#form.filename#">
					<br>
					File already attached: #form.oldattachment#
					</cfif>
					</td>
				</tr>
				</cfif>				
				<tr>
					<td>&nbsp;</td>
					<td align="right"><input type="image" src="images/btn_new_topic.gif" alt="New Topic" title="New Topic" width="71" height="19" name="post"></td>
				</tr>
			<cfelse>
				<tr>
					<td><b>Sorry, but this area is readonly.</b></td>
				</tr>
			</cfif>
		</table>
		</form>
		</td>
	</tr>
</table>
</p>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly=false>
