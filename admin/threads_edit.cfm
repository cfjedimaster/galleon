<cfsetting enablecfoutputonly=true>
<!---
	Name         : threads_edit.cfm
	Author       : Raymond Camden 
	Created      : June 09, 2004
	Last Updated : October 12, 2007
	History      : Reset for V2
	Purpose		 : 
--->

<cfif isDefined("form.cancel.x") or not isDefined("url.id") or not len(url.id)>
	<cflocation url="threads.cfm" addToken="false">
</cfif>

<cfif isDefined("form.save.x")>
	<cfset errors = "">
	<cfif not len(trim(form.name))>
		<cfset errors = errors & "You must specify a name.<br>">
	</cfif>
	<cfif not len(trim(form.datecreated)) or not isDate(form.datecreated)>
		<cfset errors = errors & "You must specify a valid creation date.<br>">
	</cfif>

	<cfif not len(errors)>
		<cfset thread = structNew()>
		<cfset thread.name = trim(htmlEditFormat(form.name))>
		<cfset thread.active = trim(htmlEditFormat(form.active))>
		<cfset thread.forumidfk = trim(htmlEditFormat(form.forumidfk))>
		<cfset thread.datecreated = trim(htmlEditFormat(form.datecreated))>
		<cfset thread.useridfk = trim(htmlEditFormat(form.useridfk))>
		<cfset thread.sticky = trim(htmlEditFormat(form.sticky))>
		<cfif url.id neq 0>
			<cfset application.thread.saveThread(url.id, thread)>
		<cfelse>
			<cfset application.thread.addThread(thread)>
		</cfif>
		<cfset msg = "Thread, #thread.name#, has been updated.">
		<cflocation url="threads.cfm?msg=#urlEncodedFormat(msg)#" addToken="false">
	</cfif>
</cfif>

<!--- get thread if not new --->
<cfif url.id neq 0>
	<cfset thread = application.thread.getThread(url.id)>
	<cfparam name="form.name" default="#thread.name#">
	<cfparam name="form.active" default="#thread.active#">
	<cfparam name="form.forumidfk" default="#thread.forumidfk#">
	<cfparam name="form.datecreated" default="#dateFormat(thread.datecreated,"m/dd/yy")#">
	<cfparam name="form.useridfk" default="#thread.useridfk#">
	<cfparam name="form.sticky" default="#thread.sticky#">
<cfelse>
	<cfparam name="form.name" default="">
	<cfparam name="form.active" default="false">
	<cfparam name="form.forumidfk" default="">
	<cfparam name="form.datecreated" default="#dateFormat(now(),"m/dd/yy")#">
	<cfparam name="form.useridfk" default="">
	<cfparam name="form.sticky" default="false">
</cfif>

<!--- get all forums --->
<cfset forums = application.forum.getForums(false)>

<!--- get all users --->
<cfset users = application.user.getUsers()>

<cfmodule template="../tags/layout.cfm" templatename="admin" title="Thread Editor">

<cfoutput>
<form action="#cgi.script_name#?#cgi.query_string#" method="post">

<div class="clearer"></div>
<cfif isDefined("errors")><div class="input_error"><ul><b>#errors#</b></ul></div></cfif>

<div class="name_row">
<p class="left_100"></p>
</div>

<div class="row_0">
	<p class="input_name">Name</p>
	<input type="text" name="name" value="#form.name#" class="inputs_01">
	<div class="clearer"></div>
</div>

<div class="row_1">
	<p class="input_name">Forum</p>
		<select name="forumidfk" class="inputs_02">
			<cfloop query="forums">
			<option value="#id#" <cfif form.forumidfk is id>selected</cfif>>#name#</option>
			</cfloop>
		</select>
<div class="clearer"></div>
</div>

<div class="row_0">
	<p class="input_name">Date Created:</p>
	<input type="text" name="datecreated" value="#form.datecreated#" class="inputs_01">
	<div class="clearer"></div>
</div>

<div class="row_1">
	<p class="input_name">User</p>
		<select name="useridfk" class="inputs_02">
			<cfloop query="users">
			<option value="#id#" <cfif form.useridfk is id>selected</cfif>>#username#</option>
			</cfloop>
		</select>
<div class="clearer"></div>
</div>


<div class="row_0">
	<p class="input_name">Active</p>
	<select name="active" class="inputs_02">
		<option value="1" <cfif form.active>selected</cfif>>Yes</option>
		<option value="0" <cfif not form.active>selected</cfif>>No</option>
	</select>
<div class="clearer"></div>
</div>


<div class="row_1">
	<p class="input_name">Sticky</p>
	<select name="sticky" class="inputs_02">
		<option value="1" <cfif isBoolean(form.sticky) and form.sticky>selected</cfif>>Yes</option>
		<option value="0" <cfif (isBoolean(form.sticky) and not form.sticky) or not isBoolean(form.sticky)>selected</cfif>>No</option>
	</select>
<div class="clearer"></div>
</div>

<div id="input_btns">	
	<input type="image" src="../images/btn_save.jpg"  name="save" value="Save">
	<input type="image" src="../images/btn_cancel.jpg" type="submit" name="cancel" value="Cancel">
</div>
</form>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly=false>