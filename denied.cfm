<cfsetting enablecfoutputonly=true>
<!---
	Name         : denied.cfm
	Author       : Raymond Camden 
	Created      : August 25, 2007
	Last Updated : 
	History      : 
	Purpose		 : The "You can't touch this" page.
--->

<!--- Loads header --->
<cfmodule template="tags/layout.cfm" templatename="main" title="#application.settings.title# : Permission Denied">


<cfoutput>
<p>
Sorry, but you do not have permissions to view this page.
</p>
</cfoutput>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>
