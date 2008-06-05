<cfsetting enablecfoutputonly=true>
<!---
	Name         : settings.cfm
	Author       : Raymond Camden 
	Created      : September 9, 2007
	Last Updated : 
	History      : 
	Purpose		 : 
--->

<cfif structKeyExists(form, "save.x")>

	<cfset errors = arrayNew(1)>
	
	<cfif not len(trim(form.dsn))>
		<cfset arrayAppend(errors, "Your forum must have a DSN.")>
	</cfif>

	<cfif not len(trim(form.perpage)) or not isNumeric(form.perpage) or form.perpage lte 0>
		<cfset arrayAppend(errors, "Items per page must be numeric and greater than zero.")>
	</cfif>

	<cfif not len(trim(form.fromaddress)) or not isEmail(form.fromaddress)>
		<cfset arrayAppend(errors, "The From Address must be a valid email address.")>
	</cfif>

	<cfif not len(trim(form.rooturl)) or not isValid("url", form.rooturl)>
		<cfset arrayAppend(errors, "The Root URL must be a valid URL.")>
	</cfif>

	<cfif len(trim(form.sendonpost)) and not isValid("email", form.sendonpost)>
		<cfset arrayAppend(errors, "The Send on Post value must be a valid email address.")>
	</cfif>
	
	<cfif not len(trim(form.dbtype)) or not listFindNoCase("sqlserver,access,mysql",form.dbtype)>
		<cfset arrayAppend(errors, "Your forum must have a database type and must be sqlserver, access, or mysql.")>
	</cfif>

	<cfif not len(trim(form.title))>
		<cfset arrayAppend(errors, "Your forum must have a title.")>
	</cfif>

	<cfif not len(trim(form.version))>
		<cfset arrayAppend(errors, "Your forum must have a version.")>
	</cfif>
	
	<cfif not arrayLen(errors)>

		<cfset keylist = "bbcode_editor,dsn,perpage,fromaddress,rooturl,sendonpost,dbtype,tableprefix,requireconfirmation,title,version,fullemails,encryptpasswords,allowavatars,safeextensions">
		<cfloop index="key" list="#keylist#">
			<cfif structKeyExists(form, key)>
				<cfset application.factory.get('galleonSettings').setSetting(key, trim(form[key]))>
			</cfif>
		</cfloop>
		<cflocation url="settings.cfm?reinit=1" addToken="false">

	</cfif>
	
</cfif>

<cfloop item="setting" collection="#application.settings#">
	<cfparam name="form.#setting#" default="#application.settings[setting]#">
</cfloop>

<cfmodule template="../tags/layout.cfm" templatename="admin" title="Settings">

<cfoutput>
<cfif isDefined("errors")>
<p>
<b>Please correct the following errors:
<ul>
<cfloop index="x" from="1" to="#arrayLen(errors)#">
<li>#errors[x]#</li>
</cfloop>
</ul>
</b>
</p>
</cfif>
<div class="clearer"></div>
<div class="name_row">
	<p class="font_10"></p>
</div>
								
<div class="secondary_row">
	<p class="left_100 align_center font_red">Please note that editing these settings incorrectly can result in your forum not running. <span>Please be careful with these settings!</span></p>
<div class="clearer"></div>
</div>
				
<form action="#cgi.script_name#?#cgi.query_string#" method="post">
<div class="row_0">
<p class="input_name">DSN</p>
<input type="text" name="dsn" value="#form.dsn#" size="100" class="inputs_01">
<div class="clearer"></div>
</div>

<div class="row_1">
	<p class="input_name">Items Per Page</p>
	<input type="text" name="perpage" value="#form.perpage#" class="inputs_01">
<div class="clearer"></div>
</div>

<div class="row_0">
	<p class="input_name">From Address</p>
	<input type="text" name="fromaddress" value="#form.fromaddress#" class="inputs_01">	
<div class="clearer"></div>
</div>

<div class="row_1">
	<p class="input_name">Root URL</p>
	<input type="text" name="rooturl" value="#form.rooturl#" class="inputs_01">
<div class="clearer"></div>
</div>
				
<div class="row_0">
	<p class="input_name">Send On Post</p>
	<input type="text" name="sendonpost" value="#form.sendonpost#" class="inputs_01">	
<div class="clearer"></div>

</div>
<div class="row_1">
	<p class="input_name">Database Type</p>
	<input type="text" name="dbtype" value="#form.dbtype#" class="inputs_01">
<div class="clearer"></div>
</div>
				
<div class="row_0">
	<p class="input_name">Table Prefix</p>

	<input type="text" name="tableprefix" value="#form.tableprefix#" class="inputs_01">
<div class="clearer"></div>
</div>

<div class="row_1">
	<p class="input_name">Version</p>
	<input type="text" name="version" value="#form.version#" class="inputs_01">
<div class="clearer"></div>
</div>

<div class="row_0">
	<p class="input_name">Require Confirmation</p>
		<input type="radio" name="requireconfirmation" value="true" <cfif form.requireconfirmation>checked</cfif>>Yes<br>
		<input type="radio" name="requireconfirmation" value="false" <cfif not form.requireconfirmation>checked</cfif>>No<br>
<div class="clearer"></div>
</div>
<div class="row_1">
	<p class="input_name">Title</p>
	<input type="text" name="title" value="#form.title#" class="inputs_01">

<div class="clearer"></div>
</div>

<div class="row_0">
	<p class="input_name">Full Emails</p>
	<input type="radio" name="fullemails" value="true" <cfif form.fullemails>checked</cfif>>Yes<br>
	<input type="radio" name="fullemails" value="false" <cfif not form.fullemails>checked</cfif>>No<br>
<div class="clearer"></div>
</div>

<div class="row_1">

	<p class="input_name">Encrypt Passwords</p>
	<input type="radio" name="encryptpasswords" value="true" <cfif form.encryptpasswords>checked</cfif>>Yes<br>
	<input type="radio" name="encryptpasswords" value="false" <cfif not form.encryptpasswords>checked</cfif>>No<br>
<div class="clearer"></div>
</div>
				
<div class="row_0">
	<p class="input_name">Allow Avatars</p>
	<input type="radio" name="allowavatars" value="true" <cfif form.allowavatars>checked</cfif>>Yes<br>
	<input type="radio" name="allowavatars" value="false" <cfif not form.allowavatars>checked</cfif>>No<br>
<div class="clearer"></div>
</div>
				
<div class="row_1">
	<p class="input_name">Safe Extensions</p>
	<input type="text" name="safeextensions" value="#form.safeextensions#" class="inputs_01">
<div class="clearer"></div>
</div>

<div class="row_0">
	<p class="input_name">Use markItUp! Beta for rich text editing</p>
	<input type="radio" name="bbcode_editor" value="true" <cfif form.bbcode_editor>checked</cfif>>Yes<br>
	<input type="radio" name="bbcode_editor" value="false" <cfif not form.bbcode_editor>checked</cfif>>No<br>
<div class="clearer"></div>
</div>

<div id="input_btns">	
	<input type="image" src="../images/btn_save.jpg"  name="save" value="Save">
</div>
</form>

</cfoutput>


</cfmodule>

<cfsetting enablecfoutputonly=false>
