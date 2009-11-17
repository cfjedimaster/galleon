<cfsetting enablecfoutputonly=true>
<!---
	Name         : newthread.cfm
	Author       : Raymond Camden 
	Created      : June 10, 2004
	Last Updated : October 12, 2007
	History      : Reset for V2
	Purpose		 : Displays form to add a thread.
--->

<!--- Loads header --->
<cfmodule template="tags/layout.cfm" templatename="main" title="#application.settings.title#">

<cfparam name="form.username_new" default="">
<cfparam name="form.emailaddress" default="">
<cfparam name="form.password_new" default="">
<cfparam name="form.password_new2" default="">

<cfset failedLogon = false>

<!--- clean up possible CSS attack --->
<cfif isDefined("url.ref")>
	<cfset url.ref = replaceList(url.ref,"<,>",",")>
</cfif>

<!--- did they try to logon and succeeed? --->
<cfif isDefined("form.logon")>
	<cfif request.udf.isLoggedOn()>
		<cfif isDefined("url.ref")>
			<cflocation url="#url.ref#" addToken="false">
		<cfelse>
			<cflocation url="index.cfm" addToken="false">
		</cfif>
	<cfelse>
		<cfset failedlogon = true>
	</cfif>
</cfif>

<!--- Handle attempted registration --->
<cfif isDefined("form.register")>
	<cfset errors = "">

	<cfif not len(trim(form.username_new)) or not request.udf.isValidUsername(form.username_new)>
		<cfset errors = errors & "You must enter a username. Only letters and numbers are allowed.<br>">
	</cfif>
	
	<cfif not len(trim(form.emailaddress)) or not request.udf.isEmail(form.emailaddress)>
		<cfset errors = errors & "You must enter a valid email address.<br>">
	</cfif>
	
	<cfif not isDefined("form.password_new") or not len(trim(form.password_new)) or form.password_new neq form.password_new2>
		<cfset errors = errors & "You must enter a valid password that matches the confirmation.<br>">
	</cfif>
	
	<cfif not len(errors)>
	
		<cftry>
		
			<cfset application.user.addUser(trim(form.username_new),trim(form.password_new),trim(form.emailaddress),"forumsmember")>
			<cfset mygroups = application.user.getGroupsForUser(trim(form.username_new))>
	
			<!--- Only login if no confirmation needed --->
			<cfif not application.settings.requireconfirmation>
				<cflogin>
					<cfset session.user = application.user.getUser(trim(form.username_new))>		
					<cfloginuser name="#trim(form.username_new)#" password="#trim(form.password_new)#" roles="#mygroups#">
				</cflogin>
				
				<cfif isDefined("url.ref")>
					<cflocation url="#url.ref#" addToken="false">
				<cfelse>
					<cflocation url="index.cfm" addToken="false">
				</cfif>
			<cfelse>
				<cfset showRequireConfirmation = true>
			</cfif>
			<cfcatch type="user cfc">
				<cfif findNoCase("User already exists",cfcatch.message)>
					<cfset errors = errors & "This username already exists.<br>">
				</cfif>
			</cfcatch>
			<cfcatch type="any">
				<cfset errors = "General DB error.">
				<cfsavecontent variable="mail">
				<cfoutput>
				<p>
				The following error was thrown during a user registration:
				</p>
				</cfoutput>
				<cfdump var="#cfcatch#">
				</cfsavecontent>
			<cfset application.mailService.sendMail(application.settings.sendonpost,application.settings.sendonpost,"#application.settings.title# Error Report","", mail)>
				
				<!---
				<cfdump var="#cfcatch.detail#">
				<cfdump var="#cfcatch.message#">
				<cfdump var="#cfcatch.tagcontext#">
				<cfdump var="#cfcatch#">
				--->
			</cfcatch>
		</cftry>

	</cfif>
		
</cfif>

<cfif isDefined("form.reminder") and len(trim(form.username_lookup))>
	<cfset data = application.user.getUser(trim(form.username_lookup))>
	<cfif data.emailaddress is not "">
		<cfsavecontent variable="body">
		<cfoutput>
This is a password reminder from #application.settings.title# at #application.settings.rooturl#.
Your password is: #data.password#
		</cfoutput>
		</cfsavecontent>
		<cfset application.mailService.sendMail(data.emailaddress,application.settings.fromaddress,"#application.settings.title# Password Reminder",trim(body))>
	
		<cfset sentInfo = true>
	</cfif>
