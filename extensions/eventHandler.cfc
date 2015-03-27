/**
* 
* This file is part of MuraMetaGenerator TM
*
* Copyright 2010-2015 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
component accessors=true extends='mura.plugin.pluginGenericEventHandler' output=false {

	property name='$' hint='mura scope';
	property name='customSummary';
	property name='metaKeywords';
	property name='metaDesc';

	include '../plugin/settings.cfm';

	public any function onApplicationLoad(required struct $) {
		variables.pluginConfig.addEventHandler(this);

		lock scope='application' type='exclusive' timeout=10 {
			application[variables.settings.package] = new contentRenderer(arguments.$);
		}

		set$(arguments.$);
	}

	public any function onSiteRequestStart(required struct $) {
		set$(arguments.$);
	}

	public any function onRenderEnd(required struct $) {
		set$(arguments.$);
		doMetaSwitch();
	}


	// Helpers		******************************************************************

	public any function listDeleteDuplicates(string list='', string delimiter=',', boolean debug=false) {
		var local = {};
		local.ret = '';
		local.i = 0;
		if ( Len(arguments.list) ) {
			local.arr = ListToArray(arguments.list, arguments.delimiter);
			for ( local.i=1; local.i <= ArrayLen(local.arr); local.i++ ) {
				if ( !ListFindNoCase(local.ret, local.arr[local.i], arguments.delimiter) ) {
					local.ret = ListAppend(local.ret, local.arr[local.i], arguments.delimiter);
				}
			}
		}

		return arguments.debug ? local : local.ret;
	}

	public any function listDelete(string strToRemove='', string list='', string delimiter=',', boolean debug=false) {
		var local = {};
		local.ret = '';
		local.i = 0;
		if ( Len(arguments.strToRemove) && Len(arguments.list) ) {
			local.arr = ListToArray(arguments.list, arguments.delimiter);
			for ( local.i=1; local.i <= ArrayLen(local.arr); local.i++ ) {
				if ( not ListFindNoCase(arguments.strToRemove, local.arr[local.i], arguments.delimiter) ) {
					local.ret = ListAppend(local.ret, local.arr[local.i], arguments.delimiter);
				}
			}
		}

		return arguments.debug ? local : local.ret;
	}


	public any function doMetaSwitch(boolean debug=false) {
		var local = {};	
		
		// META DESCRIPTION
		setMetaDesc();
		local.oldMetaDesc = '<meta name="description" content="#HTMLEditFormat($.content('metaDesc'))#">';

		local.newMetaDesc = '<meta name="description" content="#getMetaDesc()#">';

		local.newResponse = ReplaceNoCase($.event('__MuraResponse__'), local.oldMetaDesc, local.newMetaDesc);

		if ( not FindNoCase(local.newMetaDesc, local.newResponse) ) {
			local.newResponse = ReplaceNoCase($.event('__MuraResponse__'), '<head>', '<head>' & local.newMetaDesc);
		}

		$.event('__MuraResponse__', local.newResponse);

		// META KEYWORDS
		setMetaKeywords();

		local.oldMetaKeywords = '<meta name="keywords" content="#HTMLEditFormat($.content('metaKeywords'))#">';

		local.newMetaKeywords = '<meta name="keywords" content="#getMetaKeywords()#">';

		local.newResponse = ReplaceNoCase($.event('__MuraResponse__'), local.oldMetaKeywords, local.newMetaKeywords);

		if ( not FindNoCase(local.newMetaKeywords, local.newResponse) ) {
			local.newResponse = ReplaceNoCase($.event('__MuraResponse__'), '<head>', '<head>' & local.newMetaKeywords);
		}

		$.event('__MuraResponse__', local.newResponse);

		return arguments.debug ? local : true;
	}


	// MISC.		******************************************************************

	public void function setMetaDesc(required MetaDesc) {
		var local = StructNew();

		if ( Len(Trim(arguments.metaDesc)) ) {

			variables.metaDesc = arguments.metaDesc;

		} else {

			local.str = '';

			if ( Len(Trim($.content('metaDesc'))) ) {
				local.str = $.content('metaDesc');
			} else {

				local.str = $.content('title') & ': ';
				local.str = local.str & $.setDynamicContent($.content('body'));
				local.str = $.getBean('utility').stripTags(local.str);
				local.str = $.stripHTML(local.str);
				setCustomSummary(str=local.str);
				local.str = getCustomSummary();
			}

			local.str = esapiEncode('html', trim(local.str));
			variables.metaDesc = local.str;
		}
	}

	public void function setMetaKeywords(
		string metaKeywords=''
		, string contentToParse=$.setDynamicContent($.content('body'))
		, string metaKeywordsToIgnore=variables.pluginConfig.getSetting('metaKeywordsToIgnore')
		, string delimiter=','
	) {
		var local = {};
		if ( StructKeyExists(arguments, 'metaKeywords') and len(trim(arguments.metaKeywords)) ) {
			variables.instance.metaKeywords = arguments.metaKeywords;
		} else {
			local.ret = '';
			// if keywords already exists, use them
			if ( len(trim($.content('metaKeywords'))) ) {
				local.ret = HtmlEditFormat(trim($.content('metaKeywords')));			
			} else {
				if ( StructKeyExists(arguments, 'contentToParse') ) {
					local.ret = stripTagContent(arguments.contentToParse);
					local.ret = $.stripHTML(local.ret);
					local.ret = $.content('title') & ' ' & local.ret;
					local.ret = ReReplace(local.ret, "[;\\/:""*?<>|\!\+\-\=\.`\##\&_\(\)\[\]\%\^\$\@~\',\{\}]+", "", "ALL");
					local.ret = ReReplace(local.ret, "[\s|\r\n?|\n]+", ",", "ALL");
					local.ret = listDeleteDuplicates(local.ret);
					if ( StructKeyExists(arguments, 'metaKeywordsToIgnore') ) {
						local.ret = listDelete(arguments.metaKeywordsToIgnore, local.ret);
					}
					local.ret = HtmlEditFormat(lcase(trim(local.ret)));
				}
			}
			variables.instance.metaKeywords = local.ret;
		}
	}


	public void function setCustomSummary(
		string customSummary=''
		, string str=''
		, numeric count=26
	) {
		var local = {};
		if ( Len(trim(arguments.customSummary)) ) {
			variables.customSummary = arguments.customSummary;
		} else {
			local.str = arguments.str;
			local.count = val(arguments.count);
			if ( len(trim(local.str)) ) {
				local.str = $.stripHTML(local.str);
				local.str = REReplace(local.str, "[\s|\r\n?|\n]+", " ", "ALL");
				javaArray = CreateObject("java","java.util.Arrays");
				wordArray = javaArray.copyOf(local.str.Split( " " ), local.count);
				local.str = ArrayToList(wordArray, " ");
			}
			variables.customSummary = trim(local.str);
		}
	}

	public any function getAllValues() {
		return getProperties();
	}

	public any function getProperties() output=false {
		var local = {};
		local.properties = {};
		local.data = getMetaData(this).properties;
		for ( local.i=1; local.i <= ArrayLen(local.data); local.i++ ) {
			local.properties[local.data[local.i].name] = Evaluate('get#local.data[local.i].name#()');
		};
		return local.properties;
	}

}