<cfsetting enablecfoutputonly=true>
<!---
	Name         : conferences_edit.cfm
	Author       : Raymond Camden 
	Created      : June 01, 2004
	Last Updated : October 12, 2007
	History      : Reset for V2
	Purpose		 : 
--->

<cfif isDefined("form.cancel") or not isDefined("url.id") or not len(url.id)>
	<cflocation url="conferences.cfm" addToken="false">
</cfif>

<cfif isDefined("form.save")>
	<cfset errors = "">
	<cfif not len(trim(form.name))>
		<cfset errors = errors & "You must specify a name.<br>">
	</cfif>
	<cfif not len(trim(form.description))>
		<cfset errors = errors & "You must specify a description.<br>">
	</cfif>
	<cfif not len(errors)>
		<cfset conference = structNew()>
		<cfset conference.name = trim(htmlEditFormat(form.name))>
		<cfset conference.description = trim(htmlEditFormat(form.description))>
		<cfset conference.active = trim(htmlEditFormat(form.active))>
		<cfif url.id neq 0>
			<cfset application.conference.saveConference(url.id, conference)>
		<cfelse>
			<cfset url.id = application.conference.addConference(conference)>
		</cfif>
		<!--- update security --->
		<cfset application.permission.setAllowed(application.rights.CANVIEW, url.id, form.canread)>
		<cfset application.permission.setAllowed(application.rights.CANPOST, url.id, form.canpost)>
		<cfset application.permission.setAllowed(application.rights.CANEDIT, url.id, form.canedit)>
		
		<cfset msg = "Conference, #conference.name#, has been updated.">
		<cflocation url="conferences.cfm?msg=#urlEncodedFormat(msg)#" addToken="false">
	</cfif>
</cfif>

<!--- get conference if not new --->
<cfif url.id neq "0">
	<cfset conference = application.conference.getConference(url.id)>
	<cfparam name="form.name" default="#conference.name#">
	<cfparam name="form.description" default="#conference.description#">
	<cfparam name="form.active" default="#conference.active#">
	<!--- get groups with can read --->
	<cfset canread = application.permission.getAllowed(application.rights.CANVIEW, url.id)>
	<!--- get groups with can post --->
	<cfset canpost = application.permission.getAllowed(application.rights.CANPOST, url.id)>
	<!--- get groups with can edit --->
	<cfset canedit = application.permission.getAllowed(application.rights.CANEDIT, url.id)>
<cfelse>
	<cfparam name="form.name" default="">
	<cfparam name="form.description" default="">
	<cfparam name="form.active" default="true">
	<cfset canread = queryNew("group")>
	<cfset canpost = queryNew("group")>
	<cfset canedit = queryNew("group")>
</cfif>

<!--- Security Related --->
<!--- get all groups --->
<cfset groups = application.user.getGroups()>

<cfmodule template="../tags/layout.cfm" templatename="admin" title="Conference Editor">

<cfoutput>
<form action="#cgi.script_name#?#cgi.query_string#" method="post">
<cfif isDefined("errors")><ul><b>#errors#</b></ul></cfif>

<div class="name_row">
<p class="left_100"></p>
</div>

<div class="row_0">
	<p class="input_name">Name</p>
	<input type="text" name="name" value="#form.name#" class="inputs_01">
	<div class="clearer"></div>
</div>
<div class="row_1">
	<p class="input_name">Description</p>
	<input type="text" name="description" value="#form.description#" class="inputs_01">
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
	<p class="input_name">Groups with Read Access</p>
		<select name="canread" multiple="true" size="4" class="inputs_02">
		<option value="" <cfif canread.recordCount is 0>selected</cfif>>Everyone</option>
		<cfloop query="groups">
		<option value="#id#" <cfif listFind(valueList(canread.group), id)>selected</cfif>>#group#</option>
		</cfloop>
		</select>
<div class="clearer"></div>
</div>

<div class="row_0">
	<p class="input_name">Groups with Post Access</p>
		<select name="canpost" multiple="true" size="4" class="inputs_02">
		<option value="" <cfif canpost.recordCount is 0>selected</cfif>>Everyone</option>
		<cfloop query="groups">
		<option value="#id#" <cfif listFind(valueList(canpost.group), id)>selected</cfif>>#group#</option>
		</cfloop>
		</select>
<div class="clearer"></div>
</div>

<div class="row_1">
	<p class="input_name">Groups with Edit Access</p>
	<select name="canedit" multiple="true" size="4" class="inputs_02">
		<option value="" <cfif canedit.recordCount is 0>selected</cfif>>Everyone</option>
		<cfloop query="groups">
		<option value="#id#" <cfif listFind(valueList(canedit.group), id)>selected</cfif>>#group#</option>
		</cfloop>
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