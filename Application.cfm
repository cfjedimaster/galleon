<cfsetting enablecfoutputonly="true" showdebugoutput="false">
<!---
	Name         : Application.cfm
	Author       : Raymond Camden 
	Created      : June 01, 2004
	Last Updated : November 16, 2006
	History      : Don't load app.cfc, load galleon.cfc. Also pass settings to messages. (rkc 7/14/05)
				   Make app name dynamic. Remove mapping (rkc 8/27/05)
				   Support for sorting, errors (rkc 9/15/05)
				   Better admin check, logout fix (rkc 7/12/06)
				   Even better admin check, really (rkc 7/18/06)
				   BD fix, attachment folder (rkc 11/3/06)
				   Fix for getting attachment dir (rkc 11/16/06)
	Purpose		 : 
--->

<cfset appName = "galleonForums">
<cfset prefix = getCurrentTemplatePath()>
<cfset prefix = reReplace(prefix, "[^a-zA-Z]","","all")>
<cfset prefix = right(prefix, 64 - len(appName))>

<cfapplication name="#prefix##appName#" sessionManagement=true loginstorage="session">

<!---
BD wants error.cfm to be relative when the app.cfm is run inside the admin
folder. See: http://ray.camdenfamily.com/index.cfm/2005/9/21/Galleon-Issue-with-BlueDragon
--->
<cfif server.coldfusion.productname is "BlueDragon">
	<cfif findNoCase("/admin", cgi.script_name)>
	   <cferror type="exception" template="../error.cfm">
	<cfelse>
	   <cferror type="exception" template="error.cfm">
	</cfif>
<cfelse>
	<cferror type="exception" template="error.cfm">
</cfif>

<cfif not isDefined("application.init") or isDefined("url.reinit")>

	<cfset structDelete(application, "userCache")>
	
	<!--- Get main settings --->
	<cfinvoke component="cfcs.galleon" method="getSettings" returnVariable="settings">
	<cfset application.settings = settings>

	<cfset application.settings.attachmentdir = getDirectoryFromPath(getCurrentTemplatePath()) & "attachments">

	<cfif not directoryExists(application.settings.attachmentdir)>
		<cfdirectory action="create" directory="#application.settings.attachmentdir#">
	</cfif>
	
	<!--- get user CFC --->
	<cfset application.user = createObject("component","cfcs.user").init(application.settings)>

	<!--- get utils CFC --->
	<cfset application.utils = createObject("component","cfcs.utils")>
		
	<!--- get conference CFC --->
	<cfset application.conference = createObject("component","cfcs.conference").init(application.settings)>
	
	<!--- get forum CFC --->
	<cfset application.forum = createObject("component","cfcs.forum").init(application.settings)>

	<!--- get thread CFC --->
	<cfset application.thread = createObject("component","cfcs.thread").init(application.settings)>

	<!--- get message CFC --->
	<cfset application.message = createObject("component","cfcs.message").init(application.settings)>

	<!--- get rank CFC --->
	<cfset application.rank = createObject("component","cfcs.rank").init(application.settings)>

	<cfset application.init = true>
	
</cfif>

<!--- include UDFs --->
<cfinclude template="includes/udf.cfm">

<cfif isDefined("url.logout")>
	<cfset structDelete(session, "user")>
	<cflogout>
</cfif>

<!--- handle security --->
<cflogin>

	<!--- are we trying to logon? --->
	<cfif isDefined("form.logon")>
		<cfif isDefined("form.username") and isDefined("form.password")>
			<cfif application.user.authenticate(trim(form.username), trim(form.password))>
				<!--- good logon, grab their groups --->
				<cfset mygroups = application.user.getGroupsForUser(trim(form.username))>
				<cfset session.user = application.user.getUser(trim(form.username))>		
				<cfloginuser name="#trim(form.username)#" password="#trim(form.password)#" roles="#mygroups#">
			</cfif>
		</cfif>
	</cfif>
	
</cflogin>

<!--- Used by index, forums, and threads ---->
<!--- however, if threads, default to lastpost --->
<!--- however, don't do this in the admin ;) --->
<cfif not structKeyExists(variables, "isAdmin")>
	<cfif findNoCase("threads.cfm", cgi.script_name)>
		<cfparam name="url.sort" default="lastpost">
		<cfparam name="url.sortdir" default="desc">
	<cfelse>
		<cfparam name="url.sort" default="name">
		<cfparam name="url.sortdir" default="asc">
	</cfif>
</cfif>


<cfsetting enablecfoutputonly=false>