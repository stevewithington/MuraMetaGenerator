<cfsilent><cfscript>
/**
* 
* This file is part of MuraMetaGenerator TM
*
* Copyright 2010-2012 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
if ( !IsDefined('$') ) {

	$ = application.serviceFactory.getBean('$');

	if ( StructKeyExists(session, 'siteid') ) {
		$.init(session.siteid);
	} else {
		$.init('default');
	};

};

if ( !IsDefined('pluginConfig') ) {
	pluginConfig = $.getBean('pluginManager').getConfig('MuraMetaGenerator');
};

if ( !$.currentUser().isSuperUser() ) {
	location( url='#$.globalConfig('context')#/admin/', addtoken=false );
};
</cfscript></cfsilent>