<cfsetting enablecfoutputonly=true>
<!---
	Name         : users.cfm
	Author       : Raymond Camden 
	Created      : July 4, 2004
	Last Updated : December 13, 2007
	History      : Reset for V2
				   Fixed filtering code (rkc 12/13/07)
	Purpose		 : 
--->

<cfparam name="url.search" default="">
<cfparam name="form.search" default="#url.search#">
<cfparam name="url.start" default="1">
<cfparam name="url.sort" default="username">
<cfparam name="url.dir" default="asc">

<cfmodule template="../tags/layout.cfm" templatename="admin" title="User Editor">

<!--- handle deletions --->
<cfif isDefined("form.mark") and len(form.mark)>
	<cfloop index="id" list="#form.mark#">
		<cfset application.user.deleteUser(id)>
	</cfloop>
	<cfset url.msg = "User(s) deleted.">
</cfif>

<!--- get users --->
<cfset users = application.user.getUsers(search=form.search,start=url.start, sort="#url.sort# #url.dir#", max=10)>


<cfif application.settings.requireconfirmation>
	<cfset list = "username,emailaddress,postcount,confirmed,datecreated">
<cfelse>
	<cfset list = "username,emailaddress,postcount,datecreated">
</cfif>
<div id="right">
<cfoutput>
<div class="top_input_misc">
	<cfset qs = cgi.query_string>
	<cfset qs = rereplace(qs, "&*page=[0-9]+", "")>
<form action="#cgi.script_name#?#qs#" method="post">
<input type="text" name="search" value="#form.search#" class="filter_input"> <input type="image" src="../images/btn_filter.jpg" value="Filter" class="filter_btn">
</form>
</div>
</cfoutput>

<cfmodule template="../tags/datatablenew.cfm" 
		  data="#users.data#" list="#list#" 
  		  total="#users.total#" perpage=10 start="#url.start#"
		  nosort="postcount"
		  
		  classList="left_20,left_25,left_20 align_center,left_15 align_center,left_15"
		  editlink="users_edit.cfm" linkcol="username" linkval="username" label="User" linkappend="&search=#urlEncodedFormat(form.search)#" />


</cfmodule>
</div>

<cfsetting enablecfoutputonly=false>