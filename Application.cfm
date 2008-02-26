<cfsetting enablecfoutputonly="true" showdebugoutput="false">
<!---
	Name         : Application.cfm
	Author       : Raymond Camden 
	Created      : June 01, 2004
	Last Updated : October 29, 2007
	History      : Reset for V2
				 : Fix for IE login issue (rkc 10/15/07)
				 : Remove BlueDragon mod (not needed in latest BD, thanks to Vince B for letting me know!) (rkc 10/29/07)
	Purpose		 : 
--->

<cfset appName = "galleonForums">
<cfset prefix = getCurrentTemplatePath()>
<cfset prefix = reReplace(prefix, "[^a-zA-Z]","","all")>
<cfset prefix = right(prefix, 64 - len(appName))>

<cfapplication name="#prefix##appName#" sessionManagement=true loginstorage="session">

<cferror type="exception" template="error.cfm">

<cfif not isDefined("application.init") or isDefined("url.reinit")>

	<cfset structDelete(application, "userCache")>

	<cfset settings = structNew()>
	<cfset settings.attachmentdir = getDirectoryFromPath(getCurrentTemplatePath()) & "attachments">
	<cfset settings.avatardir = getDirectoryFromPath(getCurrentTemplatePath()) & "images/avatars">

	<!--- get user CFC --->
	<cfset application.factory = createObject("component","cfcs.objectfactory").init(settings)>
	
	<!--- Get main settings --->
	<cfset application.settings = application.factory.get('galleonSettings').getSettings()>

	<cfif not directoryExists(application.settings.attachmentdir)>
		<cfdirectory action="create" directory="#application.settings.attachmentdir#">
	</cfif>
	<cfif not directoryExists(application.settings.avatardir)>
		<cfdirectory action="create" directory="#application.settings.avatardir#">
	</cfif>
	
	<!--- get user CFC --->
	<cfset application.user = application.factory.get('user')>

	<!--- get utils CFC --->
	<cfset application.utils = application.factory.get('utils')>
		
	<!--- get conference CFC --->
	<cfset application.conference = application.factory.get('conference')>
	
	<!--- get forum CFC --->
	<cfset application.forum = application.factory.get('forum')>

	<!--- get thread CFC --->
	<cfset application.thread = application.factory.get('thread')>

	<!--- get message CFC --->
	<cfset application.message = application.factory.get('message')>

	<!--- get rank CFC --->
	<cfset application.rank = application.factory.get('rank')>

	<!--- get security CFC --->
	<cfset application.permission = application.factory.get('permission')>
	
	<!--- hard coded rights for now --->
	<cfset application.rights.CANVIEW = "7EA5070B-9774-E11E-96E727122408C03C">
	<cfset application.rights.CANPOST = "7EA5070C-E788-7378-8930FA15EF58BBD2">
	<cfset application.rights.CANEDIT = "7EA5070D-CB58-72BA-2E4A3DFC0AE35F35">

	<!--- get image CFC if we need it --->
	<cfif application.settings.allowavatars>
		<cfset application.image = application.factory.get('image')>
		<cfset application.image.setOption("throwonerror", false)>
	</cfif>
	
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
	<cfif isDefined("form.logon") or isDefined("form.logon.x")>
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
		<cfparam name="url.sort" default="lastpostcreated">
		<cfparam name="url.sortdir" default="desc">
	<cfelse>
		<cfparam name="url.sort" default="name">
		<cfparam name="url.sortdir" default="asc">
	</cfif>
</cfif>

<cfsetting enablecfoutputonly=false>