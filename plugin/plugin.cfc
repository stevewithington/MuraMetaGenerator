/**
* 
* This file is part of MuraMetaGenerator TM
*
* Copyright 2010-2015 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
component accessors=true extends='mura.plugin.plugincfc' output=false {

	// pluginConfig is automatically available as variables.pluginConfig
	include 'settings.cfm';

	public void function install() {
		// Do custom installation stuff
	}
	
	public void function update() {
		// Do custom update stuff
	}

	public void function delete() {
		// Do custom delete stuff
	}

	// access to the pluginConfig should available via variables.pluginConfig
	public any function getPluginConfig() {
		return StructKeyExists(variables, 'pluginConfig') ? variables.pluginConfig : {};
	}

}