<cfsetting enablecfoutputonly=true>
<!---
	Name         : profile.cfm
	Author       : Raymond Camden 
	Created      : July 5, 2004
	Last Updated : October 12, 2007
	History      : Reset for V2
	Purpose		 : Displays form to edit your settings.
--->

<cfif not request.udf.isLoggedOn()>
	<cfset thisPage = cgi.script_name & "?" & cgi.query_string>
	<cflocation url="login.cfm?ref=#urlEncodedFormat(thisPage)#" addToken="false">
</cfif>

<!--- attempt to subscribe --->
<cfif isDefined("url.s")>
	<cftry>
	<cfif isDefined("url.threadid")>
		<cfset subMode = "thread">
		<cfset subID = url.threadID>
		<cfset thread = application.thread.getThread(subID)>
		<cfset name = thread.name>
	<cfelseif isDefined("url.forumid")>
		<cfset subMode = "forum">
		<cfset subID = url.forumid>
		<cfset forum = application.forum.getForum(subID)>
		<cfset name = forum.name>
	<cfelseif isDefined("url.conferenceid")>
		<cfset subMode = "conference">
		<cfset subID = url.conferenceid>
		<cfset conference = application.conference.getConference(subid)>
		<cfset name = conference.name>
	</cfif>
	<cfcatch>
		<cflocation url="/" addToken="false">
	</cfcatch>
	</cftry>
	<cfif isDefined("variables.subMode")>
		<cfset application.user.subscribe(getAuthUser(), subMode, subID)>
		<cfset subscribeMessage = "You have been subscribed to the #submode#: <b>#name#</b>">
	</cfif>
	
</cfif>

<!--- attempt to unsubscribe --->
<cfif isDefined("url.removeAllSub")>
	<cfset subs = application.user.getSubscriptions(getAuthUser())>
	<cfloop query="subs">
		<cfset application.user.unsubscribe(getAuthUser(), id)>
	</cfloop>
<cfelseif isDefined("url.removeSub")>
	<cftry>
		<cfset application.user.unsubscribe(getAuthUser(), url.removeSub)>
		<cfset subscribeMessage = "Your unsubscribe request has been processed.<br>">
		<cfcatch>
			<!--- silently fail ---><cfdump var="#cfcatch#"><cfabort>
		</cfcatch>
	</cftry>
</cfif>

<cfset user = application.user.getUser(getAuthUser())>
<cfset subs = application.user.getSubscriptions(getAuthUser())>
<cfparam name="form.emailaddress" default="#user.emailaddress#">
<cfparam name="form.password_new" default="">
<cfparam name="form.password_confirm" default="">
<cfparam name="form.signature" default="#user.signature#">

<cfif not structKeyExists(form, "usegravatar")>
	<cfif user.avatar is "@gravatar">
		<cfset form.usegravatar = true>
		<cfset variables.avatar = user.avatar>
	<cfelse>
		<cfset form.usegravatar = false>
		<cfset variables.avatar = user.avatar>
	</cfif>
</cfif>

<!--- Loads header --->
<cfmodule template="tags/layout.cfm" templatename="main" title="#application.settings.title# : Profile">

