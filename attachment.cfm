<cfsetting enablecfoutputonly=true>
<!---
	Name         : attachment.cfm
	Author       : Raymond Camden 
	Created      : November 3, 2004
	Last Updated : 
	History      : 
	Purpose		 : Load an attachment
--->

<cfif not isDefined("url.id") or not len(url.id)>
	<cflocation url="index.cfm" addToken="false">
</cfif>

<cftry>
	<cfset message = application.message.getMessage(url.id)>
	<cfcatch>
		<cflocation url="index.cfm" addToken="false">
	</cfcatch>
</cftry>

<cfif not len(message.filename)>
	<cflocation url="index.cfm" addToken="false">
</cfif>

<cfif not fileExists(application.settings.attachmentdir & "/" & message.filename)>
	<cflocation url="index.cfm" addToken="false">
</cfif>

<cfset extension = listLast(message.filename, ".")>

<cfswitch expression="#extension#">

	<cfcase value="txt">
		<cfheader name="Content-disposition" value="attachment;filename=#message.attachment#">
		<cfcontent file="#application.settings.attachmentdir#/#message.filename#" type="text/plain">
	</cfcase>
			
	<cfcase value="pdf">
		<cfheader name="Content-disposition" value="attachment;filename=#message.attachment#">		
		<cfcontent file="#application.settings.attachmentdir#/#message.filename#" type="application/pdf">
	</cfcase>
		
	<cfcase value="doc">
		<cfheader name="Content-disposition" value="attachment;filename=#message.attachment#">		
		<cfcontent file="#application.settings.attachmentdir#/#message.filename#" type="application/msword">		
	</cfcase>
	
	<cfcase value="ppt">
		<cfheader name="Content-disposition" value="attachment;filename=#message.attachment#">		
		<cfcontent file="#application.settings.attachmentdir#/#message.filename#" type="application/vnd.ms-powerpoint">		
	</cfcase>
	
	<cfcase value="xls">
		<cfheader name="Content-disposition" value="attachment;filename=#message.attachment#">		
		<cfcontent file="#application.settings.attachmentdir#/#message.filename#" type="application/application/vnd.ms-excel">		
	</cfcase>

	<cfcase value="zip">
		<cfheader name="Content-disposition" value="attachment;filename=#message.attachment#">		
		<cfcontent file="#application.settings.attachmentdir#/#message.filename#" type="application/application/zip">		
	</cfcase>
	
	<!--- everything else --->
	<cfdefaultcase>
		<cfheader name="Content-disposition" value="attachment;filename=#message.attachment#">		
		<cfcontent file="#application.settings.attachmentdir#/#message.filename#" type="application/unknown">		
	</cfdefaultcase>
			
</cfswitch>

<cfsetting enablecfoutputonly=false>