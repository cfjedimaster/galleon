<cfcomponent displayName="Utils" hint="Set of common methods.">
	<!---
	/**
	 * This function takes URLs in a text string and turns them into links.
	 * Version 2 by Lucas Sherwood, lucas@thebitbucket.net.
	 * Version 3 Updated to allow for ;
	 * 
	 * @param string 	 Text to parse. (Required)
	 * @param target 	 Optional target for links. Defaults to "". (Optional)
	 * @param paragraph 	 Optionally add paragraphFormat to returned string. (Optional)
	 * @return Returns a string. 
	 * @author Joel Mueller (jmueller@swiftk.com) 
	 * @version 3, August 11, 2004 
	 */
	--->
	<cffunction name="activeURL" access="public" returnType="string" output="false">
	<cfargument name="string" type="string" required="true">
	<cfscript>
	var nextMatch = 1;
	var objMatch = "";
	var outstring = "";
	var thisURL = "";
	var thisLink = "";
	var	target = IIf(arrayLen(arguments) gte 2, "arguments[2]", DE(""));
	var paragraph = IIf(arrayLen(arguments) gte 3, "arguments[3]", DE("false"));
	
	do {
		objMatch = REFindNoCase("(((https?:|ftp:|gopher:)\/\/)|(www\.|ftp\.))[-[:alnum:]\?%,\.\/&##!;@:=\+~_]+[A-Za-z0-9\/]", string, nextMatch, true);
		if (objMatch.pos[1] GT nextMatch OR objMatch.pos[1] EQ nextMatch) {
			outString = outString & Mid(String, nextMatch, objMatch.pos[1] - nextMatch);
		} else {
			outString = outString & Mid(String, nextMatch, Len(string));
		}
		nextMatch = objMatch.pos[1] + objMatch.len[1];
		if (ArrayLen(objMatch.pos) GT 1) {
			// If the preceding character is an @, assume this is an e-mail address
			// (for addresses like admin@ftp.cdrom.com)
			if (Compare(Mid(String, Max(objMatch.pos[1] - 1, 1), 1), "@") NEQ 0) {
				thisURL = Mid(String, objMatch.pos[1], objMatch.len[1]);
				thisLink = "<A HREF=""";
				switch (LCase(Mid(String, objMatch.pos[2], objMatch.len[2]))) {
					case "www.": {
						thisLink = thisLink & "http://";
						break;
					}
					case "ftp.": {
						thisLink = thisLink & "ftp://";
						break;
					}
				}
				thisLink = thisLink & thisURL & """";
				if (Len(Target) GT 0) {
					thisLink = thisLink & " TARGET=""" & Target & """";
				}
				thisLink = thisLink & ">" & thisURL & "</A>";
				outString = outString & thisLink;
				// String = Replace(String, thisURL, thisLink);
				// nextMatch = nextMatch + Len(thisURL);
			} else {
				outString = outString & Mid(String, objMatch.pos[1], objMatch.len[1]);
			}
		}
	} while (nextMatch GT 0);
		
	// Now turn e-mail addresses into mailto: links.
	outString = REReplace(outString, "([[:alnum:]_\.\-]+@([[:alnum:]_\.\-]+\.)+[[:alpha:]]{2,4})", "<A HREF=""mailto:\1"">\1</A>", "ALL");
		
	if (paragraph) {
		outString = ParagraphFormat(outString);
	}
	return outString;
	</cfscript>
	</cffunction>
	
	<cffunction name="logSearch" returnType="void" output="false" access="public" hint="Logs a search request">
		<cfargument name="searchTerms" type="string" required="true">
		<cfargument name="dsn" type="string" required="true">
		<cfargument name="tableprefix" type="string" required="true">
		
		<cfquery datasource="#arguments.dsn#">
			insert into #arguments.tableprefix#search_log(searchterms, datesearched)
			values(<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(arguments.searchTerms, 255)#">,
			       <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
		</cfquery>
		
	</cffunction>
	
	<cffunction name="isTheUserInAnyRole" access="public" returnType="boolean" output="false"
				hint="isUserInRole only does AND checks. This method allows for OR checks.">
		
		<cfargument name="rolelist" type="string" required="true">
		<cfset var role = "">
		
		<cfloop index="role" list="#rolelist#">
			<cfif isUserInRole(role)>
				<cfreturn true>
			</cfif>
		</cfloop>
		
		<cfreturn false>
		
	</cffunction>
	
	<!---
	/**
	 * An &quot;enhanced&quot; version of ParagraphFormat.
	 * Added replacement of tab with nonbreaking space char, idea by Mark R Andrachek.
	 * Rewrite and multiOS support by Nathan Dintenfas.
	 * 
	 * @param string 	 The string to format. (Required)
	 * @return Returns a string. 
	 * @author Ben Forta (ben@forta.com) 
	 * @version 3, June 26, 2002 
	 */
	--->
	<cffunction name="paragraphFormat2" access="public" returnType="string" output="false">
		<cfargument name="str" type="string" required="true">
		<cfscript>
		//first make Windows style into Unix style
		str = replace(str,chr(13)&chr(10),chr(10),"ALL");
		//now make Macintosh style into Unix style
		str = replace(str,chr(13),chr(10),"ALL");
		//now fix tabs
		str = replace(str,chr(9),"&nbsp;&nbsp;&nbsp;","ALL");
		//now return the text formatted in HTML
		return replace(str,chr(10),"<br />","ALL");
		</cfscript>
	</cffunction>
	
	<cffunction name="queryToStruct" access="public" returnType="struct" output="false"
				hint="Transforms a query to a struct.">
		<cfargument name="theQuery" type="query" required="true">
		<cfset var s = structNew()>
		<cfset var q ="">
		
		<cfloop index="q" list="#theQuery.columnList#">
			<cfset s[q] = theQuery[q][1]>
		</cfloop>
		
		<cfreturn s>
		
	</cffunction>
	
	<cffunction name="searchSafe" access="public" returnType="string" output="false"
				hint="Removes any non a-z, 0-9 characters.">
		<cfargument name="string" type="string" required="true">
		
		<cfreturn reReplace(arguments.string,"[^a-zA-Z0-9[:space:]]+","","all")>
	</cffunction>
	
	<cffunction name="throw" access="public" returnType="void" output="false"
				hint="Handles exception throwing.">
				
		<cfargument name="type" type="string" required="true">		
		<cfargument name="message" type="string" required="true">
		
		<cfthrow type="#arguments.type#" message="#arguments.message#">
		
	</cffunction>

</cfcomponent>