<!--- Handle attempted update --->
<cfif isDefined("form.save")>
	<cfset errors = "">
	
	<cfif not len(trim(form.emailaddress)) or not request.udf.isEmail(form.emailaddress)>
		<cfset errors = errors & "You must enter a valid email address.<br>">
	<cfelse>
		<cfset user.emailaddress = trim(htmlEditFormat(form.emailaddress))>
	</cfif>
	
	<cfif len(trim(form.password_new)) and form.password_new neq form.password_confirm>
		<cfset errors = errors & "To change your password, your confirmation password must match.<br>">
	</cfif>
	
	<cfif application.settings.allowavatars>
		<cfif len(form.newavatar)>
			<cffile action="upload" filefield="newavatar" destination="#getTempDirectory()#" nameConflict="makeunique">
			<cfif cffile.fileWasSaved>
				<!--- new file --->
				<cfset newfile = cffile.serverfile>
				<!--- is it an image? --->
				<cftry>
					<cfset res = application.image.getImageInfo("",cffile.serverdirectory & "/" & cffile.serverfile)>
					<cfcatch>
						<cffile action="delete" file="#cffile.serverdirectory#/#cffile.serverfile#">
						<cfset res = structNew()>
						<cfset res.errorcode = 1>
					</cfcatch>
				</cftry>
				<cfif res.errorcode is 1>
					<cfset errors = errors & "File uploaded was not valid.<br>">
					<cffile action="delete" file="#cffile.serverdirectory#/#cffile.serverfile#">
				<cfelse>
					<!--- copy from temp --->
					<cfset newPath = application.settings.avatardir & "/" & createUUID() & "." & cffile.serverfileext>
					<cffile action="move" source="#cffile.serverdirectory#/#cffile.serverfile#" destination="#newpath#">

					<!--- scale --->
					<cfset application.image.resize("", newpath, newpath,
													150,150,true)>
					
					<cfset avatar = getFileFromPath(newpath)>
					<!--- delete old --->
					<cfif len(user.avatar) and user.avatar neq "@gravatar" and fileExists(application.settings.avatardir & "/" & user.avatar)>
						<cffile action="delete" file="#application.settings.avatardir#/#user.avatar#">
					</cfif>
					<cfset form.usegravatar = false>
				</cfif>
			</cfif>
		<cfelseif structKeyExists(form, "usegravatar") and form.usegravatar>
			<cfset avatar = "@gravatar">
			<!--- delete old --->
			<cfif len(user.avatar) and user.avatar neq "@gravatar" and fileExists(application.settings.avatardir & "/" & user.avatar)>
				<cffile action="delete" file="#application.settings.avatardir#/#user.avatar#">
			</cfif>
		<cfelseif structKeyExists(form, "deleteavatar")>
			<!--- delete old --->
			<cfif len(user.avatar) and user.avatar neq "@gravatar" and fileExists(application.settings.avatardir & "/" & user.avatar)>
				<cffile action="delete" file="#application.settings.avatardir#/#user.avatar#">
			</cfif>
			<cfset avatar = "">
		</cfif>
	<cfelse>
		<cfset avatar = "">
	</cfif>

	<cfif not len(errors)>
		<cfset s = structNew()>
		<cfif len(trim(form.password_new))>
			<cfset s.password = form.password_new>
		</cfif>
		<cfset application.user.saveUser(username=getAuthUser(),emailaddress=form.emailaddress,datecreated=user.datecreated,groups=application.user.getGroupsForUser(getAuthUser()), signature=form.signature, confirmed=true, avatar=avatar, argumentCollection=s)>
		<cfset request.udf.cachedUserInfo(getAuthUser(),false)>		
	</cfif>
		
</cfif>

