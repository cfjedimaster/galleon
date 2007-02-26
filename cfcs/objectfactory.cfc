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
	<cffunction name="get" access="public" output="No" returntype="any">
		<cfargument name="objName" required="false" type="string" />
		<cfargument name="singleton" required="false" type="boolean" default="true" />
		
		<cfscript>
			var obj = ''; //local var to hold object
			if (arguments.singleton and singletonExists(arguments.objName)) {
				return getSingleton(arguments.objName);
			}
		
			switch(arguments.objName) {
				case "conference":
					obj = createObject('component','conference').init();
						if (arguments.singleton) { // scope singleton
							addSingleton(arguments.objName, obj);
						}
						// inject dependencies through setter
						obj.setSettings( get('galleonSettings', arguments.singleton) );
						obj.setForum( get('forum', arguments.singleton) );
						obj.setUtils( get('utils', arguments.singleton) );
					return obj;
				break;

				case "forum":
					obj = createObject('component','forum').init();
						if (arguments.singleton) { // scope singleton
							addSingleton(arguments.objName, obj);
						}
						// inject dependencies through setter
						obj.setSettings( get('galleonSettings', arguments.singleton) );
						obj.setThread( get('thread', arguments.singleton) );
						obj.setUtils( get('utils', arguments.singleton) );
					return obj;
				break;

				case "galleonSettings":
					obj = createObject('component','galleon');
						if (arguments.singleton) { // scope singleton
							addSingleton(arguments.objName, obj);
						}
					return obj;
				break;

				case "message":
					obj = createObject('component','message').init();
						if (arguments.singleton) { // scope singleton
							addSingleton(arguments.objName, obj);
						}
						// inject dependencies through setter
						obj.setSettings( get('galleonSettings', arguments.singleton) );
						obj.setThread( get('thread', arguments.singleton) );
						obj.setForum( get('forum', arguments.singleton) );
						obj.setConference( get('conference', arguments.singleton) );
						obj.setUser( get('user', arguments.singleton) );
						obj.setUtils( get('utils', arguments.singleton) );
					return obj;
				break;

				case "rank":
					obj = createObject('component','rank').init();
						if (arguments.singleton) { // scope singleton
							addSingleton(arguments.objName, obj);
						}
						// inject dependencies through setter
						obj.setSettings( get('galleonSettings', arguments.singleton) );
						obj.setUtils( get('utils', arguments.singleton) );
					return obj;
				break;

				case "thread":
					obj = createObject('component','thread').init();
						if (arguments.singleton) { // scope singleton
							addSingleton(arguments.objName, obj);
						}
						// inject dependencies through setter
						obj.setSettings( get('galleonSettings', arguments.singleton) );
						obj.setUtils( get('utils', arguments.singleton) );
						obj.setMessage( get('message', arguments.singleton) );
					return obj;
				break;

				case "user":
					obj = createObject('component','user').init();
						if (arguments.singleton) { // scope singleton
							addSingleton(arguments.objName, obj);
						}
						// inject dependencies through setter
						obj.setSettings( get('galleonSettings', arguments.singleton) );
						obj.setUtils( get('utils', arguments.singleton) );
					return obj;
				break;

				case "utils":
					obj = createObject('component','utils');
						if (arguments.singleton) { // scope singleton
							addSingleton(arguments.objName, obj);
						}
						// inject dependencies through setter
					return obj;
				break;

			}
		</cfscript>
		
	</cffunction>
	
	
	<cffunction name="singletonExists" access="public" output="No" returntype="boolean">
		<cfargument name="objName" required="Yes" type="string" />
		<cfreturn StructKeyExists(variables.com, arguments.objName) />
	</cffunction>
	
	<cffunction name="addSingleton" access="public" output="No" returntype="void">
		<cfargument name="objName" required="Yes" type="string" />
		<cfargument name="obj" required="Yes" />
		<cfset variables.com[arguments.objName] = arguments.obj />
	</cffunction>

	<cffunction name="getSingleton" access="public" output="No" returntype="any">
		<cfargument name="objName" required="Yes" type="string" />
		<cfreturn variables.com[arguments.objName] />
	</cffunction>

	<cffunction name="removeSingleton" access="public" output="No" returntype="void">
		<cfargument name="objName" required="Yes" />
		<cfscript>
			if ( StructKeyExists(variables.com, arguments.objName) ){
				structDelete(variables.com, arguments.objName);
			}
		</cfscript>
	</cffunction>

</cfcomponent>