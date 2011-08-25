<!---

This file is part of MuraMetaGenerator TM
(c) Stephen J. Withington, Jr. | www.stephenwithington.com

CAREFULLY READ THE ENCLOSED LICENSE AGREEMENT (plugin/license.htm). BY USING THIS SOFTWARE, YOU ARE CONSENTING TO BE BOUND BY AND ARE BECOMING A PARTY TO THIS AGREEMENT. IF YOU DO NOT AGREE TO ALL OF THE TERMS OF THIS AGREEMENT, THEN DO NOT USE THIS SOFTWARE, AND, IF APPLICABLE, RETURN THIS PRODUCT TO THE PLACE OF PURCHASE FOR A FULL REFUND.

Notes:
		2010.10.11 - sjw - added edits by Maurice Crama: stripTagContent() to remove any embedded js- style-tags from the rendered content. also including setDynamicContent() to render any embedded [mura] tags.

--->
<cfcomponent extends="mura.plugin.pluginGenericEventHandler">

	<cfscript>
		variables.instance = StructNew();
		variables.instance.event = StructNew();
		variables.instance.customSummary = '';
		variables.instance.metaKeywords = '';
		variables.instance.metaDesc = '';
	</cfscript>

	<cffunction name="onApplicationLoad" output="false" returntype="void">
		<cfargument name="event" required="true" />
		<cfscript>
			var local = StructNew();
			setEvent(arguments.event);
			variables.pluginConfig.addEventHandler(this);
		</cfscript>
	</cffunction>

	<cffunction name="onRenderStart" output="false" returntype="void">
		<cfargument name="event" required="true" />
		<cfscript>
			var local = StructNew();
			setEvent(arguments.event);
			event.muraMetaGenerator = this;
		</cfscript>
	</cffunction>

	<cffunction name="onRenderEnd" output="false" returntype="void">
		<cfargument name="event" required="true" />
		<cfscript>
			var local = StructNew();
			setEvent(arguments.event);
			
			// replace the meta description and meta keywords if they haven't been defined via admin
			if ( variables.pluginConfig.getSetting('useMetaGenerator') ) {
				doMetaSwitch();
			};
		</cfscript>
	</cffunction>


	<!--- ****************************************  HELPERS  ************************************************* --->
	<cffunction name="listDeleteDuplicates" access="public" output="false" returntype="any">
		<cfargument name="list" required="false" default="" />
		<cfargument name="delimiter" required="false" default="," />
		<cfargument name="debug" required="false" type="boolean" default="false" />
		<cfscript>
			var local = StructNew();
			local.ret = '';
			local.i = 0;
			if ( StructKeyExists(arguments, 'list') ) {
				local.arr = ListToArray(arguments.list, arguments.delimiter);
				for ( local.i=1; local.i lte ArrayLen(local.arr); local.i++ ) {
					if ( not ListFindNoCase(local.ret, local.arr[local.i], arguments.delimiter) ) {
						local.ret = ListAppend(local.ret, local.arr[local.i], arguments.delimiter);
					};
				};
			};
			if ( arguments.debug ) {
				return local;
			} else {
				return local.ret;
			};
		</cfscript>
	</cffunction>

	<cffunction name="listDelete" access="public" output="false" returntype="any">
		<cfargument name="strToRemove" required="false" default="" />
		<cfargument name="list" required="false" default="" />
		<cfargument name="delimiter" required="false" default="," />
		<cfargument name="debug" required="false" type="boolean" default="false" />
		<cfscript>
			var local = StructNew();
			local.ret = '';
			local.i = 0;
			if ( StructKeyExists(arguments, 'strToRemove') and StructKeyExists(arguments, 'list') ) {
				local.arr = ListToArray(arguments.list, arguments.delimiter);
				for ( local.i=1; local.i lte ArrayLen(local.arr); local.i++ ) {
					if ( not ListFindNoCase(arguments.strToRemove, local.arr[local.i], arguments.delimiter) ) {
						local.ret = ListAppend(local.ret, local.arr[local.i], arguments.delimiter);
					};
				};
			};
			if ( arguments.debug ) {
				return local;
			} else {
				return local.ret;
			};
		</cfscript>
	</cffunction>

	<cffunction name="doMetaSwitch" access="public" output="false" returntype="any">
		<cfargument name="debug" required="false" type="boolean" default="false" />
		<cfscript>
			var local = StructNew();	
			
			// META DESCRIPTION
			setMetaDesc();
			local.oldMetaDesc = '<meta name="description" content="#HTMLEditFormat(getEvent().getContentRenderer().getMetaDesc())#" />';
			local.newMetaDesc = '<meta name="description" content="#getMetaDesc()#" />';
			local.newResponse = ReplaceNoCase(getEvent().getValue('__MuraResponse__'), local.oldMetaDesc, local.newMetaDesc);
			if ( not FindNoCase(local.newMetaDesc, local.newResponse) ) {
				local.newResponse = ReplaceNoCase(getEvent().getValue('__MuraResponse__'), '<head>', '<head>' & local.newMetaDesc);
			};
			getEvent().setValue('__MuraResponse__', local.newResponse);

			// META KEYWORDS
			setMetaKeywords();
			local.oldMetaKeywords = '<meta name="keywords" content="#HTMLEditFormat(getEvent().getContentRenderer().getMetaKeyWords())#" />';
			local.newMetaKeywords = '<meta name="keywords" content="#getMetaKeywords()#" />';
			local.newResponse = ReplaceNoCase(getEvent().getValue('__MuraResponse__'), local.oldMetaKeywords, local.newMetaKeywords);
			if ( not FindNoCase(local.newMetaKeywords, local.newResponse) ) {
				local.newResponse = ReplaceNoCase(getEvent().getValue('__MuraResponse__'), '<head>', '<head>' & local.newMetaKeywords);
			};
			getEvent().setValue('__MuraResponse__', local.newResponse);
			if ( arguments.debug ) {
				return local;
			} else {
				return true;
			};
		</cfscript>	
	</cffunction>

	<!--- ****************************************  MISC.  ************************************************* --->
	<cffunction name="setEvent" returntype="void" output="false">
		<cfargument name="event" required="true" />
		<cfset variables.instance.event = arguments.event />
	</cffunction>

	<cffunction name="getEvent" returntype="any" output="false">
		<cfreturn variables.instance.event />
	</cffunction>

	<cffunction name="getMetaDesc" returntype="any" output="false">
		<cfreturn variables.instance.metaDesc />
	</cffunction>

	<cffunction name="setMetaDesc" returntype="void" output="false">
		<cfargument name="metaDesc" required="false" default="" />

		<cfscript>
			var local = StructNew();
			if ( StructKeyExists(arguments, 'metaDesc') and len(trim(arguments.metaDesc)) ) {
				variables.instance.metaDesc = arguments.metaDesc;
			} else {
				local.str = '';
				if ( len(trim(getEvent().getContentRenderer().getMetaDesc())) ) {
					local.str = getEvent().getContentRenderer().getMetaDesc();
				} else {
					local.str = getEvent().getContentBean().getTitle() & ': ';
					local.str = local.str & getEvent().getContentRenderer().setDynamicContent(getEvent().getContentBean().getBody());
					local.str = stripTagContent(local.str);
					local.str = getEvent().getContentRenderer().stripHTML(local.str);
					setCustomSummary(str=local.str);
					local.str = getCustomSummary();
				};
				local.str = HtmlEditFormat(trim(local.str));
				variables.instance.metaDesc = local.str;
			};
		</cfscript>
		
	</cffunction>

	<cffunction name="getMetaKeywords" returntype="any" output="false">
		<cfreturn variables.instance.metaKeywords />
	</cffunction>

	<cffunction name="setMetaKeywords" returntype="void" output="false">
		<cfargument name="metaKeywords" required="false" default="" />
		<cfargument name="contentToParse" required="false" default="#getEvent().getContentRenderer().setDynamicContent(getEvent().getContentBean().getBody())#" />
		<cfargument name="metaKeywordsToIgnore" required="false" default="#variables.pluginConfig.getSetting('metaKeywordsToIgnore')#" />
		<cfargument name="delimiter" required="false" default="," />
		<cfscript>
			var local = StructNew();
			if ( StructKeyExists(arguments, 'metaKeywords') and len(trim(arguments.metaKeywords)) ) {
				variables.instance.metaKeywords = arguments.metaKeywords;
			} else {
				local.ret = '';
				// if keywords already exists, use them
				if ( len(trim(getEvent().getContentRenderer().getMetaKeyWords())) ) {
					local.ret = HtmlEditFormat(trim(getEvent().getContentRenderer().getMetaKeyWords()));			
				} else {
					if ( StructKeyExists(arguments, 'contentToParse') ) {
						local.ret = stripTagContent(arguments.contentToParse);
						local.ret = getEvent().getContentRenderer().stripHTML(local.ret);
						local.ret = getEvent().getContentBean().getTitle() & ' ' & local.ret;
						local.ret = ReReplace(local.ret, "[;\\/:""*?<>|\!\+\-\=\.`\##\&_\(\)\[\]\%\^\$\@~\',\{\}]+", "", "ALL");
						local.ret = ReReplace(local.ret, "[\s|\r\n?|\n]+", ",", "ALL");
						local.ret = listDeleteDuplicates(local.ret);
						if ( StructKeyExists(arguments, 'metaKeywordsToIgnore') ) {
							local.ret = listDelete(arguments.metaKeywordsToIgnore, local.ret);
						};
						local.ret = HtmlEditFormat(lcase(trim(local.ret)));
					};
				};
				variables.instance.metaKeywords = local.ret;
			};
		</cfscript>
	</cffunction>

	<cffunction name="stripTagContent" returntype="string" output="false">
		<cfargument name="contentToParse" required="true" />
		<cfargument name="tagsToStrip" required="false" default="script,style,embed,object" />
		<cfscript>
			var local = StructNew();
			local.str = arguments.contentToParse;
			for ( local.i=1; local.i lte ListLen(arguments.tagsToStrip); local.i++ ) {   
				local.listItem = ListGetAt(arguments.tagsToStrip,local.i);      
				local.str = ReReplaceNoCase(local.str,'<' & local.listItem & '.*?>.*?</' & local.listItem & '>','','all');
			};
			return local.str;
		</cfscript>
	</cffunction>

	<cffunction name="getCustomSummary" returntype="any" output="false">
		<cfreturn variables.instance.customSummary />
	</cffunction>

	<cffunction name="setCustomSummary" returntype="void" output="false">
		<cfargument name="customSummary" required="false" default="" />
		<cfargument name="str" required="false" type="string" default="" />
		<cfargument name="count" required="false" type="numeric" default="26" />
		<cfscript>
			var local = StructNew();
			if ( StructKeyExists(arguments, 'customSummary') and len(trim(arguments.customSummary)) ) {
				variables.instance.customSummary = arguments.customSummary;
			} else {
				local.str = arguments.str;
				local.count = val(arguments.count);
				if ( len(trim(local.str)) ) {
					local.str = getEvent().getContentRenderer().stripHTML(local.str);
					local.str = REReplace(local.str, "[\s|\r\n?|\n]+", " ", "ALL");
					javaArray = CreateObject("java","java.util.Arrays");
					wordArray = javaArray.copyOf(local.str.Split( " " ), local.count);
					local.str = ArrayToList(wordArray, " ");
				};
				variables.instance.customSummary = trim(local.str);
			};
		</cfscript>
	</cffunction>

	<cffunction name="getAllValues" returntype="any" output="false">
		<cfreturn variables.instance />
	</cffunction>

</cfcomponent>