<cfoutput>
	<!-- Content Start -->
	<div class="content_box">
					
		<!-- Register Start -->
		<div class="row_title">
			<p>Profile</p>
		</div>
		
		<div class="row_1">
		<p>Please use the form below to edit your profile.</p>
		<cfif isDefined("errors")>
			<cfif len(errors)>
				<p>Please correct the following error(s):</p>
				<div class="submit_errors"><p><b>#errors#</b></p></div>
				
			<cfelse>
				<p>Your profile has been updated.</p>
			</cfif>
		</cfif>
		</div>	
		
		<div class="row_1 top_pad">
			<form action="#cgi.script_name#" method="post" enctype="multipart/form-data" class="profile_form">
			<input type="hidden" name="save" value="1">
				
			<p class="input_name">Username:</p>
			<p class="profile_username">#user.username#</p>
			
			<div class="clearer"><br /></div>
			
			<p class="input_name">Email Address:</p>
			<input type="text" name="emailaddress" value="#user.emailaddress#"  class="input_box">

			<div class="clearer"><br /></div>
			
			<p class="input_name">New Password:</p>
			<input type="password" name="password_new" class="input_box">
			
			<div class="clearer"><br /></div>
			
			<p class="input_name">Confirm Password:</p>
			<input type="password" name="password_confirm" class="input_box">
			
			<div class="clearer"><br /></div>
			
			<p class="input_name">Signature:</p>
			<textarea name="signature" class="formTextArea">#form.signature#</textarea>
			<p class="input_name_extras">(1000 Character Max)</p>
			
			<div class="clearer"><br /></div>
			
			<cfif application.settings.allowavatars>
			<div class="avatar_title">Avatar Options:</div>
			
			<div class="avatar_options">
			
				<p>Use <a href="http://www.gravatar.com" target="_new">Gravatar</a>:<input type="checkbox" name="usegravatar" value="true" <cfif form.usegravatar>checked</cfif>></p>
				
				<div class="clearer"></div>
				
				<p>Upload Avatar (gif, jpg, and png):</p>
				<input type="file" name="newavatar" class="input_file">
				
				<div class="clearer"><br /></div>
				
				<cfif structKeyExists(variables, "avatar") and len(variables.avatar)>
				<p>Current Avatar:</p>
				<cfif variables.avatar neq "@gravatar">
					<img src="#application.settings.rooturl#/images/avatars/#variables.avatar#" title="#user.username#'s Avatar" />
					<p>Remove this picture:<input type="checkbox" name="deleteAvatar" value="true"></p>
				<cfelse>
					<img src="http://www.gravatar.com/avatar.php?gravatar_id=#lcase(hash(user.emailaddress))#&amp;rating=PG&amp;size=80&amp;default=#application.settings.rooturl#/images/gravatar.gif" title="#user.username#'s Gravatar">
				</cfif>			

				
				<div class="clearer"><br /></div>
				</cfif>
				</cfif>
				<input type="image" src="images/btn_save.gif" title="Save" name="save" class="submit_btns">
				
			</div>
			
			<div class="clearer"><br /></div>
			
			</form>
			
		</div>	
		<!-- Register Ender -->
						
	</div>
	<!-- Content End -->
	
	<!-- Content Start -->
	<div class="content_box">
		
		<!-- Bottom Login Box Start -->
		<div class="row_title">
			<p>Subscriptions</p>
		</div>
		
		<div class="row_0">
			<cfif isDefined("subscribeMessage")>
			<div class="left_90"><p>#subscribeMessage#</p></div>
			</cfif>
			<cfif subs.recordCount is 0>
			<div class="left_90"><p>You are not currently subscribed to anything.</p></div>
			<cfelse>
			<div class="left_90">
			<p>
			<a href="profile.cfm?removeAllSub=1">Unsubscribe from all</a>
			<p>
			The following are your subscription(s):
			</p></div>
			
			<cfloop query="subs">
				<cfif len(conferenceidfk)>
						<cfset data = application.conference.getConference(conferenceidfk)>
						<cfset label = "Conference">
						<cfset link = "forums.cfm?conferenceid=#conferenceidfk#">
					<cfelseif len(forumidfk)>
						<cfset data = application.forum.getForum(forumidfk)>
						<cfset label = "Forum">
						<cfset link = "threads.cfm?forumid=#threadidfk#">
					<cfelse>
						<cfset data = application.thread.getThread(threadidfk)>
						<cfset label = "Thread">
						<cfset link = "messages.cfm?threadid=#threadidfk#">
					</cfif>
			<div class="left_90">
				<p class="left_20">#label#:</p>
				<p class="left_40"><a href="#link#">#data.name#</a></p>
				<p class"left_30">[<a href="profile.cfm?removeSub=#id#">Unsubscribe</a>]</p>
			</div>
			</cfloop>
			</cfif>
			
		</div>
		<!-- Bottom Login Box Ender -->
					
	</div>
	<!-- Content End -->

</cfoutput>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>
