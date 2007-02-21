<cfsetting enablecfoutputonly=true>
<!---
	Name         : newthread.cfm
	Author       : Raymond Camden 
	Created      : June 10, 2004
	Last Updated : February 21, 2007
	History      : Support password reminders (rkc 2/18/05)
				   No more notifications (rkc 7/29/05)
				   Removed mappings (rkc 8/27/05)
				   require confirmation changes (rkc 7/12/06)
				   make title work (rkc 8/4/06)
				   handle encryption and auto-focus (rkc 11/3/06)
				   param a few fields I was assuming existed (rkc 2/21/07)
	Purpose		 : Displays form to add a thread.
--->

<!--- Loads header --->
<cfmodule template="tags/layout.cfm" templatename="main" title="#application.settings.title#">

<cfparam name="form.username_new" default="">
<cfparam name="form.emailaddress" default="">
<cfparam name="form.password_new" default="">
<cfparam name="form.password_new2" default="">

<cfset failedLogon = false>

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
		<cfmail to="#data.emailaddress#" from="#application.settings.fromAddress#" subject="Galleon Password Reminder">
This is a password reminder from the Galleon Forums at #application.settings.rooturl#.
Your password is: #data.password#
		</cfmail>
		<cfset sentInfo = true>
	</cfif>
</cfif>

<cfoutput>
<p>
<table width="500" cellpadding="6" class="tableDisplay" cellspacing="1" border="0">
	<cfif structKeyExists(variables, "showRequireConfirmation")>
		<tr class="tableHeader">
			<td class="tableHeader">Confirmation Required</td>
		</tr>
		<tr class="tableRowMain">
			<td>
			In order to complete your registration, you must confirm your email
			address. An email has been sent to the address you used during registration.
			Follow the link in the email to complete registration. 
			</td>
		</tr>
	
	<cfelse>
		<tr class="tableHeader">
			<td class="tableHeader">Login</td>
		</tr>
		<tr class="tableRowMain">
			<td>
			Please use the form below to login.
			<cfif failedLogon>
			<p>
			<cfif application.settings.requireconfirmation>
			<b>Either your username and password did not match or you have not completed your email confirmation.</b>
			<cfelse>
			<b>Your username and password did not work.</b>
			</cfif>
			</p>
			</cfif>
			</td>
		</tr>
		<tr class="tableRowMain">
			<td>
			<form action="#cgi.script_name#?#cgi.query_string#" method="post">
			<input type="hidden" name="logon" value="1">
			<table>
				<tr>
					<td><b>Username:</b></td>
					<td><input type="text" name="username" id="username" class="formBox"></td>
				</tr>
				<tr>
					<td><b>Password:</b></td>
					<td><input type="password" name="password" class="formBox"></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="right"><input type="image" src="images/btn_login.gif" alt="Login" width="71" height="19" name="logon"></td>
				</tr>
			</table>
			</form>
			</td>
		</tr>
		<tr class="tableHeader">
			<td class="tableHeader">Register</td>
		</tr>
		<tr class="tableRowMain">
			<td>
			In order to create threads or reply to threads, you must register. All of the
			fields below are required.
			<cfif isDefined("errors")>
				<p>
				Please correct the following error(s):<ul><b>#errors#</b></ul>
				</p>
			</cfif>
			</td>
		</tr>
		<tr class="tableRowMain">
			<td>
			<form action="#cgi.script_name#?#cgi.query_string#" method="post">
			<input type="hidden" name="register" value="1">
			<table>
				<tr>
					<td><b>Username: </b></td>
					<td><input type="text" name="username_new" value="#form.username_new#" class="formBox"></td>
				</tr>
				<tr>
					<td><b>Email Address: </b></td>
					<td><input type="text" name="emailaddress" value="#form.emailaddress#" class="formBox"></td>
				</tr>
				<tr>
					<td><b>Password: </b></td>
					<td><input type="password" name="password_new" class="formBox"></td>
				</tr>
				<tr>
					<td><b>Confirm Password: </b></td>
					<td><input type="password" name="password_new2" class="formBox"></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="right"><input type="image" src="images/btn_register.gif" alt="Register" width="71" height="19"></td>
				</tr>
			</table>
			</form>
			</td>
		</tr>
		<cfif application.settings.encryptpasswords>
		<cfelse>
		<tr class="tableHeader">
			<td class="tableHeader">Password Reminder</td>
		</tr>
		<tr class="tableRowMain">
			<td>
			If you cannot remember your password, enter your username in the form below and your login information will be sent to you.
			<cfif isDefined("form.reminder")>
				<cfif isDefined("variables.sentInfo")>
				<p>
				A reminder has been sent to your email address.
				</p>
				<cfelse>
				<p>
				Sorry, but your username could not be found in our system.
				</p>
				</cfif>
			</cfif>
			</td>
		</tr>
		<tr class="tableRowMain">
			<td>
			<form action="#cgi.script_name#?#cgi.query_string#" method="post">
			<input type="hidden" name="reminder" value="1">
			<table>
				<tr>
					<td><b>Username:</b></td>
					<td><input type="text" name="username_lookup" class="formBox"></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="right"><input type="image" src="images/btn_sendpasswordreminder.gif" alt="Login" width="149" height="19" name="logon"></td>
				</tr>
			</table>
			</form>
			</td>
		</tr>
		</cfif>
	</cfif>
</table>
</p>

<script>
window.onload = function() {document.getElementById("username").focus();}
</script>
</cfoutput>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>
