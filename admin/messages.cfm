<cfsetting enablecfoutputonly=true>
<!---
	Name         : messages.cfm
	Author       : Raymond Camden 
	Created      : July 5, 2004
	Last Updated : September 9, 2005
	History      : Removed mappings (rkc 8/27/05)
				   Changed cols (rkc 9/9/05)
	Purpose		 : 
--->

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

<cfmodule template="../tags/datatable.cfm" 
		  data="#messages#" list="title,posted,threadname,forumname,conferencename,username" 
		  editlink="messages_edit.cfm" linkcol="title" label="Message" />


</cfmodule>

<cfsetting enablecfoutputonly=false>