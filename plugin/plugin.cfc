<!---

This file is part of MuraMetaGenerator TM
(c) Stephen J. Withington, Jr. | www.stephenwithington.com

CAREFULLY READ THE ENCLOSED LICENSE AGREEMENT (plugin/license.htm). BY USING THIS SOFTWARE, YOU ARE CONSENTING TO BE BOUND BY AND ARE BECOMING A PARTY TO THIS AGREEMENT. IF YOU DO NOT AGREE TO ALL OF THE TERMS OF THIS AGREEMENT, THEN DO NOT USE THIS SOFTWARE, AND, IF APPLICABLE, RETURN THIS PRODUCT TO THE PLACE OF PURCHASE FOR A FULL REFUND.

--->
<cfcomponent output="false" extends="mura.plugin.plugincfc">

	<cfscript>
		variables.config 		= '';
		variables.packageAuthor	= 'Stephen J. Withington, Jr. | www.stephenwithington.com';
		variables.packageDate 	= createDateTime(2010,04,16,09,0,0);
		variables.packageName	= 'MuraMetaGenerator';
	</cfscript>
	
	<cffunction name="init" returntype="any" access="public" output="false">
		<cfargument name="config"  type="any" default="" />
		<cfscript>
			variables.config = arguments.config;
		</cfscript>
	</cffunction>
	
	<cffunction name="install" returntype="void" access="public" output="false">
		<cfscript>
			var local = structNew();
			// need to check and see if MuraMediaPlayer is already installed ... if so, then abort!
			local.moduleid = variables.config.getModuleID();
			if ( val(getInstallationCount()) neq 1 ) {
				variables.config.getPluginManager().deletePlugin(local.moduleid);
			};
			application.appInitialized = false;
		</cfscript>
	</cffunction>
	
	<cffunction name="update" returntype="void" access="public" output="false">
		<cfscript>
			var local = structNew();
			application.appInitialized = false;
		</cfscript>
	</cffunction>
	
	<cffunction name="delete" returntype="void" access="public" output="false">
		<cfscript>
			application.appInitialized = false;
		</cfscript>
	</cffunction>

	<!--- ********************** private *********************** --->
	<cffunction name="getInstallationCount" returntype="any" access="private" output="false">
		<cfscript>
			// i check to see if this plugin has already been installed. if so, i delete the new one.
			var qoq 	= ''; // query of queries don't like to be named 'local.qoq'
			var rs 		= variables.config.getConfigBean().getPluginManager().getAllPlugins();
			var local 	= structNew();
			local.ret	= 0;
		</cfscript>

		<cfif rs.recordcount>
			<cfquery name="qoq" dbtype="query">
				SELECT *
				FROM rs
				WHERE package = <cfqueryparam value="#variables.packageName#" cfsqltype="cf_sql_varchar" maxlength="100" />
			</cfquery>
			<cfscript>
				if ( qoq.recordcount gt 0 ) {
					return val(qoq.recordcount);
				};
			</cfscript>
		<cfelse>
			<cfreturn local.ret />
		</cfif>
	</cffunction>

</cfcomponent>