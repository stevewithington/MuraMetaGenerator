<cfsilent>
<!---

This file is part of MuraMetaGenerator TM
(c) Stephen J. Withington, Jr. | www.stephenwithington.com

CAREFULLY READ THE ENCLOSED LICENSE AGREEMENT (plugin/license.htm). BY USING THIS SOFTWARE, YOU ARE CONSENTING TO BE BOUND BY AND ARE BECOMING A PARTY TO THIS AGREEMENT. IF YOU DO NOT AGREE TO ALL OF THE TERMS OF THIS AGREEMENT, THEN DO NOT USE THIS SOFTWARE, AND, IF APPLICABLE, RETURN THIS PRODUCT TO THE PLACE OF PURCHASE FOR A FULL REFUND.

--->
	<cfinclude template="config.cfm" />
	<cfscript>
		initialInstallDir = request.pluginConfig.getPluginID();
		finalInstallDir = request.pluginConfig.getDirectory();
		if ( finalInstallDir eq initialInstallDir ) {
			// this is being installed for the 1st time
			pluginDir = request.pluginConfig.getPluginID();
		} else {
			// this is an update and has already been installed before
			pluginDir = request.pluginConfig.getPackage() & '_' & request.pluginConfig.getPluginID();
		};
		linkToEULA = 'http://#getPageContext().getRequest().getServerName()#/plugins/#pluginDir#/plugin/license.htm';
	</cfscript>
</cfsilent>
<cfoutput><plugin>
	<name>MuraMetaGenerator</name>
	<package>MuraMetaGenerator</package>
	<directoryFormat>packageOnly</directoryFormat>
	<version>20101011</version>
	<provider>Steve Withington</provider>
	<providerURL>http://stephenwithington.com</providerURL>
	<category>Utility</category>
	<settings>
		<setting>
			<name>useMetaGenerator</name>
			<label>Use Meta Generator?</label>
			<hint>If 'Yes', then Meta Keywords and Meta Description will be auto-generated if the Meta Data is empty.</hint>
			<type>RadioGroup</type>
			<required>false</required>
			<validation></validation>
			<regex></regex>
			<message></message>
			<defaultvalue>1</defaultvalue>
			<optionlist>0^1</optionlist>
			<optionlabellist>No^Yes</optionlabellist>
		</setting>	
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
		<eventHandler event="onApplicationLoad" component="eventHandlers.muraMetaGenerator" persist="false" />
	</eventHandlers>
	<displayobjects location="global" />
</plugin></cfoutput>