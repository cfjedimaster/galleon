<cfsetting enablecfoutputonly=true>
<!---
	Name         : index.cfm
	Author       : Raymond Camden 
	Created      : June 01, 2004
	Last Updated : April 8, 2005
	History      : Just update the version number and last update.
				   No more version # - tired of updating it. (rkc 4/8/05)
	Purpose		 : 
--->

<cfmodule template="../tags/layout.cfm" templatename="admin" title="Welcome to the Galleon Administrator">

<cfoutput>
<p>
Welcome to Galleon ColdFusion Forums. This administrator allows you to edit all aspects of your forums. 
Please select an option from the left hand menu to begin. Please send any bug reports 
to <a href="mailto:ray@camdenfamily.com">Raymond Camden</a>.
</p>

<p>
<h2>Version</h2>
You are currently running version #application.settings.version#.
</p>
</cfoutput>

<cfinclude template="gen_stats.cfm">

</cfmodule>

<cfsetting enablecfoutputonly=false>