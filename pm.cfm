<cfsetting enablecfoutputonly=true>
<cfif not request.udf.isLoggedOn()>
	<cfset thisPage = cgi.script_name & "?" & cgi.query_string>
	<cflocation url="login.cfm?ref=#urlEncodedFormat(thisPage)#" addToken="false">
</cfif>

<cfset data = application.user.getPrivateMessage(url.id,getAuthUser())>
<cfparam name="form.subject" default="RE: #data.subject#">
<cfparam name="form.body" default="">


<cfif structKeyExists(form, "send")>
	<cfset errors = "">
	
	<cfif not len(form.subject)>
		<cfset errors = errors & "You did not specify a subject for your message.<br/>">
	</cfif>
	<cfif not len(form.body)>
		<cfset errors = errors & "You did not specify a body for your message.<br/>">
	</cfif>
	
	<cfif not len(errors)>
		<!--- Send the PM --->
		<cfset showForm = false>
		<cfset application.user.sendPrivateMessage(to=data.sender,from=getAuthUser(), subject=form.subject, body=form.body)>
		<cfset form.body = "">
		<cfset form.subject = "RE: #data.subject#">
		<cfset msgSent = true>
	</cfif>
	
</cfif>

<!--- Loads header --->
<cfmodule template="tags/layout.cfm" templatename="main" title="#application.settings.title# : Private Message : #data.subject#">

<cfoutput>
	<!-- Content Start -->
	<div class="content_box">

		<div class="row_title">
			<p>Subject: #data.subject#<br/>
			Sender: #data.sender#<br/>
			Sent: #dateFormat(data.sent,"m/d/yy")# #timeFormat(data.sent,"h:mm tt")#
			</p>
		</div>

		<div class="row_0">
		<p/>
		#paragraphformat(data.body)#
		</div>		
		
	</div>
	<!-- Content End -->

	<!-- Edit Message Container Start -->
	<div class="content_box">
	
		<!-- Message Edit Start -->
		<div class="row_title">
			<p>Reply</p>
		</div>
		<cfif isDefined("errors") and len(errors)>
		<div class="row_0">
			<div class="clearer"></div>
			<p>Please correct the following error(s):</p>
			<div class="submit_error"><p><b>#errors#</b></p></div><br />
		</div>
		<cfelseif structKeyExists(variables, "msgSent")>
			<div class="row_0">
			<div class="clearer"></div>
			<p>Your reply has been sent.</p>
		</div>

		</cfif>

		<div class="row_1 top_pad">
			<form action="" method="post" class="basic_forms">
			<input type="hidden" name="send" value="1">	
			<p class="input_name">Subject:</p>
			<div class="clearer"></div>
			<input type="text" name="subject" value="#form.subject#" class="formBox">
			<div class="clearer"><br /></div>
			
			
			<p class="input_name">Body:</p>
			<div class="clearer"></div>
			<textarea name="body" rows="20" style="width:100%">#form.body#</textarea>
			<div class="clearer"><br /></div>
			
			<input type="image" src="images/btn_reply.gif" alt="Reply" title="Reply" name="send" class="submit_btns">
			<div class="clearer"><br /></div>
			</form>
		</div>
		
	</div>
</cfoutput>

</cfmodule>