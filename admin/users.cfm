<cfsetting enablecfoutputonly=true>
<!---
	Name         : users.cfm
	Author       : Raymond Camden 
	Created      : July 4, 2004
	Last Updated : July 12, 2006
	History      : Fixed bugs related to sendnotifications change (rkc 8/3/05)
				   Removed mappings (rkc 8/27/05)
				   Handle requireconfirmation (rkc 7/12/06)
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

<cfoutput>
<p>
<form action="#cgi.script_name#?#cgi.query_string#" method="post">
<input type="text" name="search" value="#form.search#"> <input type="submit" value="Filter">
</form>
</p>
</cfoutput>

<cfmodule template="../tags/datatable.cfm" 
		  data="#users#" list="#list#" 
		  editlink="users_edit.cfm" linkcol="username" linkval="username" label="User" linkappend="&search=#form.search#" />


</cfmodule>

<cfsetting enablecfoutputonly=false>