MuraMetaGenerator
Author: Steve Withington

HOW DO I USE THIS?
On the plugin's Settings page, make sure you select the site(s) you wish to have your Meta Keywords and Meta Descriptions auto-generated.

Also, in the 'Meta Keywords to Ignore' TextArea, enter a comma-separated list of keywords you do NOT wish to include in your listing of keywords. A generic listing of keywords has been entered with words such as 'a,an,and,the' and so forth. If you wish to index these common words (even though search engines usually ignore them anyway), then simply leave this field blank.

Most Mura installations use a file located at /{siteID}/includes/themes/{themeName, i.e., 'merced'}/templates/inc/html_head.cfm. In this file, by default the following lines of code are typcially found:

<meta name="description" content="#HTMLEditFormat(renderer.getmetadesc())#" />
<meta name="keywords" content="#HTMLEditFormat(renderer.getmetakeywords())#" />

You can either leave these lines of code in place or simply remove them if using this plugin.

HOW DOES THIS WORK?
If you already have a Description and/or Keywords entered via the 'Meta Data' tab when adding and/or editing an existing page, then the values entered there will be used. Otherwise, the MuraMetaGenerator™ will analyze the page title, and primary content of the page to automatically generate unique keywords and a description.
Why Should I Use This?

There could be a number of reasons why someone would want to use MuraMetaGenerator™. One of the best reasons is that most Authors and Editors either don't have the time and/or the knowledge of what information to put in these fields to begin with.

Also, since search engines change their algorithms daily and actually rely less and less on meta keywords and meta descriptions, why not spend your time going through the actual content of your pages and making sure your content contains the information you want indexed by search engines? After all, MuraMetaGenerator™ derives its information based on the actual page content which means you'll be following 'White Hat' Search Engine Optimization (SEO) techniques so your search engines rankings will most likely grow organically over time.

So go ahead and let MuraMetaGenerator do it for you!
Requirements

    ColdFusion 8+ or Railo 3.1.2+ (this has NOT been tested on Open BlueDragon)
    Mura 5.2+

NEED HELP?
Catch me on the Mura CMS forums, contact me through my site at www.stephenwithington.com, or via email at steve [at] stephenwithington [dot] com.

Cheers!