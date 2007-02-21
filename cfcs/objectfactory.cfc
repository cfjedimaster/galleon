<!---
	Name         : objectFactory.cfc
	Author       : Rob Gonda
	Created      : August 25, 2006
	Last Updated : August 25, 2006
	History      : 
	Purpose		 : Simple Object Factory / Service Locator
--->
<cfcomponent displayname="objectFactory" hint="I am a simple object factory">

	<!--- 
		function init
		in:		
		out:	this
		notes:	usually initialized in application
	 --->
	<cffunction name="init" access="public" output="No" returntype="objectFactory">
	
		<cfscript>
			// persistance of objects
			variables.com = structNew();
		</cfscript>

		<cfreturn this />
	</cffunction>

	<!--- 
		function getObject
		in:		name of object
		out:	object
		notes:	
	 --->
	<cffunction name="createObj" access="public" output="No" returntype="any">
		<cfargument name="objName" required="Yes" />
		
		<cfscript>
			switch(arguments.objName) {
				case "conference":
					return createObject('component','conference').init(
						settings = getInstance('galleonSettings'),
						forum = getInstance('forum'),
						utils = getInstance('utils')
					);
				break;

				case "forum":
					return createObject('component','forum').init(
						settings = getInstance('galleonSettings'),
						thread = getInstance('thread'),
						utils = getInstance('utils')
					);
				break;

				case "galleonSettings":
					return createObject('component','galleon');
				break;

				case "message":
					return createObject('component','message').init(
						settings = getInstance('galleonSettings'),
						thread = getInstance('thread'),
						forum = getInstance('forum'),
						conference = getInstance('conference'),
						user = getInstance('user'),
						utils = getInstance('utils')
					);
				break;

				case "rank":
					return createObject('component','rank').init(
						settings = getInstance('galleonSettings'),
						utils = getInstance('utils')
						
					);
				break;

				case "thread":
					return createObject('component','thread').init(
						settings = getInstance('galleonSettings'),
						utils = getInstance('utils')
					);
				break;

				case "user":
					return createObject('component','user').init(
						settings = getInstance('galleonSettings'),
						utils = getInstance('utils')
					);
				break;

				case "utils":
					return createObject('component','utils');
				break;

			}
		</cfscript>
		
	</cffunction>
	
	
	<!--- 
		function getInstance
		in:		name of object
		out:	object
		notes:	create a persistant object if doen not previously exists
	 --->
	<cffunction name="getInstance" access="public" output="No" returntype="any">
		<cfargument name="objName" required="Yes" />
		
		<cfscript>
			if ( not StructKeyExists(variables.com, arguments.objName) ){
				variables.com[arguments.objName] = createObj(arguments.objName);
			}
			
			return variables.com[arguments.objName];
		</cfscript>
	</cffunction>

	<cffunction name="removeInstance" access="public" output="No" returntype="void">
		<cfargument name="objName" required="Yes" />
	
		<cfscript>
			if ( StructKeyExists(variables.com, arguments.objName) ){
				structDelete(variables.com, arguments.objName);
			}
		</cfscript>
	</cffunction>

</cfcomponent>