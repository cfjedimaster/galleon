<cfsetting enablecfoutputonly=true>
<!---
	Name         : messages.cfm
	Author       : Raymond Camden 
	Created      : June 10, 2004
	Last Updated : May 1, 2007
	History      : Support for UUID (rkc 1/27/05)
				   Update to allow posting here (rkc 3/31/05)
				   Fixed code that gets # of pages (rkc 4/8/05)
				   Hide the darn error msg if errors is blank, links to messages (rkc 7/15/05)
				   Form posts so that if error, you go back down to form. If no error, you cflocate to top (rkc 7/29/05)
				   Have subscribe option (rkc 7/29/05)
				   Refresh user cache on post, change links a bit (rkc 8/3/05)				
				   Fix typo (rkc 8/9/05)
				   Fix pages. Add anchor for last post (rkc 9/15/05)
				   It's possible form.title and form.body may not exist and my code didn't handle it (rkc 10/7/05)
				   IE cflocation bug fix, ensure logged on before posting (rkc 10/10/05)
				   Simple size change (rkc 7/27/06)
				   gravatar, sig, attachments (rkc 11/3/06)
				   bug when no attachment (rkc 11/6/06)
				   lcase the hash for gravatar (rkc 12/18/06)
				   Use renderMessage, bd fix (rkc 2/21/07)
				   Changed calls to isUserInAnyRole to isTheUserInAnyRole (rkc 5/1/07)				   									   
	Purpose		 : Displays messages for a thread
--->

<cfif not isDefined("url.threadid") or not len(url.threadid)>
	<cflocation url="index.cfm" addToken="false">
</cfif>

<!--- get parents --->
<cftry>
	<cfset request.thread = application.thread.getThread(url.threadid)>
	<cfset request.forum = application.forum.getForum(request.thread.forumidfk)>
	<cfset request.conference = application.conference.getConference(request.forum.conferenceidfk)>
	<cfcatch>
		<cflocation url="index.cfm" addToken="false">
	</cfcatch>
</cftry>

<!--- determine if read only --->
<cfif request.forum.readonly or request.thread.readonly>
	<cfset readonly = true>
<cfelse>
	<cfset readonly = false>
</cfif>

<!--- handle new post --->
<cfparam name="form.title" default="RE: #request.thread.name#">
<cfparam name="form.body" default="">
<cfparam name="form.subscribe" default="true">
<cfparam name="form.oldattachment" default="">
<cfparam name="form.attachment" default="">
<cfparam name="form.filename" default="">

<cfif isDefined("form.post") and request.udf.isLoggedOn() and (application.utils.isTheUserInAnyRole("forumsadmin,forumsmoderator") or (not readonly))>

	<cfset errors = "">
	<!--- clean the fields --->
	<!--- Added the params since its possible someone could remove them. --->
	<cfparam name="form.title" default="">
	<cfparam name="form.body" default="">
	
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
		<cfset args.forumid = request.forum.id>
		<cfset args.threadid = url.threadid>
		<cfset msgid = application.message.addMessage(argumentCollection=args)>
		<cfif form.subscribe>
			<cfset application.user.subscribe(getAuthUser(), "thread", url.threadid)>
		</cfif>
		
		<!--- clear my user info --->
		<cfset uinfo = request.udf.cachedUserInfo(getAuthUser(), false)>

		<cflocation url="messages.cfm?threadid=#url.threadid#&##top" addToken="false">
	</cfif>
	
</cfif>

<!--- get my messages --->
<cfset data = application.message.getMessages(threadid=request.thread.id)>

<!--- Loads header --->
<cfmodule template="tags/layout.cfm" templatename="main" title="#application.settings.title# : #request.conference.name# : #request.forum.name# : #request.thread.name#">

<!--- determine max pages --->
<cfif data.recordCount and data.recordCount gt application.settings.perpage>
	<cfset pages = ceiling(data.recordCount / application.settings.perpage)>
<cfelse>
	<cfset pages = 1>
</cfif>

<!--- Displays pagination on right side, plus left side buttons for threads --->
<cfmodule template="tags/pagination.cfm" pages="#pages#" mode="messages" />