</cfif>

<cfoutput>
	
	
	<!-- Content Start -->
	<div class="content_box">
		
		
		<cfif structKeyExists(variables, "showRequireConfirmation")>
		<div class="row_title">
			<p>Confirmation Required</p>
		</div>
		
		<div class="row_1">
			<p>In order to complete your registration, you must confirm your email
			address. An email has been sent to the address you used during registration.
			Follow the link in the email to complete registration. </p>
		</div>	
		<cfelse>
		<!-- Login Start -->
		<div class="row_title">
			<p>Login</p>
		</div>
		
		<div class="row_1">
			<p>Please use the form below to login.</p>
			<cfif failedLogon>
			<p>
			<cfif application.settings.requireconfirmation>
			<b>Either your username and password did not match or you have not completed your email confirmation.</b>
			<cfelse>
			<b>Your username and password did not work.</b>
			</cfif>
			</p>
			</cfif>
		</div>	
		
		<div class="row_1 top_pad">
			<form action="#cgi.script_name#?#cgi.query_string#" method="post" class="login_forms">
			<input type="hidden" name="logon" value="1">

				
			<p class="input_name">Username:</p>
			<input type="text" name="username" id="username" class="input_box">
			
			<div class="clearer"><br /></div>
			
			<p class="input_name">Password:</p>
			<input type="password" name="password" class="input_box">
			
			<div class="clearer"><br /></div>
			
			<input type="image" src="images/btn_login.gif" alt="Login" name="logon" class="submit_btns">
			
			<div class="clearer"><br /></div>
			
			</form>
			
		</div>
		<!-- Login Ender -->
			
		<!-- Register Start -->
		<div class="row_title">
			<p>Register</p>
		</div>
		
		<div class="row_1">
			<p>In order to create threads or reply to threads, you must register. All of the fields below are required.</p>
			<cfif isDefined("errors")>
			<p>Please correct the following error(s):</p>
			<div class="input_errors"><p><b>#errors#</b></p></div>
			</cfif>
		</div>	
		
		<div class="row_1 top_pad">
			<form action="#cgi.script_name#?#cgi.query_string#" method="post" class="login_forms">
			<input type="hidden" name="register" value="1">

				
			<p class="input_name">Username:</p>
			<input type="text" name="username_new" value="#htmlEditFormat(form.username_new)#" class="input_box">
			
			<div class="clearer"><br /></div>
			
			<p class="input_name">Email Address:</p>
			<input type="text" name="emailaddress" value="#htmlEditFormat(form.emailaddress)#" class="input_box">
			
			<div class="clearer"><br /></div>
			
			<p class="input_name">Password:</p>
			<input type="password" name="password_new" class="input_box">
			
			<div class="clearer"><br /></div>
			
			<p class="input_name">Confirm Password:</p>
			<input type="password" name="password_new2" class="input_box">
			
			<div class="clearer"><br /></div>
			
			<input type="image" src="images/btn_register.gif" alt="Register" class="submit_btns">

			
			<div class="clearer"><br /></div>
			
			</form>
			
		</div>	
		<!-- Register Ender -->
					
		<!-- Register Start -->
		<cfif application.settings.encryptpasswords>
		<cfelse>
		<div class="row_title">
			<p>Password Reminder</p>
		</div>
		
		<div class="row_1">
			<p>If you cannot remember your password, enter your username in the form below and your login information will be sent to you.</p>
			<cfif isDefined("form.reminder")>
				<cfif isDefined("variables.sentInfo")>
				<p><b>A reminder has been sent to your email address.</b></p>
				<cfelse>
				<p><b>Sorry, but your username could not be found in our system.</b></p>
				</cfif>
			</cfif>
		</div>	
		
		<div class="row_1 top_pad">

			<form action="#cgi.script_name#?#cgi.query_string#" method="post" class="login_forms">
			<input type="hidden" name="reminder" value="1">
				
			<p class="input_name">Username:</p>
			<input type="text" name="username_lookup" class="input_box">
						
			<div class="clearer"><br /></div>
			
			<input type="image" src="images/btn_sendpasswordreminder.gif" alt="Send-Password" name="logon" class="submit_btns">
			<div class="clearer"><br /></div>
			
			</form>
			
		</div>	
		<!-- Register Ender -->
		</cfif>
		</cfif>
	</div>
	<!-- Content End -->
	
<script>
window.onload = function() {document.getElementById("username").focus();}
</script>
</cfoutput>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>
