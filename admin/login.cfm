<cfsetting enablecfoutputonly=true>
<!---
	Name         : login.cfm
	Author       : Raymond Camden 
	Created      : June 01, 2004
	Last Updated : June 01, 2004
	History      : 
	Purpose		 : 
--->

<!---
<body bgcolor="##CCCCCC" onload="document.login.username.focus()">
--->
<cfmodule template="../tags/layout.cfm" templatename="admin" title="Galleon Forums Administrator Login">

<cfoutput>
<div id="login_container">
<form action="#cgi.script_name#?#cgi.query_string#" method="post" name="login">
				
		<p>username</p>
		<input type="text" name="username" size="30">
		<p>password</p>
		<input type="password" name="password" size="30">
		
		<br /><br />
		<input type="image" src="../images/btn_login.jpg" alt="login" name="logon" value="Login">

</form>	
<div class="clearer"></div>
</div>

</cfoutput>
</cfmodule>

<cfsetting enablecfoutputonly=false>