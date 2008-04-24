<cfsetting enablecfoutputonly=true>
<!---
	Name         : messages.cfm
	Author       : Raymond Camden 
	Created      : June 10, 2004
	Last Updated : December 13, 2007
	History      : Reset for V2
				 : New link to last past (rkc 11/10/07)
				 : Format sigs a bit nicer. (rkc 12/13/07)
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

<!--- Am I allowed to look at this? --->
<cfif not application.permission.allowed(application.rights.CANVIEW, request.forum.id, request.udf.getGroups()) or 
		not application.permission.allowed(application.rights.CANVIEW, request.conference.id, request.udf.getGroups())>
	<cflocation url="denied.cfm" addToken="false">
</cfif>
<!--- Am I allowed to post here? --->
<cfif application.permission.allowed(application.rights.CANPOST, request.forum.id, request.udf.getGroups()) and
	  application.permission.allowed(application.rights.CANPOST, request.conference.id, request.udf.getGroups())>
	<cfset canPost = true>
<cfelse>
	<cfset canPost = false>
</cfif>

<!--- handle new post --->
<cfparam name="form.title" default="RE: #request.thread.name#">
<cfparam name="form.body" default="">
<cfparam name="form.subscribe" default="false">
<cfparam name="form.oldattachment" default="">
<cfparam name="form.attachment" default="">
<cfparam name="form.filename" default="">

<cfif isDefined("form.post") and canPost>

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

		<cflocation url="messages.cfm?threadid=#url.threadid#&last=true" addToken="false">
	</cfif>
	
</cfif>

<!--- clean up possible CSS attack --->
<cfset qs = replaceList(cgi.query_string,"<,>",",")>

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

<!--- last page cheat --->
<cfif structKeyExists(url, "last")>
	<!---
	<cfset url.page = pages>
	--->
	<cflocation url="messages.cfm?threadid=#url.threadid#&page=#pages#&###data.recordCount#" addToken="false">
</cfif>

<!--- Displays pagination on right side, plus left side buttons for threads --->
<cfmodule template="tags/pagination.cfm" pages="#pages#" mode="messages" canPost="#canPost#" />

