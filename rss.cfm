<cfsetting enablecfoutputonly=true showdebugoutput=false>
<!---
	Name         : rss.cfm
	Author       : Raymond Camden 
	Created      : July 5, 2004
	Last Updated : November 10, 2007
	History      : Reset for V2
				 : security fix (rkc 11/10/07)
	Purpose		 : Displays RSS for a Conference
--->

<cfif not isDefined("url.conferenceid") or not len(url.conferenceid)>
	<cflocation url="index.cfm" addToken="false">
</cfif>

<!--- get parent conference --->
<cftry>
	<cfset request.conference = application.conference.getConference(url.conferenceid)>
	<cfcatch>
		<cflocation url="index.cfm" addToken="false">
	</cfcatch>
</cftry>

<cfif not application.permission.allowed(application.rights.CANVIEW, url.conferenceid, request.udf.getGroups())>
	<cfabort>
</cfif>

<!--- get my latest posts --->
<cfset data = application.conference.getLatestPosts(conferenceid=url.conferenceid)>

<cfcontent type="text/xml"><cfoutput><?xml version="1.0" encoding="iso-8859-1"?>

<rdf:RDF 
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns##"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns="http://purl.org/rss/1.0/"
>

	<channel rdf:about="#application.settings.rootURL#">
	<title>#application.settings.title# : Conference : #request.conference.name#</title>
	<description>Conference : #request.conference.name# : #request.conference.description#</description>
	<link>#application.settings.rootURL#</link>
	
	<items>
		<rdf:Seq>
			<cfloop query="data">
				<cfif application.permission.allowed(application.rights.CANVIEW, forumidfk, request.udf.getGroups()) and
					  application.permission.allowed(application.rights.CANVIEW, conferenceidfk, request.udf.getGroups())>
				<rdf:li rdf:resource="#application.settings.rootURL#messages.cfm?#xmlFormat("threadid=#threadid#")##xmlFormat("&r=#currentRow#")#" />
				</cfif>
			</cfloop>
		</rdf:Seq>
	</items>
	
	</channel>

	<cfloop query="data">
		<cfif application.permission.allowed(application.rights.CANVIEW, forumidfk, request.udf.getGroups()) and
			  application.permission.allowed(application.rights.CANVIEW, conferenceidfk, request.udf.getGroups())>

			<cfset dateStr = dateFormat(posted,"yyyy-mm-dd")>
			<cfset z = getTimeZoneInfo()>
			<cfset dateStr = dateStr & "T" & timeFormat(posted,"HH:mm:ss") & "-" & numberFormat(z.utcHourOffset,"00") & ":00">
		
			<item rdf:about="#application.settings.rootURL#messages.cfm?#xmlFormat("threadid=#threadid#")##xmlFormat("&r=#currentRow#")#">
			<title>#xmlFormat(title)#</title>
			<description>#xmlFormat(body)#</description>
			<link>#application.settings.rootURL#messages.cfm?#xmlFormat("threadid=#threadid#")##xmlFormat("&r=#currentRow#")#</link>
			<dc:date>#dateStr#</dc:date>
			<dc:subject>#thread#</dc:subject>
			</item>
		
		</cfif>
		
	</cfloop>

</rdf:RDF>
</cfoutput>

<cfsetting enablecfoutputonly=false>
