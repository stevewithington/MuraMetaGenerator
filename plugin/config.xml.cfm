<cfscript>
/**
* 
* This file is part of MuraMetaGenerator TM
*
* Copyright 2010-2015 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
	include 'settings.cfm';
</cfscript>
<cfoutput>
	<plugin>
		<name>#variables.settings.pluginName#</name>
		<package>#variables.settings.package#</package>
		<directoryFormat>packageOnly</directoryFormat>
		<loadPriority>#variables.settings.loadPriority#</loadPriority>
		<version>#variables.settings.version#</version>
		<provider>#variables.settings.provider#</provider>
		<providerURL>#variables.settings.providerURL#</providerURL>
		<category>#variables.settings.category#</category>
		<mappings></mappings>
		<settings>
			<setting>
				<name>metaKeywordsToIgnore</name>
				<label>Meta Keywords to Ignore</label>
				<hint>A comma-separated list of words to ignore when rendering Meta Keywords.</hint>
				<type>textarea</type>
				<required>false</required>
				<validation></validation>
				<regex></regex>
				<message></message>
				<defaultvalue>a,also,an,and,are,as,at,be,but,by,for,from,had,have,he,his,i,in,is,it,of,on,or,that,the,they,this,to,too,was,what,who,with</defaultvalue>
				<optionlist></optionlist>
				<optionlabellist></optionlabellist>
			</setting>
		</settings>
		<eventHandlers>
			<eventHandler event="onApplicationLoad" component="extensions.eventHandler" persist="false" />
		</eventHandlers>
		<displayobjects location="global"></displayobjects>
		<extensions></extensions>
	</plugin>
</cfoutput>
