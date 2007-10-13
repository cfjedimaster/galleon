<cfsetting enablecfoutputonly=true>
<!---
	Name         : search.cfm
	Author       : Raymond Camden 
	Created      : July 5, 2004
	Last Updated : October 12, 2007
	History      : Reset for V2
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

</cfif>

<cfoutput>
	
	<!-- Content Start -->
	<div class="content_box">
		
		<!-- Search Start -->
		<div class="row_title">
			<p>Search</p>
		</div>
		
		<div class="row_1 top_pad">
			<form action="#cgi.script_name#?#cgi.query_string#" method="post" class="search_forms">
				
			<p class="input_name">Search Terms:</p>
			<input type="text" name="searchterms" value="#form.searchterms#"  class="input_box" maxlength="100">
						
			<div class="clearer"><br /></div>
			
			<p class="input_name">Match:</p>
				<select name="searchtype" class="select_box">
					<option value="phrase" <cfif form.searchtype is "phrase">selected</cfif>>Phrase</option>
					<option value="any" <cfif form.searchtype is "any">selected</cfif>>Any Word</option>
					<option value="all" <cfif form.searchtype is "all">selected</cfif>>All Words</option>
				</select>	
						
			<div class="clearer"><br /></div>
			
			<input type="image" src="images/btn_search.gif" alt="Search" name="search" class="submit_btns">
			
			<div class="clearer"><br /></div>
			
			</form>
			
		</div>
		<cfif len(form.searchterms)>
		<div class="row_1 top_pad">
			<p>
				<b>Results in Conferences:</b><br>
				<cfif conferences.recordCount>
					<cfset didOne = false>
					<cfloop query="conferences">
						<cfif application.permission.allowed(application.rights.CANVIEW, id, request.udf.getGroups())>
							<a href="forums.cfm?conferenceid=#id#">#name#</a><br>
							<cfset didOne = true>
						</cfif>
					</cfloop>
					<cfif not didOne>
						No matches.
					</cfif>
				<cfelse>
				No matches.
				</cfif>
				</p>
				<p>
				<b>Results in Forums:</b><br>
				<cfif forums.recordCount>
					<cfset didOne = false>
					<cfloop query="forums">
						<cfif application.permission.allowed(application.rights.CANVIEW, id, request.udf.getGroups()) and
							application.permission.allowed(application.rights.CANVIEW, conferenceidfk, request.udf.getGroups())>
							<a href="threads.cfm?forumid=#id#">#name#</a><br>
							<cfset didOne = true>
						</cfif>
					</cfloop>
					<cfif not didOne>
						No matches.
					</cfif>
				<cfelse>
				No matches.
				</cfif>
				</p>
				<p>
				<b>Results in Threads:</b><br>
				<cfif threads.recordCount>
					<cfset didOne = false>
					<cfloop query="threads">
						<cfif application.permission.allowed(application.rights.CANVIEW, forumidfk, request.udf.getGroups()) and
							  application.permission.allowed(application.rights.CANVIEW, conferenceidfk, request.udf.getGroups())>
							<a href="messages.cfm?threadid=#id#">#name#</a><br>
							<cfset didOne = true>
						</cfif>
					</cfloop>
					<cfif not didOne>
						No matches.
					</cfif>
				<cfelse>
				No matches.
				</cfif>
				</p>
				<p>
				<b>Results in Messages:</b><br>
				<cfif messages.recordCount>
					<cfset didOne = false>
					<cfloop query="messages">
						<cfif application.permission.allowed(application.rights.CANVIEW, forumidfk, request.udf.getGroups()) and
							  application.permission.allowed(application.rights.CANVIEW, conferenceidfk, request.udf.getGroups())>
							<a href="messages.cfm?threadid=#threadidfk#">#title#</a><br>
							<cfset didOne = true>
						</cfif>
					</cfloop>
					<cfif not didOne>
						No matches.
					</cfif>
				<cfelse>
				No matches.
				</cfif>
				</p>
		</div>
		</cfif>
		<!-- Search Ender -->
	
	</div>
	<!-- Content End -->
	
<script>
window.onload = function() {document.getElementById("searchForm").searchterms.focus();}
</script>
</cfoutput>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>
