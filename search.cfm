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
	
	<!---
	<cfset conferences = application.conference.search(form.searchterms, form.searchtype)>
	<cfset forums = application.forum.search(form.searchterms, form.searchtype)>
	<cfset threads = application.thread.search(form.searchterms, form.searchtype)>
	--->
	<cfset messages = application.message.search(form.searchterms, form.searchtype)>
	
	<cfset application.utils.logSearch(form.searchTerms, application.settings.dsn, application.settings.tableprefix)>

	<!--- get my conferences --->
	<cfset data = application.conference.getConferences()>
	<!--- filter by what I can read... --->
	<cfset data = application.permission.filter(query=data, groups=request.udf.getGroups(), right=application.rights.CANVIEW)>

	<cfif data.recordCount is 1>
		<cfset showConferences = false>
	<cfelse>
		<cfset showConferences = true>
	</cfif>
	
</cfif>

<cfoutput>
	
	<style>
	table.searchMessages {
		width: 100%;
		border-width: 1px;
		border-spacing: 0px;
		border-style: solid;
		border-collapse: separate;
	}
	table.searchMessages th {
		border-width: 1px;
		padding: 1px;
		border-style: solid;
		border-color: black;
		-moz-border-radius: ;
	}
	table.searchMessages td {
		border-width: 1px;
		padding: 1px;
		border-style: inset;
		border-color: black;
		-moz-border-radius: ;
	}
	tr.cfHeader td {
		font-weight: bold;
		font-size: 12px;
		padding: 10px;
	}
	</style>
	
	<!-- Content Start -->
	<div class="content_box">
		
		<!-- Search Start -->
		<div class="row_title">
			<p>Search</p>
		</div>
		
		<div class="row_1 top_pad">
			<form action="#cgi.script_name#?#cgi.query_string#" method="post" class="search_forms" id="searchForm">
				
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


				<p>
				<cfif messages.recordCount>
					<cfset lastConf = "">
					<cfset lastForum = "">
					<cfset didOne = false>
					<cfloop query="messages">
						<cfif application.permission.allowed(application.rights.CANVIEW, forumidfk, request.udf.getGroups()) and
							  application.permission.allowed(application.rights.CANVIEW, conferenceidfk, request.udf.getGroups())>
							<cfif not didOne>
							<div style="padding: 5px">
							<table class="searchMessages">
							</cfif>
							<cfif conference neq lastConf or forum neq lastForum>
								<tr class="cfHeader">
									<td colspan="2"><cfif showConferences>#conference# / </cfif>#forum#</td>
								</tr>
								<cfset lastConf = conference>
								<cfset lastForum = forum>
							</cfif>
							<tr>
								<td>#thread#</td>
								<td><a href="messages.cfm?threadid=#threadidfk#&mid=#id#">#title#</a></td>
							</tr>
							<cfset didOne = true>
						</cfif>
					</cfloop>
					<cfif didOne>
						</div>
						</table>
					</cfif>
					<cfif not didOne>
						Sorry, but there were no matches.
					</cfif>
				<cfelse>
					Sorry, but there were no matches.
				</cfif>
				</p>

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
