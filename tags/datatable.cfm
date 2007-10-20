<cfsetting enablecfoutputonly=true>
<!---
	Name         : datatable.cfm
	Author       : Raymond Camden 
	Created      : June 02, 2004
	Last Updated : February 26, 2007
	History      : JS fix (7/23/04)
				   Minor formatting updates (rkc 8/29/05)
				   finally add sorting (rkc 9/9/05)
				   mods for new stuff (rkc 11/3/06)
				   added linkappend (rkc 2/26/07)
	Purpose		 : A VERY app specific datable tag. 
--->

<cfparam name="attributes.data" type="query">
<cfparam name="attributes.linkcol" default="#listFirst(attributes.data.columnList)#">
<cfparam name="attributes.linkval" default="id">
<cfparam name="attributes.list" default="#attributes.data.columnList#">
<cfparam name="attributes.classlist" default="">
<cfparam name="url.page" default="1">
<cfparam name="url.sort" default="">
<cfparam name="url.dir" default="asc">
<cfparam name="attributes.linkappend" default="">
<cfparam name="attributes.message" default="">

<cfif url.dir is not "asc" and url.dir is not "desc">
	<cfset url.dir = "asc">
</cfif>

<cfif len(trim(url.sort)) and len(trim(url.dir))>
	<cfquery name="attributes.data" dbtype="query">
	select 	*
	from	attributes.data
	order by 	#url.sort# #url.dir#
	</cfquery>
</cfif>

<cfif not isNumeric(url.page) or url.page lte 0>
	<cfset url.page = 1>
</cfif>


<cfscript>
function displayHeader(col) { 
	if(col is "readonly") return "Read Only";
	if(col is "datecreated") return "Date Created";
	if(col is "messagecount") return "Posts";
	if(col is "lastpost") return "Last Post";
	if(col is "postcount") return "Number of Posts";
	if(col is "emailaddress") return "Email Address";
	if(col is "threadname") return "Thread";
	if(col is "sendnotifications") return "Send Notifications";
	if(col is "forumname") return "Forum";
	if(col is "conferencename") return "Conference";
	if(col is "minposts") return "Minimum Number of Posts";
	if(col is "lastpostcreated") return "Last Post";
	if(col is "messages") return "Msgs";
	else if(len(col) is 1) return uCase(col);
	else return ucase(left(col,1)) & right(col, len(col)-1);
}
</cfscript>

<cfoutput>
<script>
function checksubmit() {
	if(document.listing.mark.length == null) {
		if(document.listing.mark.checked) {
			document.listing.submit();
			return;
		}
	}

	for(i=0; i < document.listing.mark.length; i++) {
		if(document.listing.mark[i].checked) document.listing.submit();
	}
}
</script>

<cfif attributes.data.recordCount gt application.settings.perpage>
	<div class="records">
	[ #application.settings.perpage# of #attributes.data.recordCount# records ]
	[
	<cfif url.page gt 1>
		<a href="#cgi.script_name#?page=#url.page-1#&sort=#urlEncodedFormat(url.sort)#&dir=#url.dir##attributes.linkappend#">Previous</a>
	<cfelse>
		Previous
	</cfif>
	- 
	<cfif url.page * application.settings.perpage lt attributes.data.recordCount>
		<a href="#cgi.script_name#?page=#url.page+1#&sort=#urlEncodedFormat(url.sort)#&dir=#url.dir##attributes.linkappend#">Next</a>
	<cfelse>
		Next
	</cfif>
	]
	</div>
<cfelse>
	<div class="records">
	[ #attributes.data.recordCount# records ]
	</div>
</cfif>
<div class="clearer"></div>


<form name="listing" action="#cgi.script_name#?#attributes.linkappend#" method="post">
<div class="name_row">
	<p class="left_5">.</p>
		<cfloop index="x" from="1" to="#listLen(attributes.list)#">
			<cfset c = listGetAt(attributes.list, x)>
			<cfif url.sort is c and url.dir is "asc">
				<cfset dir = "desc">
			<cfelse>
				<cfset dir = "asc">
			</cfif>
			<cfif x lte listLen(attributes.classlist)>
				<cfset theclass = listGetAt(attributes.classlist, x)>
			<cfelse>
				<cfset theclass = "">
			</cfif>
			<p class="#theclass#">
			<!--- static rewrites of a few of the columns --->
			<a href="#cgi.script_name#?page=#url.page#&sort=#urlEncodedFormat(c)#&dir=#dir##attributes.linkappend#">#displayHeader(c)#</a>
			</p>
		</cfloop>
</div>
</cfoutput>
<cfif isDefined("url.msg")>
	<div class="clearer"></div>
	<cfoutput>
	<div class="secondary_row">
	<p class="left_100 align_center">#url.msg#</span></p>
	<div class="clearer"></div>
	</div>
	</cfoutput>
</cfif>
<cfif len(attributes.message)>
	<cfoutput>
	<div class="clearer"></div>
	<div class="secondary_row">
	<p class="left_100 align_center">#attributes.message#</span></p>
	<div class="clearer"></div>
	</div>
	</cfoutput>
</cfif>

<cfif attributes.data.recordCount>
	<cfoutput query="attributes.data" startrow="#(url.page-1)*application.settings.perpage + 1#" maxrows="#application.settings.perpage#">
		<cfset theLink = attributes.editlink & "?id=#id#">
		<cfif currentRow mod 2 is 1>
		<div class="row_0">
		<cfelse>
		<div class="row_1">
		</cfif>
		<p class="left_5"><input type="checkbox" name="mark" value="#attributes.data[attributes.linkval][currentRow]#"></p>
		<cfloop index="x" from="1" to="#listLen(attributes.list)#">
			<cfset c = listGetAt(attributes.list, x)>
			<cfset value = attributes.data[c][currentRow]>
			<cfif c is "readonly" or c is "active" or c is "sendnotifications" or c is "sticky" or c is "confirmed" or c is "attachments">
				<cfset value = yesNoFormat(value)>
			<cfelseif (c is "datecreated" or c is "posted" or c is "lastpostcreated") and len(value)>
				<cfset value = dateFormat(value,"mm/dd/yy") & " " & timeFormat(value,"h:mm tt")>
			</cfif>
			<cfif trim(value) is "">
				<cfset value = "&nbsp;">
			</cfif>
			<cfif x lte listLen(attributes.classlist)>
				<cfset theclass = listGetAt(attributes.classlist, x)>
			<cfelse>
				<cfset theclass = "">
			</cfif>
			<div class="#theclass#">
			<p class="right_pad">
			<cfif c is attributes.linkcol>
				<a href="#attributes.editlink#?id=#attributes.data[attributes.linkval][currentRow]#">#value#</a>
			<cfelse>
			#value#
			</cfif>
			</p>
			</div>
			</cfloop>
		<div class="clearer"></div>	
		</div>
	</cfoutput>
<cfelse>

</cfif>

<cfoutput>
</form>
<div class="bottom_options">
[<a href="#attributes.editlink#?id=0">Add #attributes.label#</a>] [<a href="javascript:checksubmit()">Delete Selected</a>]
</div>
</cfoutput>

<cfsetting enablecfoutputonly=false>

<cfexit method="EXITTAG">