<cfsetting enablecfoutputonly=true>
<!---
	Name         : profile.cfm
	Author       : Raymond Camden 
	Created      : July 5, 2004
	Last Updated : November 3, 2006
	History      : Changes due to subscriptions (7/29/05)
				   Removed mappings (rkc 8/27/05)
				   title fix (rkc 8/4/06)
				   signature fix, email fix (rkc 11/3/06)
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
<cfif isDefined("url.removeSub")>
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
	
	<cfif not len(errors)>

		<cfif len(trim(form.password_new))>
			<cfset user.password = form.password_new>
		</cfif>
			
		<cfset application.user.saveUser(username=getAuthUser(),password=user.password,emailaddress=form.emailaddress,datecreated=user.datecreated,groups=application.user.getGroupsForUser(getAuthUser()), signature=form.signature, confirmed=true)>
				
	</cfif>
		
</cfif>

<cfoutput>
<p>
<table width="500" cellpadding="6" class="tableDisplay" cellspacing="1" border="0">
	<tr class="tableHeader">
		<td class="tableHeader">Profile</td>
	</tr>
	<tr class="tableRowMain">
		<td>
		Please use the form below to edit your profile.
		<cfif isDefined("errors")>
			<cfif len(errors)>
				<p>
				Please correct the following error(s):<ul><b>#errors#</b></ul>
				</p>
			<cfelse>
				<p>
				Your profile has been updated.
				</p>
			</cfif>
		</cfif>
		</td>
	</tr>
	<tr class="tableRowMain">
		<td>
		<form action="#cgi.script_name#" method="post">
		<input type="hidden" name="save" value="1">
		<table>
			<tr>
				<td><b>Username:</b></td>
				<td>#user.username#</td>
			</tr>
			<tr>
				<td><b>Email Address:</b></td>
				<td><input type="text" name="emailaddress" value="#user.emailaddress#" class="formBox"></td>
			</tr>
			<tr>
				<td><b>New Password:</b></td>
				<td><input type="password" name="password_new" class="formBox"></td>
			</tr>
			<tr>
				<td><b>Confirm Password:</b></td>
				<td><input type="password" name="password_confirm" class="formBox"></td>
			</tr>
			<tr valign="top">
				<td><b>Signature (1000 character max):</b></td>
				<td><textarea name="signature" class="formTextArea">#form.signature#</textarea></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td align="right"><input type="image" src="images/btn_save.gif" alt="Save" width="49" height="19" name="save"></td>
			</tr>
		</table>
		</form>
		</td>
	</tr>

</table>
</p>

<p>
<table width="500" cellpadding="6" class="tableDisplay" cellspacing="1" border="0">
	<tr class="tableHeader">
		<td class="tableHeader">Subscriptions</td>
	</tr>
	<cfif isDefined("subscribeMessage")>
	<tr class="tableRowMain">
		<td>
		#subscribeMessage#
		</td>
	</tr>
	</cfif>
	<tr class="tableRowMain">
		<td>
		<cfif subs.recordCount is 0>
			You are not currently subscribed to anything.
		<cfelse>
			The following are your subscription(s):
			<p>
			<table>
			<cfloop query="subs">
				<tr>
					<td>
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
					#label#:
					</td>
					<td><a href="#link#">#data.name#</a></td> 
					<td>[<a href="profile.cfm?removeSub=#id#">Unsubscribe</a>]</td>
			</cfloop>
			</table>
			</p>
		</cfif>
		</td>
	</tr>

</table>
</p>

</cfoutput>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>
