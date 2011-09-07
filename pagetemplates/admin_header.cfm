<cfsetting enablecfoutputonly=true>
<!---
	Name         : admin_header.cfm
	Author       : Raymond Camden 
	Created      : June 02, 2004
	Last Updated : October 12, 2007
	History      : Reset for V2
	Purpose		 : 
--->

<cfscript>
function navon(s) {
	var l = "";
	var i = "";
	for(i=1; i lte listLen(s);i=i+1) { 
		l = listGetAt(s, i);
		if(find(l,cgi.script_name)) return "nav_on";
	}
	return "navs";
}
</cfscript>

<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-US" lang="en-US">
<head>
	<title>#attributes.title#</title>
	<meta name="author" content="" />
	<meta name="copyright" content="" />
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<link rel="shortcut icon" href="../images/favicon.ico" type="image/x-icon" />
	<link rel="stylesheet" type="text/css" href="../stylesheets/admin_style.css" />
</head> 

<body>

	<div id="header">
		<div class="middle_man"><a href="index.cfm"><img src="../images/glogo2.jpg" alt="Galleon Forums" class="logo"/></a></div>
	</div>

	<div id="white_container">
	<div class="middle_man">
	
	<cfif request.udf.isLoggedOn()>
		<div id="left">
		<div class="nav_title">Forum Options</div>
		<a href="conferences.cfm" name="Conferences" class="#navOn('conferences.cfm,conferences_edit.cfm')#">Conferences</a>
		<a href="forums.cfm" name="Forums" class="#navOn('forums.cfm,forums_edit.cfm')#">Forums</a>
		<a href="threads.cfm" name="Threads" class="#navOn('threads.cfm,threads_edit.cfm')#">Threads</a>

		<a href="messages.cfm" name="Messages" class="#navOn('messages.cfm,messages_edit.cfm')#">Messages</a>
		<a href="ranks.cfm" name="Ranks" class="#navOn('ranks.cfm,ranks_edit.cfm')#">Ranks</a>
		<a href="settings.cfm" name="Galleon Settings" class="#navOn('settings.cfm')#">Galleon Settings</a>
		<a href="reset_stats.cfm" name="Reset Stats" class="#navOn('reset_stats.cfm')#">Reset Stats</a>
				
		<div class="nav_breaker"></div>
		
		<div class="nav_title">Security Options</div>
		<a href="groups.cfm" name="Group Editor" class="#navOn('groups.cfm,groups_edit.cfm')#">Group Editor</a>
		<a href="users.cfm" name="User Editor" class="#navOn('users.cfm,users_edit.cfm')#">User Editor</a>
		
		<div class="nav_breaker"></div>
		
		<div class="nav_title">Stats</div>
		<!---<a href="stats.cfm" name="General Reporting" class="#navOn('/stats.cfm')#">General Reporting</a>--->
		<a href="search_stats.cfm" name="Search Reporting" class="#navOn('search_stats.cfm')#">Search Reporting</a>
		
		<div class="nav_breaker"></div>
		
		<div class="nav_title">Main</div>

		<a href="index.cfm" name="Admin Home" class="#navOn('index.cfm')#">Admin Home</a>
		<a href="../" name="Galleon Home" class="navs">Galleon Home</a>
		<a href="index.cfm?logout=1" name="Logout" class="navs">Logout</a>

		<div class="clearer"></div>
		</div>
	
		<div id="right">
				<div class="top_title">				
				<p>#attributes.title#</p>
				</div>
				
	</cfif>
					
</cfoutput>

<cfsetting enablecfoutputonly=false>

