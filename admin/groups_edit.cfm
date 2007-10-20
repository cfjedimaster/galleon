<cfsetting enablecfoutputonly=true>
<!---
	Name         : groups_edit.cfm
	Author       : Raymond Camden 
	Created      : August 23, 2007
	Last Updated : 
	History      : 
	Purpose		 : 
--->

<cfif isDefined("form.cancel.x") or not isDefined("url.id")>
	<cflocation url="groups.cfm" addToken="false">
</cfif>

<cfif isDefined("form.save.x")>
	<cfset errors = "">

	<cfif not len(trim(form.group))>
		<cfset errors = errors & "You must specify a group.<br>">
	</cfif>
	<cfif not len(errors)>
		<cfset form.group = trim(htmlEditFormat(form.group))>
		<cfif url.id neq 0>
			<cftry>
				<cfset application.user.saveGroup(form.id, form.group)>
				<cfcatch>
					<cfset errors = cfcatch.message & " " & cfcatch.detail>
				</cfcatch>
			</cftry>
		<cfelse>
			<cftry>
				<cfset application.user.addGroup(form.group)>
				<cfcatch>
					<cfset errors = cfcatch.message & " " & cfcatch.detail>
				</cfcatch>
			</cftry>
		</cfif>
		<cfif not len(errors)>
			<cfset msg = "Group, #form.group#, has been updated.">
			<cflocation url="groups.cfm?msg=#urlEncodedFormat(msg)#" addToken="false">
		</cfif>
	</cfif>
</cfif>

<!--- get group if not new --->
<cfif url.id neq 0>
	<cfset group = application.user.getGroup(url.id)>
	<cfparam name="form.group" default="#group.group#">
<cfelse>
	<cfparam name="form.group" default="">
</cfif>

<cfmodule template="../tags/layout.cfm" templatename="admin" title="Group Editor">

<cfoutput>
<form action="#cgi.script_name#?#cgi.query_string#" method="post">
<div class="clearer"></div>
<cfif isDefined("errors")><div class="input_error"><ul><b>#errors#</b></ul></div></cfif>

<div class="clearer"></div>
<div class="name_row">
<p class="left_100"></p>
</div>

<div class="row_0">
	<p class="input_name">Name</p>
	<input type="text" name="group" value="#form.group#" class="inputs_01">
	<div class="clearer"></div>
</div>
<input type="hidden" name="id" value="#url.id#">

<div id="input_btns">	
	<input type="image" src="../images/btn_save.jpg"  name="save" value="Save">
	<input type="image" src="../images/btn_cancel.jpg" type="submit" name="cancel" value="Cancel">
</div>

</form>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly=false>