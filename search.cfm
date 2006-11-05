<cfsetting enablecfoutputonly=true>
<!---
	Name         : search.cfm
	Author       : Raymond Camden 
	Created      : July 5, 2004
	Last Updated : September 6, 2006
	History      : Add search log
				   Removed mappings (rkc 8/27/05)
				   Limit search length (rkc 10/30/05)
				   auto focus on search box (rkc 7/12/06)
				   title fix (rkc 8/4/06)
				   js fix by imtiyaz (rkc 9/6/06)
	Purpose		 : Displays form to search.
--->

<cfparam name="form.searchterms" default="">
<cfset form.searchterms = trim(htmlEditFormat(application.utils.searchSafe(form.searchterms)))>
<cfparam name="form.searchtype" default="phrase">

<!--- Loads header --->
<cfmodule template="tags/layout.cfm" templatename="main" title="#application.settings.title# : Search">

<!--- Handle attempted search --->
<cfif len(form.searchterms)>

	<cfif not listFindNoCase("phrase,any,all", form.searchtype)>
		<cfset form.searchtype = "phrase">
	</cfif>
		 
	<!--- 
		search multiple items:
			conferences (name/desc)
			forums (name/desc)
			threads (name)
			messages (title/body)
	--->
	
	<cfset conferences = application.conference.search(form.searchterms, form.searchtype)>
	<cfset forums = application.forum.search(form.searchterms, form.searchtype)>
	<cfset threads = application.thread.search(form.searchterms, form.searchtype)>
	<cfset messages = application.message.search(form.searchterms, form.searchtype)>
	
	<cfset application.utils.logSearch(form.searchTerms, application.settings.dsn, application.settings.tableprefix)>
	<cfset totalResults = conferences.recordCount + forums.recordCount + threads.recordCount + messages.recordCount>
	
</cfif>

<cfoutput>
<p>
<table width="500" cellpadding="6" class="tableDisplay" cellspacing="1" border="0">
	<tr class="tableHeader">
		<td class="tableHeader">Search</td>
	</tr>
	<tr class="tableRowMain">
		<td>
		<form action="#cgi.script_name#?#cgi.query_string#" method="post" id="searchForm">
		<table>
			<tr>
				<td><b>Search Terms:</b></td>
				<td><input type="text" name="searchterms" value="#form.searchterms#" class="formBox" maxlength="100"></td>
			</tr>
			<tr>
				<td><b>Match:</b></td>
				<td>
				<select name="searchtype" class="formDropDown">
					<option value="phrase" <cfif form.searchtype is "phrase">selected</cfif>>Phrase</option>
					<option value="any" <cfif form.searchtype is "any">selected</cfif>>Any Word</option>
					<option value="all" <cfif form.searchtype is "all">selected</cfif>>All Words</option>
				</select>	
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td align="right"><input type="image" src="images/btn_search.gif" alt="Search" width="59" height="19"></td>
			</tr>
		</table>
		</form>
		</td>
	</tr>
	<cfif isDefined("variables.totalResults")>
		<tr class="tableRowMain">
			<td>
				<p>
				<b>Results in Conferences:</b><br>
				<cfif conferences.recordCount>
					<cfloop query="conferences">
					<a href="forums.cfm?conferenceid=#id#">#name#</a><br>
					</cfloop>
				<cfelse>
				No matches.
				</cfif>
				</p>
				<p>
				<b>Results in Forums:</b><br>
				<cfif forums.recordCount>
					<cfloop query="forums">
					<a href="threads.cfm?forumid=#id#">#name#</a><br>
					</cfloop>
				<cfelse>
				No matches.
				</cfif>
				</p>
				<p>
				<b>Results in Threads:</b><br>
				<cfif threads.recordCount>
					<cfloop query="threads">
					<a href="messages.cfm?threadid=#id#">#name#</a><br>
					</cfloop>
				<cfelse>
				No matches.
				</cfif>
				</p>
				<p>
				<b>Results in Messages:</b><br>
				<cfif messages.recordCount>
					<cfloop query="messages">
					<a href="messages.cfm?threadid=#threadidfk#">#title#</a><br>
					</cfloop>
				<cfelse>
				No matches.
				</cfif>
				</p>

			</td>
		</tr>
	</cfif>
</table>
</p>
<script>
window.onload = function() {document.getElementById("searchForm").searchterms.focus();}
</script>
</cfoutput>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>
