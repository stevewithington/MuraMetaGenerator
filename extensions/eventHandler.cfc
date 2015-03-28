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
			application[variables.settings.package] = this;
		}

		set$(arguments.$);
	}

	public any function onBeforeContentSave(required struct $) {
		set$(arguments.$);

		var newBean = arguments.$.event('newBean');
		var oldBean = arguments.$.event('contentBean');

		var error = '';
		var errors = {};
	}

	public any function onRenderEnd(required struct $) {
		set$(arguments.$);

		doMeta();
	}


	// Helpers		******************************************************************

	public any function doMeta(boolean debug=false) {
		// remove meta keywords and description tags
		var resp = stripMeta($.event('__MuraResponse__'));
		var metaDesc = '<meta name="description" content="#esapiEncode('html_attr', getMetaDesc())#" />';
		var metaKeywords = '<meta name="keywords" content="#esapiEncode('html_attr', getMetaKeywords())#" />';

		resp = ReplaceNoCase(resp, '<head>', '<head>' & metaDesc & metaKeywords);

		$.event('__MuraResponse__', resp);
		return arguments.debug ? local : true;
	}

	public any function stripMeta(required string str) {
		return ReReplaceNoCase(arguments.str, '(?i)<meta name=[''"](description|keywords)[''"].*?>', '', 'all');
	}

	public any function listDeleteDuplicates(string list='', string delimiter=',', boolean debug=false) {
		var i = 0;
		var newList = '';

		if ( Len(arguments.list) ) {
			var arr = ListToArray(arguments.list, arguments.delimiter);
			for ( i=1; i <= ArrayLen(local.arr); i++ ) {
				if ( !ListFindNoCase(newList, arr[i], arguments.delimiter) ) {
					newList = ListAppend(newList, arr[i], arguments.delimiter);
				}
			}
		}

		return arguments.debug ? local : newList;
	}

	public any function listDelete(string strToRemove='', string list='', string delimiter=',', boolean debug=false) {
		var i = 0;
		var newList = '';

		if ( Len(arguments.strToRemove) && Len(arguments.list) ) {
			var arr = ListToArray(arguments.list, arguments.delimiter);
			for ( i=1; i <= ArrayLen(arr); i++ ) {
				if ( !ListFindNoCase(arguments.strToRemove, arr[i], arguments.delimiter) ) {
					newList = ListAppend(newList, arr[i], arguments.delimiter);
				}
			}
		}

		return arguments.debug ? local : newList;
	}


	// MISC.		******************************************************************

	public any function getMetaDesc() {
		return Len(Trim($.content('metaDesc'))) ? Trim($.content('metaDesc')) : getSummary();
	}

	public any function getMetaKeywords() {;
		var str = '';

		if ( Len(Trim($.content('metaKeywords'))) ) {
			return Trim($.content('metaKeywords'));
		}

		if ( Len($.setDynamicContent($.content('body'))) ) {
			str = $.getBean('utility').stripTags($.setDynamicContent($.content('body')));
			str = $.content('title') & ' ' & str;
			str = Trim(ReReplace(str, '<[^>]*>', ' ', 'all'));
			str = ReReplace(str, '\s{2,}', ' ', 'all');
			str = ReReplace(str, '&[^;]+?;', '', 'all');
			str = ReReplace(str, '[^a-zA-Z0-9_\-\s]', '', 'all');
			str = ArrayToList(ListToArray(str, ' ')); // fix list
			str = listDeleteDuplicates(str);

			var ignore = $.getPlugin(variables.settings.pluginName).getSetting('metaKeywordsToIgnore');
			if ( Len(ignore) ) {
				str = listDelete(strToRemove=ignore, list=str);
			}
		}

		// var cBean = $.getBean('content').loadBy(contentid=$.content('contentid'));
		// cBean.setValue('metaKeywords', str).save();

		return Trim(str);
	}

	public any function getSummary(numeric numberOfWords=26) {
		var wordCount = Val(arguments.numberOfWords);
		var str = $.content('title') & ': ' & $.setDynamicContent($.content('body'));

		if ( Len(Trim(str)) ) {
			str = $.getBean('utility').stripTags(str);
			str = Trim(ReReplace(str, '<[^>]*>', ' ', 'all'));
			str = ReReplace(str, '\s{2,}', ' ', 'all');
			str = ReReplace(str, '&[^;]+?;', '', 'all');
			str = REReplace(str, '[\s|\r\n?|\n]+', ' ', 'all');

			try {
				var javaArray = CreateObject('java', 'java.util.Arrays');
				var wordArray = javaArray.copyOf(str.Split(' '), wordCount);
				str = ArrayToList(wordArray, ' ');
			} catch(any e) {
				// no access to java :(
				var wordArray = ListToArray(str, ' ');
				if ( ArrayLen(wordArray) > wordCount ) {
					for ( var i=ArrayLen(wordArray); i > wordCount; i-- ) {
						arrayDeleteAt(wordArray,i);
					}
				}
				str = ArrayToList(wordArray, ' ');
			}
		}

		// var cBean = $.getBean('content').loadBy(contentid=$.content('contentid'));
		// cBean.setValue('metaDesc', str).save();

		return Trim(str);
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