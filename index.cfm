<cfsilent><cfscript>
/**
* 
* This file is part of MuraMetaGenerator TM
*
* Copyright 2010-2015 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
</cfscript></cfsilent>
<cfsavecontent variable="body"><cfoutput>
<h2>MuraMetaGenerator&trade;</h2>
<p><em>Version: #pluginConfig.getVersion()#<br />
Author: <a href="http://stephenwithington.com" target="_blank">Steve Withington</a></em></p>

<h3>How Do I Use This?</h3>
<p>On the plugin's Settings page, make sure you select the site(s) you wish to have your Meta Keywords and Meta Descriptions auto-generated.</p>
<p>Also, in the 'Meta Keywords to Ignore' TextArea, enter a comma-separated list of keywords you do NOT wish to include in your listing of keywords. A generic listing of keywords has been entered with words such as 'a,an,and,the' and so forth. If you wish to index these common words (even though search engines usually ignore them anyway), then simply leave this field blank.</p>
<p>Most Mura installations use a file located at <strong>/{siteID}/includes/themes/{themeName, e.g., 'MuraBootstrap3'}/templates/inc/html_head.cfm</strong>. In this file, by default the following lines of code are typcially found:</p>
<div class="notice">
<p> &lt;meta name=&quot;description&quot; content=&quot;##HTMLEditFormat(renderer.getmetadesc())##&quot;&gt;<br>
&lt;meta name=&quot;keywords&quot; content=&quot;##HTMLEditFormat(renderer.getmetakeywords())##&quot;&gt;</p>
</div>
<p>You can either leave these lines of code in place or simply remove them if using this plugin.</p>

<h3>How Does This Work?</h3>
<p>If you already have a Description and/or Keywords entered via the 'Meta Data' tab when adding and/or editing an existing page, then the values entered there will be used. Otherwise, the MuraMetaGenerator&trade; will analyze the page title, and primary content of the page to automatically generate unique keywords and a description.</p>

<h3>Why Should I Use This?</h3>
<p>There could be a number of reasons why someone would want to use MuraMetaGenerator&trade;. One of the best reasons is that most Authors and Editors either don't have the time and/or the knowledge of what information to put in these fields to begin with.</p>
<p>Also, since search engines change their algorithms daily and actually rely less and less on meta keywords and meta descriptions, why not spend your time going through the actual content of your pages and making sure your content contains the information you want indexed by search engines? After all, MuraMetaGenerator&trade; derives its information based on the actual page content which means you'll be following 'White Hat' Search Engine Optimization (SEO) techniques so your search engines rankings will most likely grow organically over time.</p>
<p>So go ahead and let MuraMetaGenerator&trade; do it for you!</p>

<h3>Tested With</h3>
<div class="notice">
  <ul style="padding:0 2em;">
  	<li>ColdFusion 11</li>
    <li>Lucee 4.5</li>
  	<li>Mura 6.2</li>
  </ul>
</div>

<h3>Questions / Issues?</h3>
	<p>Visit the project at <a href="https://github.com/stevewithington/MuraMetaGenerator" target="_blank">https://github.com/stevewithington/MuraMetaGenerator</a></p>
</cfoutput>
</cfsavecontent>
<cfoutput>
	#$.getBean('pluginManager').renderAdminTemplate(
    body=body
    , pageTitle=''
  )#
</cfoutput>
