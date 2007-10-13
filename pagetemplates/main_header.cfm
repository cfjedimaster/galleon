<cfsetting enablecfoutputonly=true>
<!---
	Name         : main_header.cfm
	Author       : Raymond Camden 
	Created      : June 02, 2004
	Last Updated : October 12, 2007
	History      : Reset for V2
	Purpose		 : 
--->

<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-US" lang="en-US">
<head>
	<title>#attributes.title#</title>
	<!--- Temporary hack - will be removed later. --->
	<link rel="stylesheet" type="text/css" href="stylesheets/style.css" />
	<meta name="description" content="#attributes.title#" />
	<meta name="keywords" content="#replace(attributes.title," : ", ",","all")#" /> 
   	<cfif isDefined("request.conference") and application.permission.allowed(application.rights.CANVIEW, request.conference.id, "")>
    <link rel="alternate" type="application/rss+xml" title="#request.conference.name# RSS" href="#application.settings.rooturl#rss.cfm?conferenceid=#request.conference.id#" />
    </cfif>
</head>

<body>


<div id="container">

	<!-- Header Start -->
	<div id="header">
	
		<p class="logo"><a href="index.cfm">#application.settings.title#</a></p>
		<!--- <img src="images/Galleon.gif" alt="Galleon" class="logo"/> --->
		
		<div class="top_menu">
			<a href="index.cfm">Home</a> | 
			<a href="profile.cfm">Profile</a> | 
			<a href="search.cfm">Search</a>
			<cfset thisPage = cgi.script_name & "?" & reReplace(cgi.query_string,"logout=1","")>
			<cfif not isDefined("url.ref")>
				<cfset link = "login.cfm?ref=#urlEncodedFormat(thisPage)#">
			<cfelse>
				<cfset link = "login.cfm?ref=#urlEncodedFormat(ref)#">
			</cfif>		
			<cfif request.udf.isLoggedOn()>
				|  <a href="index.cfm?logout=1">Logout</a><cfelse><a href="#link#">Login</a>
			</cfif>
			<cfif isDefined("request.conference") and application.permission.allowed(application.rights.CANVIEW, request.conference.id, "")> 
				|  <a href="rss.cfm?conferenceid=#request.conference.id#">RSS</a>
			</cfif> 
		</div>
		
	</div>
</cfoutput>

<cfmodule template="../tags/breadcrumbs.cfm" />

<cfsetting enablecfoutputonly=false>

