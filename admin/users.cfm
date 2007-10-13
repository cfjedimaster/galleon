<cfsetting enablecfoutputonly=true>
<!---
	Name         : users.cfm
	Author       : Raymond Camden 
	Created      : July 4, 2004
	Last Updated : October 12, 2007
	History      : Reset for V2
	Purpose		 : 
--->

<cfparam name="url.search" default="">
<cfparam name="form.search" default="#url.search#">

<cfmodule template="../tags/layout.cfm" templatename="admin" title="User Editor">

<!--- handle deletions --->
<cfif isDefined("form.mark") and len(form.mark)>
	<cfloop index="id" list="#form.mark#">
		<cfset application.user.deleteUser(id)>
	</cfloop>
	<cfoutput>
	<p>
	<b>User(s) deleted.</b>
	</p>
	</cfoutput>
</cfif>

<!--- get users --->
<cfset users = application.user.getUsers()>

<cfif len(trim(form.search))>
	<cfquery name="users" dbtype="query">
	select	*
	from	users
	where	lower(username) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#lcase(form.search)#%"> 
	or		lower(emailaddress) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#lcase(form.search)#%">
	</cfquery>
</cfif>

<cfif application.settings.requireconfirmation>
	<cfset list = "username,emailaddress,postcount,confirmed,datecreated">
<cfelse>
	<cfset list = "username,emailaddress,postcount,datecreated">
</cfif>
<div id="right">
<cfoutput>
<div class="top_input_misc">
<form action="#cgi.script_name#?#cgi.query_string#" method="post">
<input type="text" name="search" value="#form.search#" class="filter_input"> <input type="image" src="../images/btn_filter.jpg" value="Filter" class="filter_btn">
</form>
</div>
</cfoutput>

<cfmodule template="../tags/datatable.cfm" 
		  data="#users#" list="#list#" 
		  classList="left_20,left_25,left_20 align_center,left_15 align_center,left_15"
		  editlink="users_edit.cfm" linkcol="username" linkval="username" label="User" linkappend="&search=#form.search#" />


</cfmodule>
</div>

<cfsetting enablecfoutputonly=false>