<!--- Now display the table. This changes based on what our data is. --->
<cfoutput>
	
	
	
		<!-- Content Start -->
	<div class="content_box">
		
		<!-- Post Box Start -->
		<div class="row_title">
			<p><a name="top"></a>Thread: #request.thread.name#</p>
		</div>
		
		<div class="row_0">
			<div class="left_70"><p><span class="bolder">Created on:</span> #dateFormat(request.thread.dateCreated,"mm/dd/yy")# #timeFormat(request.thread.dateCreated,"hh:mm tt")#</p></div>
			<div class="right_20 align_right right_pad"><p><span class="bolder">Replies:</span> #max(0,data.recordCount-1)#</p></div>
		</div>
		
		<!-- Post start -->
		<cfif data.recordCount>
		<cfloop query="data" startrow="#(url.page-1)*application.settings.perpage+1#" endrow="#(url.page-1)*application.settings.perpage+application.settings.perpage#">
		<cfset uinfo = request.udf.cachedUserInfo(username)>
		<div class="forum_post">
			
			<div class="forum_post_identity">
		
				<p class="bolder">#username#</p><br />
				#uInfo.rank#<br>
				<cfif application.settings.allowavatars>
					<cfif uinfo.avatar is "@gravatar">
					<img src="http://www.gravatar.com/avatar.php?gravatar_id=#lcase(hash(uinfo.emailaddress))#&amp;rating=PG&amp;size=80&amp;default=#application.settings.rooturl#/images/gravatar.gif" alt="#username#'s Gravatar">
					<cfelseif len(uinfo.avatar)>
					<img src="images/avatars/#uinfo.avatar#" alt="#username#'s Gravatar">
					</cfif>
				</cfif>
				<br /><br />
				<p><span class="bolder">Joined:</span> #dateFormat(uInfo.dateCreated,"mm/dd/yy")#</p>
				<p><span class="bolder">Posts:</span> #uInfo.postcount#</p>
			</div>
			
			<div class="forum_post_right keep_on">
			<div class="post_padding">
				<a name="#currentRow#"></a>
				<cfif currentRow is recordCount><a name="last"></a></cfif>
				<p><span class="bolder">#title#</span><br />
				#dateFormat(posted,"mm/dd/yy")# #timeFormat(posted,"h:mm tt")#<br>
				<cfif len(attachment)>Attachment: <a href="attachment.cfm?id=#id#">#attachment#</a></cfif></p>

				<div class="forum_post_content">
				<!--- #application.message.renderMessage(body)# --->
				<cfmodule template="tags/DP_ParseBBML.cfm" input="#body#" outputvar="result" convertsmilies="true" smileypath="images/Smilies/Default/">
				#result.output#
				<cfif len(uinfo.signature)>
					<cfset sig = uinfo.signature>
					<cfset sig = replaceList(sig, "#chr(10)#,#chr(13)#","<br>,<br>")>
					<cfset sig = replace(uinfo.signature,chr(13)&chr(10),chr(10),"ALL")>
					<cfset sig = replace(sig,chr(13),chr(10),"ALL")>
					<cfset sig = replace(sig,chr(10),"<br />","ALL")>
					<div class="signature">#sig#</div>
				</cfif>
				<cfif request.udf.isLoggedOn() and application.utils.isTheUserInAnyRole("forumsadmin,forumsmoderator")>
				<br />
				<p align="right"><a href="message_edit.cfm?id=#id#">[Edit Post]</a></p>
				</cfif>
				</div> 		
				
			</div>
				<cfif isBoolean(cgi.server_port_secure) and cgi.server_port_secure>
					<cfset pre = "https">
				<cfelse>
					<cfset pre = "http">
				</cfif>
				<cfset link = "#pre#://#cgi.server_name##cgi.script_name#?#qs####currentrow#">
				
				<div class="forum_post_links"><p>
					<a href="#link#">Link</a> | 
					<a href="##top">Top</a> | 
					<a href="##bottom">Bottom</a>
				</p></div>
				
			</div>
			
		<div class="clearer"></div>
		</div>
		</cfloop>
		<cfelse>
		<div class="row_1">
			<p>Sorry, but there are no messages available for this thread.</p>
		</div>
		</cfif>
		<!-- Post end -->
		<a name="bottom" /></a>
		
		
					
	</div>
	<!-- Content End -->
	
	<!--- Displays pagination on right side, plus left side buttons for threads --->
	<cfmodule template="tags/pagination.cfm" pages="#pages#" mode="messages" canPost="#canPost#" />

	
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
		<cfif not request.udf.isLoggedOn()>
		<cfset thisPage = cgi.script_name & "?" & cgi.query_string & "&##newpost">
		<cfset link = "login.cfm?ref=#urlEncodedFormat(thisPage)#">
		<div class="row_0">
			<div class="left_90"><p>Please <a href="#link#">login</a> to post a response.</p></div>
		</div>
		<cfelseif canPost>	
		<div class="row_1 top_pad">
			<form action="#cgi.script_name#?#qs#&##newpost" method="post" enctype="multipart/form-data" class="basic_forms">
			<input type="hidden" name="post" value="1">	
			<p class="input_name">Title:</p>
			<div class="clearer"></div>
			<input type="text" name="title" value="#form.title#" class="formBox">
			<div class="clearer"><br /></div>
			
			
			<p class="input_name">Body:</p>
			<div class="clearer"></div>
			#application.message.renderHelp()#
			<textarea id="markitup" class="edit_textarea" name="body" cols="100" rows="20">#form.body#</textarea>
			<cfif application.settings.bbcode_editor>
			Markup editor credit: <a href="http://markitup.jaysalvat.com/home/">markitup</a>
			</cfif>
			<div class="clearer"><br /></div>
			
			<p class="input_name">Subscribe:</p>
			<input type="checkbox" name="subscribe" value="true" <cfif form.subscribe>checked</cfif>>
			<!---
			<select name="subscribe">
				<option value="true" <cfif form.subscribe>selected</cfif>>Yes</option>
				<option value="false" <cfif not form.subscribe>selected</cfif>>No</option>
			</select>
			--->											
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
			</form>
		</div>
		<cfelse>
		<div class="row_0">
			<div class="clearer"></div>
			<p><b>Sorry, but you may not post here.</b></p>
		</div>
		</cfif>
		<!-- Message Edit Ender -->
		
	</div>
	<!-- Edit Message Container Ender -->

</cfoutput>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>
