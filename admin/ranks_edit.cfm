<cfsetting enablecfoutputonly=true>
<!---
	Name         : ranks_edit.cfm
	Author       : Raymond Camden 
	Created      : August 28, 2005
	Last Updated : 
	History      : 
	Purpose		 : 
--->

<cfif isDefined("form.cancel") or not isDefined("url.id") or not len(url.id)>
	<cflocation url="ranks.cfm" addToken="false">
</cfif>

<cfif isDefined("form.save")>
	<cfset errors = "">
	<cfif not len(trim(form.name))>
		<cfset errors = errors & "You must specify a name.<br>">
	</cfif>
	<cfif not len(trim(form.minposts)) or not isNumeric(form.minposts) or form.minposts lt 0>
		<cfset errors = errors & "You must specify a numeric value greater than zero for the minimum number of posts.<br>">
	</cfif>
	<cfif not len(errors)>
		<cfset rank = structNew()>
		<cfset rank.name = trim(htmlEditFormat(form.name))>
		<cfset rank.minposts = trim(htmlEditFormat(form.minposts))>
		<cfif url.id neq 0>
			<cfset application.rank.saveRank(url.id, rank)>
		<cfelse>
			<cfset application.rank.addRank(rank)>
		</cfif>
		<cfset msg = "Rank, #rank.name#, has been updated.">
		<cflocation url="ranks.cfm?msg=#urlEncodedFormat(msg)#" addToken="false">
	</cfif>
</cfif>

<!--- get conference if not new --->
<cfif url.id neq "0">
	<cfset rank = application.rank.getRank(url.id)>
	<cfparam name="form.name" default="#rank.name#">
	<cfparam name="form.minposts" default="#rank.minposts#">
<cfelse>
	<cfparam name="form.name" default="">
	<cfparam name="form.minposts" default="">
</cfif>

<cfmodule template="../tags/layout.cfm" templatename="admin" title="Rank Editor">

<cfoutput>
<form action="#cgi.script_name#?#cgi.query_string#" method="post">
<cfif isDefined("errors")><ul><b>#errors#</b></ul></cfif>
	
<div class="name_row">
<p class="left_100"></p>
</div>

<div class="row_0">
	<p class="input_name">Name</p>
	<input type="text" name="name" value="#form.name#" class="inputs_01">
	<div class="clearer"></div>
</div>

<div class="row_1">
	<p class="input_name">Minimum Number of Posts</p>
	<input type="text" name="minposts" value="#form.minposts#" class="inputs_01">
	<div class="clearer"></div>
</div>

<div id="input_btns">	
	<input type="image" src="../images/btn_save.jpg"  name="save" value="Save">
	<input type="image" src="../images/btn_cancel.jpg" type="submit" name="cancel" value="Cancel">
</div>
</form>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly=false>