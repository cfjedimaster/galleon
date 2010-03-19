<cfsetting enablecfoutputonly=true>

<cfif not request.udf.isLoggedOn()>
	<cfset thisPage = cgi.script_name & "?" & cgi.query_string>
	<cflocation url="login.cfm?ref=#urlEncodedFormat(thisPage)#" addToken="false">
</cfif>


<cfparam name="form.subject" default="">
<cfparam name="form.body" default="">
<cfparam name="url.user" default="">
<cfparam name="form.to" default="#url.user#">
<cfset showForm = true>

<cfif structKeyExists(form, "send")>
	<cfset errors = "">
	<cfset touser = application.user.getUser(form.to)>
	<cfif touser.id is "">
		<cfset errors = errors & "You did not specify a valid user.<br/>">
	</cfif>
	
	<cfset form.subject = trim(htmlEditFormat(form.subject))>
	<cfset form.body = trim(htmlEditFormat(form.body))>
	
	<cfif not len(form.subject)>
		<cfset errors = errors & "You did not specify a subject for your message.<br/>">
	</cfif>
	<cfif not len(form.body)>
		<cfset errors = errors & "You did not specify a body for your message.<br/>">
	</cfif>
	
	<cfif not len(errors)>
		<!--- Send the PM --->
		<cfset showForm = false>
		<cfset application.user.sendPrivateMessage(to=form.to,from=getAuthUser(), subject=form.subject, body=form.body)>
		
	</cfif>
	
</cfif>


<!--- Loads header --->
<cfmodule template="tags/layout.cfm" templatename="main" title="#application.settings.title# : Send Private Message">

<cfoutput>
	<!-- Content Start -->
	<div class="content_box">
					
		<!-- Register Start -->
		<div class="row_title">
			<p>Send Private Message</p>
		</div>

		<cfif showForm>
		
			<div class="row_1">
			<p>The form below may be used to send a private message to another user. No one else will be able to read the message.</p>
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
				<form action="#cgi.script_name#" method="post" class="sendpm_form">
				<input type="hidden" name="send" value="1">
					
				<p class="input_name">To:</p>
				<input type="text" name="to" value="#form.to#"  class="input_box">
				
				<div class="clearer"><br /></div>
				
				<p class="input_name">Subject:</p>
				<input type="text" name="subject" value="#form.subject#"  class="input_box">
	
				<div class="clearer"><br /></div>
				
				<p class="input_name">Body:</p>
				<textarea name="body">#form.body#</textarea>
				
				<div class="clearer"><br /></div>
	
				<input type="image" src="images/btn_send.gif" title="Send" name="send" class="submit_btns">
				<div class="clearer"><br /></div>
							
				</form>
				
			</div>	
			<!-- Form Ender -->
		
		<cfelse>
			<div class="row_1">
			<p>Your message has been sent.</p>
			</div>
		</cfif>				
	</div>
	<!-- Content End -->

</cfoutput>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>
