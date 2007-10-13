<cfsetting enablecfoutputonly=true>
<!---
	Name         : users_edit.cfm
	Author       : Raymond Camden 
	Created      : July 5, 2004
	Last Updated : October 12, 2007
	History      : Reset for V2
	Purpose		 : 
--->

<cfif isDefined("form.cancel") or not isDefined("url.id")>
	<cflocation url="users.cfm" addToken="false">
</cfif>

<cfif isDefined("form.save")>
	<cfset errors = "">

	<cfif not len(trim(form.username))>
		<cfset errors = errors & "You must specify a username.<br>">
	</cfif>
	<cfif not len(trim(form.emailaddress)) or not request.udf.isEmail(trim(form.emailaddress))>
		<cfset errors = errors & "You must specify an emailaddress.<br>">
	</cfif>
	<cfif not len(trim(form.password))>
		<cfset errors = errors & "You must specify a password.<br>">
	</cfif>
	<cfif not len(trim(form.datecreated)) or not isDate(form.datecreated)>
		<cfset errors = errors & "You must specify a creation date.<br>">
	</cfif>
	<cfif not structKeyExists(form,"groups") or not len(form.groups)>
		<cfset errors = errors & "You must specify at least one group for the user.<br>">
	</cfif>
	<cfif not len(errors)>
		<cfset user = structNew()>
		<cfset form.username = trim(htmlEditFormat(form.username))>
		<cfset form.emailaddress = trim(form.emailaddress)>
		<cfset form.password = trim(form.password)>
		<cfset form.datecreated = trim(htmlEditFormat(form.datecreated))>
		<cfparam name="form.groups" default="">
		<!--- set confirmed to true if not passed --->
		<cfparam name="form.confirmed" default="true">
		<cfif url.id neq 0>
			<cfset application.user.saveUser(form.username, form.password, form.emailaddress, form.datecreated,form.groups,form.confirmed)>
		<cfelse>
			<cftry>
				<cfset application.user.addUser(form.username, form.password, form.emailaddress, form.groups,form.confirmed)>
				<cfcatch>
					<cfset errors = cfcatch.message>
				</cfcatch>
			</cftry>
		</cfif>
		<cfif not len(errors)>
			<cfset msg = "User, #form.username#, has been updated.">
			<cflocation url="users.cfm?msg=#urlEncodedFormat(msg)#" addToken="false">
		</cfif>
	</cfif>
</cfif>

<!--- get user if not new --->
<cfif url.id gte 1>
	<cfset user = application.user.getUser(url.id)>
	<cfparam name="form.username" default="#user.username#">
	<cfparam name="form.emailaddress" default="#user.emailaddress#">
	<cfparam name="form.password" default="#user.password#">
	<cfparam name="form.datecreated" default="#dateFormat(user.datecreated,"m/dd/yy")# #timeFormat(user.datecreated,"h:mm tt")#">
	<cfparam name="form.groups" default="#user.groups#">
	<cfparam name="form.confirmed" default="#user.confirmed#">
<cfelse>
	<cfparam name="form.username" default="">
	<cfparam name="form.emailaddress" default="">
	<cfparam name="form.password" default="">
	<cfparam name="form.datecreated" default="#dateFormat(now(),"m/dd/yy")# #timeFormat(now(),"h:mm tt")#">
	<cfparam name="form.groups" default="">
	<cfparam name="form.confirmed" default="0">
</cfif>

<cfset groups = application.user.getGroups()>

<cfmodule template="../tags/layout.cfm" templatename="admin" title="User Editor">

<cfoutput>
<form action="#cgi.script_name#?#cgi.query_string#" method="post">
<cfif isDefined("errors")><ul><b>#errors#</b></ul></cfif>

<div class="clearer"></div>
<div class="name_row">
<p class="left_100"></p>
</div>

<div class="row_0">
	<p class="input_name">User Name</p>
	<cfif url.id is not "0">
		<input type="hidden" name="username" value="#form.username#">#form.username#
	<cfelse>
		<input type="text" name="username" value="#form.username#" class="inputs_01"></td>
	</cfif>
	<div class="clearer"></div>
</div>

<div class="row_1">
	<p class="input_name">Email Address</p>
	<input type="text" name="emailaddress" value="#form.emailaddress#" class="inputs_01">
	<div class="clearer"></div>
</div>

<div class="row_0">
	<p class="input_name">Password</p>
	<input type="text" name="password" value="#form.password#" class="inputs_01">
	<div class="clearer"></div>
</div>

<div class="row_1">
	<p class="input_name">Date Created</p>
	<input type="text" name="datecreated" value="#form.datecreated#" class="inputs_01">
	<div class="clearer"></div>
</div>

<div class="row_0">
	<p class="input_name">Groups</p>
		<select name="groups" class="inputs_02" multiple size="3">
		<cfloop query="groups">
		<option value="#group#" <cfif listFindNoCase(form.groups, group)>selected</cfif>>#group#</option>
		</cfloop>
		</select>
<div class="clearer"></div>
</div>

<cfif application.settings.requireconfirmation>
<div class="row_1">
	<p class="input_name">Confirmed</p>
		<select name="confirmed" class="inputs_02">
		<option value="0" <cfif not form.confirmed>selected</cfif>>No</option>
		<option value="1" <cfif form.confirmed>selected</cfif>>Yes</option>
		</select>
<div class="clearer"></div>
</div>
</cfif>

<div id="input_btns">	
	<input type="image" src="../images/btn_save.jpg"  name="save" value="Save">
	<input type="image" src="../images/btn_cancel.jpg" type="submit" name="cancel" value="Cancel">
</div>
</form>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly=false>