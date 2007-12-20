<cfsetting enablecfoutputonly=true>
<!---
	Name         : messages.cfm
	Author       : Raymond Camden 
	Created      : July 5, 2004
	Last Updated : December 13, 2007
	History      : Reset for V2
				   Fixed filtering code (rkc 12/13/07)
	Purpose		 : 
--->

<cfparam name="url.search" default="">
<cfparam name="form.search" default="#url.search#">

<cfmodule template="../tags/layout.cfm" templatename="admin" title="Message Editor">

<!--- handle deletions --->
<cfif isDefined("form.mark") and len(form.mark)>
	<cfloop index="id" list="#form.mark#">
		<cfset application.message.deleteMessage(id)>
	</cfloop>
	<cfset url.msg = "Message(s) deleted.">
</cfif>

<!--- get messages --->
<cfset messages = application.message.getMessages()>

<cfif len(trim(form.search))>
	<cfquery name="messages" dbtype="query">
	select	*
	from	messages
	where	lower(title) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#lcase(form.search)#%"> 
	</cfquery>
</cfif>

<cfoutput>
<div class="top_input_misc">
	<cfset qs = cgi.query_string>
	<cfset qs = rereplace(qs, "&*page=[0-9]+", "")>
<form action="#cgi.script_name#?#qs#" method="post">
<input type="text" name="search" value="#form.search#" class="filter_input"> <input type="image" src="../images/btn_filter.jpg" value="Filter" class="filter_btn">
</form>
</div>
</cfoutput>

<cfmodule template="../tags/datatable.cfm" 
		  data="#messages#" list="title,posted,threadname,forumname,conferencename,username"
		  classList="left_20,left_15,left_20,left_15,left_15,left_10" 
		  editlink="messages_edit.cfm" linkcol="title" label="Message" linkappend="&search=#urlEncodedFormat(form.search)#" />


</cfmodule>

<cfsetting enablecfoutputonly=false>