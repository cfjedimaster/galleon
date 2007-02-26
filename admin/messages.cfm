<cfsetting enablecfoutputonly=true>
<!---
	Name         : messages.cfm
	Author       : Raymond Camden 
	Created      : July 5, 2004
	Last Updated : February 26, 2007
	History      : Removed mappings (rkc 8/27/05)
				   Changed cols (rkc 9/9/05)
				   added filtering (rkc 2/26/07)
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
	<cfoutput>
	<p>
	<b>Message(s) deleted.</b>
	</p>
	</cfoutput>
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
<p>
<form action="#cgi.script_name#?#cgi.query_string#" method="post">
<input type="text" name="search" value="#form.search#"> <input type="submit" value="Filter">
</form>
</p>
</cfoutput>

<cfmodule template="../tags/datatable.cfm" 
		  data="#messages#" list="title,posted,threadname,forumname,conferencename,username" 
		  editlink="messages_edit.cfm" linkcol="title" label="Message" />


</cfmodule>

<cfsetting enablecfoutputonly=false>