<!--- Now display the table. This changes based on what our data is. --->
<cfoutput>
<a name="top" />
<p>
<table width="100%" cellpadding="6" class="tableDisplay" cellspacing="1" border="0">
	<tr class="tableHeader">
		<td colspan="2" class="tableHeader">Thread: #request.thread.name#</td>
	</tr>
	<tr class="tableSubHeader">
		<td class="tableSubHeader" colspan="2">
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr>
				<td><b>Created on:</b> #dateFormat(request.thread.dateCreated,"mm/dd/yy")# #timeFormat(request.thread.dateCreated,"hh:mm tt")#</td>
				<td align="right"><b>Replies:</b> #max(0,data.recordCount-1)#</td>
				</tr>
			</table>
		</td>
	</tr>
	<cfif data.recordCount>
		<cfloop query="data" startrow="#(url.page-1)*application.settings.perpage+1#" endrow="#(url.page-1)*application.settings.perpage+application.settings.perpage#">
			<cfset uinfo = request.udf.cachedUserInfo(username)>
			<tr class="tableRow#currentRow mod 2#" valign="top">
				<td width="170" class="tableMessageCell" rowspan="2"><b>#username#</b><br>
				#uInfo.rank#<br>
				<cfif application.settings.allowgravatars>
				<img src="http://www.gravatar.com/avatar.php?gravatar_id=#lcase(hash(uinfo.emailaddress))#&amp;rating=PG&amp;size=80&amp;default=#application.settings.rooturl#/images/gravatar.gif" alt="#username#'s Gravatar" border="0">
				</cfif>
				<br>
				<b>Joined:</b> #dateFormat(uInfo.dateCreated,"mm/dd/yy")#<br>
				<b>Posts:</b> #uInfo.postcount#</td>
				<td class="tableMessageCellRight">
					<a name="#currentRow#"></a>
					<cfif currentRow is recordCount><a name="last"></a></cfif>
					<b>#title#</b><br>
					#dateFormat(posted,"mm/dd/yy")# #timeFormat(posted,"h:mm tt")#<br>
					<cfif len(attachment)>Attachment: <a href="attachment.cfm?id=#id#">#attachment#</a><br></cfif>
					<br>
					<!---
					#request.udf.paragraphFormat2(request.udf.activateURL(body))#
					--->
					#application.message.renderMessage(body)#
					
					<cfif len(uinfo.signature)><div class="signature">#uinfo.signature#</div></cfif>
					
					<cfif request.udf.isLoggedOn() and application.utils.isTheUserInAnyRole("forumsadmin,forumsmoderator")>
					<p align="right"><a href="message_edit.cfm?id=#id#">[Edit Post]</a></p>
					</cfif>
				</td>
			</tr>
			<tr>
				<td class="tableMessageCellRight" align="right">
				<cfif isBoolean(cgi.server_port_secure) and cgi.server_port_secure>
					<cfset pre = "https">
				<cfelse>
					<cfset pre = "http">
				</cfif>
				<cfset link = "#pre#://#cgi.server_name##cgi.script_name#?#cgi.query_string####currentrow#">
				<span class="linktext"><a href="#link#">Link</a> | <a href="##top">Top</a> | <a href="##bottom">Bottom</a></span>
				</td>
			</tr>
		</cfloop>
	<cfelse>
		<tr class="tableRow1">
			<td colspan="2">Sorry, but there are no messages available for this thread.</td>
		</tr>
	</cfif>
</table>
</p>
<a name="bottom" />
</cfoutput>

<cfoutput>
<a name="newpost" />
<p>
<table width="100%" cellpadding="6" class="tableDisplay" cellspacing="1" border="0">
	<tr class="tableHeader">
		<td class="tableHeader">New Post</td>
	</tr>
	<cfif isDefined("errors") and len(errors)>
	<tr class="tableRowMain">
		<td>
		Please correct the following error(s):<ul><b>#errors#</b></ul>
		</td>
	</tr>
	</cfif>
	<tr class="tableRowMain">
		<td>
		<form action="#cgi.script_name#?#cgi.query_string#&##newpost" method="post" enctype="multipart/form-data">
		<input type="hidden" name="post" value="1">

		<table>
			<cfif not request.udf.isLoggedOn()>
				<cfset thisPage = cgi.script_name & "?" & cgi.query_string & "&##newpost">
				<cfset link = "login.cfm?ref=#urlEncodedFormat(thisPage)#">

				<tr>
					<td>Please <a href="#link#">login</a> to post a response.</td>
				</tr>
			<cfelseif application.utils.isTheUserInAnyRole("forumsadmin,forumsmoderator") or not readonly>
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
					<td align="right"><cfif not isDefined("request.thread")><input type="image" src="images/btn_new_topic.gif" alt="New Topic" title="New Topic" width="71" height="19" name="post"><cfelse><input type="image" src="images/btn_reply.gif" alt="Reply" title="Reply" width="52" height="19" name="post"></cfif></td>
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
