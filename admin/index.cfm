<cfsetting enablecfoutputonly=true>
<!---
	Name         : index.cfm
	Author       : Raymond Camden 
	Created      : June 01, 2004
	Last Updated : April 8, 2005
	Last Updated : October 12, 2007
	History      : Reset for V2
	Purpose		 : 
--->

<cfmodule template="../tags/layout.cfm" templatename="admin" title="Welcome to the Galleon Administrator">

<cfinclude template="gen_stats.cfm">

<cfoutput>

	<p>
	Welcome to Galleon ColdFusion Forums. This administrator allows you to edit all aspects of your forums. Please select an option from the left hand menu to begin.
	Please send any bug reports to the <a href="http://galleon.riaforge.org">Galleon project page</a>.</p>	

	<p><span class="titles_small">Version : </span>You are currently running version #application.settings.version#.</p>
				
	<div class="clearer"></div>

</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly=false>