<cfsetting requesttimeout="600">
<cfset dsn = "galleon_test">
<cfset tprefix = "">

<!--- get all messages --->
<cfquery name="msgs" datasource="#dsn#">
select	*
from	#tprefix#messages
order by posted asc
</cfquery>

<cfoutput>
<p>
Total ## of messages: #msgs.recordCount#
</p>
</cfoutput>
<cfflush>

<!--- set up messages column to be 0 --->
<cfquery datasource="#dsn#">
update	#tprefix#conferences
set		messages = 0
</cfquery>
<cfquery datasource="#dsn#">
update	#tprefix#forums
set		messages = 0
</cfquery>
<cfquery datasource="#dsn#">
update	#tprefix#threads
set		messages = 0
</cfquery>

<!--- 
	Now loop over the messages.
--->

<cfloop query="msgs">
	<!--- Update threads --->
	<!--- This is a bit sloppy - I'm setting lastpost for every one, but it's simpler --->
	<cfquery datasource="#dsn#">
	update #tprefix#threads
	set		messages = messages + 1,
			lastpostuseridfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#useridfk#">,
			lastpostcreated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#posted#">
	where	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#threadidfk#">
	</cfquery>
	
	<!--- get the thread so I can get the forum --->
	<cfquery name="getthread" datasource="#dsn#">
	select	forumidfk
	from	#tprefix#threads
	where	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#threadidfk#">
	</cfquery>
	
	<cfset forumid = getthread.forumidfk>

	<!--- Update forums --->
	<!--- This is a bit sloppy - I'm setting lastpost for every one, but it's simpler --->
	<cfquery datasource="#dsn#">
	update #tprefix#forums
	set		messages = messages + 1,
			lastpostuseridfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#useridfk#">,
			lastpost = <cfqueryparam cfsqltype="cf_sql_varchar" value="#id#">,
			lastpostcreated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#posted#">
	where	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#forumid#">
	</cfquery>

	<!--- get the forum so I can get the conference --->
	<cfquery name="getforum" datasource="#dsn#">
	select	conferenceidfk
	from	#tprefix#forums
	where	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#forumid#">
	</cfquery>
	
	<cfset conferenceid = getforum.conferenceidfk>
	
	<!--- Update conferences --->
	<!--- This is a bit sloppy - I'm setting lastpost for every one, but it's simpler --->
	<cfquery datasource="#dsn#">
	update #tprefix#conferences
	set		messages = messages + 1,
			lastpostuseridfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#useridfk#">,
			lastpost = <cfqueryparam cfsqltype="cf_sql_varchar" value="#id#">,
			lastpostcreated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#posted#">
	where	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#conferenceid#">
	</cfquery>

	<cfif currentRow mod 1000 is 0>
		<cfoutput>
		1000 rows done.<br />
		</cfoutput>
		<cfflush>
	</cfif>
	
</cfloop>

<cfoutput>
<p>
Done updating.
</p>
</cfoutput>