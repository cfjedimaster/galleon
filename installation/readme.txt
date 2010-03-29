LICENSE 
Copyright 2006, 2007, 2008, 2009, 2010 Raymond Camden

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.


Welcome to Galleon. This is an open-source forums application for ColdFusion. For installation instructions, please
read the word documentation. For folks who are upgrading, BE SURE to read the notes below. It details
what changes in each release.

This application was created by Raymond Camden (ray@camdenfamily.com). 
You may use this application as you will. I ask that you link back to my blog (http://www.coldfusionjedi.com).

If you find this app worthy, I have a Amazon wish list set up (www.amazon.com/o/registry/2TCL1D08EZEYE ). 
Gifts are always welcome. ;)



---- LATEST VERSION ----
2.2.3 (March 19, 2010)

NOTE: A new table has been added, privatemessages. Please ensure you add this table.

/admin/gen_stats.cfm, messages.cfm, messages_edit.cfm, settings.cfm, stats_charts.cfm, threads.cfm, users.cfm
Support for performance updates.

/cfcs/message.cfc, settings.ini.cfm, thread.cfc, user.cfc
Support for performance updates - added allowpms to settings to allow private messages

/images/btn_send.gif -> New image

/pagetemplages/admin_header.cfm, main_header.cfm
Small nav changes

/stylesheets/style.css
Misc change

/messages.cfm, profile.cfm, pm.cfm, pms.cfm, sendpm.cfm, threads.cfm
Changes in regard to messaging/performance.

/tags/datatablenew.cfm -> New tag

Thanks to Nick Hill for updating the Access MDB.

---- ARCHIVED UPDATES ----
2.2.9.004 (March 5, 2010)
/login.cfm - thanks to use rucky544 for noticing a bug in the send password reminder 
/cfcs/settings.ini.cfm - Version #

2.2.9.003 (March 2, 2010)
/threads.cfm - thanks to user pasorens for noticing broken thread sorting
/cfcs/settings.ini.cfm - Version #

2.2.9.002 (February 25, 2010)
/cfcs/mailservice.cfc - Small fix to mailservice by J.J. Blodgett
/cfcs/settings.ini.cfm - Version #

2.2.9.001 (January 21, 2010)
/cfcs/forum.cfc - Fix to updatestats to handle bad dates
/cfcs/user.cfc - Fixes a bug where a user subscribed to a thread that goes inactive would get an error on the Profile page
/cfcs/settings.ini.cfm - Version #

2.2.9 (November 17, 2009)
/admin/conferences_edit.cfm - Fixes an issue where security settings wouldn't stick if you had an error.
/admin/forums_edit.cfm - If you have no conferences, we tell you and prevent you from creating a forum.
/Application.cfm - Loads the mailService component into the App scope.
/cfcs/mailservice.cfc - Handles all mail operations - allows for mail servers/usernames/password. Thanks to James Edmunds for the inspiration.
/cfcs/message.cfc - Makes use of mail service. Emails to subscribers include plain text and HTML versions.
/cfcs/objectfactory.cfc - support for mailservice
/cfcs/settings.ini.cfm - new attributes for mailserver, mailusername, mailpassword
/cfcs/user.cfc - support for mail service
/error.cfm - will notice if it can't send email
/tags/pagination.cfm - fixes alt/title tags
/stylesheets/admin_style.css - fix by Chaz Jachimski
/messages.cfm - Just removed code that was commented out.
/includes/udf.cfm - update email validation to support +
/login.cfm - Now if there is a db error, we email it. Makes use of mail service.

2.2.8.001 (September 17, 2009)

/cfcs/settings.ini.cfm - version
/messages.cfm, /message_edit.cfm, /newpost.cfm, /profile.cfm -> All files now upload to system TEMP directory. All files are named with UUIDs. Attachments store original file name so downloads are nice.
/attachment.cfm - use the nicer download name

2.2.8 (September 15, 2009)
/admin/Application.cfm - minor edit to remove a cfabort that wasn't necessary.
/cfcs/Application.cfm - simple bouncer
/cfcs/settings.ini.cfm - version
/images/avatars/Application.cfm - simple bouncer
/includes/Application.cfm - ditto
/message_edit.cfm - typo fix
/messages.cfm - typo fix
/newpost.cfm - typo fix
/pagetemplates/Application.cfm - simple bouncer
/profile.cfm - handle an edge case where image.cfc threw an error
/tags/application.cfm - simple bouncer

2.2.7 (July 23, 2009)
/cfcs/image.cfc - CF9 compat
/tags/pagination.cfm - if you have more than ten pages, switch to a JS-required drop down
/search.cfm - add an ID to form so auto select actually works
/threads.cfm, /style.css - fix a wrap issue - thanks to Chaz Jachimski of Full City Media

2.2.6 (June 19, 2009)
/includes/udf.cfm - Code that generates header links now adds nofollow.
/syntax.cfm - small fix to image url, thanks to Jeff McNaughton

2.2.5 (May 20, 2009)
/stylesheets/style.css - Some bad CSS here blocked the rendering of UL/LI in message posts.
/login.cfm - htmlEditFormat the result of a login
/cfcs/settings.ini.cfm - version

2.2.4 (January 26, 2009)
/admin/conferences_edit.cfm + forums_edit.cfm -> Both files would 'forget' what Rights you picked on error
/cfcs/settings.ini.cfm - just the version
/cfcs/user.cfc - oracle fix
/messages.cfm - forgot to enable CF code coloring

2.2.3 (July 9, 2008)
/cfcs/user.cfc - If rooturl doesn't have / at the end, fix the url in emails, see last change
/cfcs/settings.ini.cfm - just the version

2.2.2 (June 5, 2008)
/cfcs/message.cfc - If rooturl doesn't have / at the end, fix the url in emails.
/cfcs/settings.ini.cfm - just the version
/admin/settings.cfm - remove isValid - it was breaking cf6 compat

2.2.1 (May 22, 2008)
/cfcs/message.cfc - var scope, and fix to let people in groups with canpost but not forummembers
/cfcs/objectfactory.cfc - case issue in Linux
/cfcs/permission.cfc, thread and user - var scope issues
/cfcs/settings.ini.cfm - just the version

2.2 (May 15, 2008)

The major feature of this update is the ability for authors to edit their own posts. This was submitted by Todd Rafferty. 

/cfcs/message.cfc - support for message edit
/message_edit.cfm - ditto
/messages.cfm - ditto

I also fixed a security issue involving edit rights

/cfcs/settings.ini.cfm - default encryption to false, version

2.1 (May 9, 2008)
/cfcs/conference.cfc, permission.cfc, rank.cfc and user.cfc modified to support Oracle. Thanks go to James Holmes. This is NOT documented yet,
but you can specify oracle as the DB type now. Once folks test and confirm it's cool, I'll add it documentation.

/cfcs/conference.cfc - fix a bug where if you delete the last thread of a conference, an error is thrown.

2.014 (April 30, 2008)
/stylesheets/style.css - fix to blockquote style, thanks to zomigi (user on my forums)
/cfcs/message.cfc - for my email fix, I accidentally only did it to the Admin email, not the User email. Thanks to Jonas Eriksson
/cfcs/settings.ini.cfm - just the version

2.013 (April 24, 2008)
/admin/users_edit.cfm - change to support note below
/cfcs/user.cfc - correctly handle profile saves not messing up the passwords
/cfcs/message.cfc - when we email users, use #last so that their link goes to the most recent page, also double check to include / in url
/cfcs/settings.ini - version
/installation/mysql.sql - the sql file accidentally had conference data in it
/login.cfm, /messages.cfm - minor CSS fix
/profile.cfm - related to profile fix above

2.012 (March 28, 2008)
markitup rich text editor by http://markitup.jaysalvat.com/home/
Support added by Todd Rafferty.

Multiple files updated.

2.011 (February 26, 2008)
/Application.cfm - Minor fix to my settings change.
cfcs/settings.ini.cfm - just version

2.010 (February 25, 2008)
/cfcs/galleon.cfc - I had to mod it a bit to work with some settings that can't be in the ini file.
/cfcs/message.cfc - fix bug where we threw an error deleting a thread with messages with attachments
/cfcs/objectfactory.cfm - now we pass in a few settings, and add them to the settings bean
/Application.cfm - support for the above

/cfcs/settings.ini.cfm - version
/messages.cfm - subscribe defaults to false, and we use a check box now
/newpost.cfm - ditto

2.009 (December 20, 2007)
/messages.cfm - format the sig a bit nicer
/tags/DP_ParseBBML.cfm updated again
/admin/messages.cfm - handle pagination better
/admin/threads.cfm - ditto
/admin/users.cfm - ditto

2.008 (November 29, 2007)
/stylesheets/style.css - fix for P
/messages.cfm - a few changes: When you post, you end up on the page your post was posted to. I also put pagination
at the bottom as well as the top.
/cfcs/settings.ini.cfm - version
/tags/DP_ParseBBML.cfm - saved in UTF-8, fixes weird format issue on some machine

2.007 (November 21, 2007)
/stylesheets/admin_style.css - another CSS fix. Thanks to Chaz again at Full City Media
/admin/users_edit.cfm - When using encrypted passwords, do NOT display password in form, and warn the admin 
/cfcs/user.cfc - when saving a user, hash password if encrypting
/cfcs/settings.ini.cfm - version

2.006 (November 19, 2007)
/cfcs/forum.cfc - Access fix
/cfcs/thread.cfc - ditto
/cfcs/settings.ini.cfm - version
/installation/to2/IMPORTANT NOTE.txt - note about missing avatar column in PDF
/installation/forums.mdb - updated Access db

2.005 (November 10, 2007)
/forums.cfm - new link to last page
/index.cfm - ditto 
/threads.cfm - ditto
/messages.cfm - new support for Last page
/rss.cfm - checks security on messages to ensure you can view, thanks to Scott P for finding this
/cfcs/conference.cfc - mod to get latest posts

2.004 (November 7, 2007)
Hi, this is the "Someone please pick up the Orange Box on the wishlist" edition:
/cfcs/settings.ini.cfm - just changed the version
/stylesheets/admin_style.css - yet another IE7 CSS fix. I love IE7. Really. Thanks to Chaz again at Full City Media

2.003 (October 29, 2007)
/settings.cfm - IE fix.
/cfcs/settings.ini.cfm had an odd perpage value. Also changed version.
/tags/pagination.cfm - bug in pagination, fix by Scott Pinkston.
/Application.cfm - Remove BlueDragon mod (not needed in latest BD, thanks to Vince B for letting me know!)

2.002 (October 20, 2007)
/admin/* - All of the admin files were updated (well, not all, but most) to deal with IE and other
display issues when items were updated or deleted.
/tags/datatable.cfm, pagination.cfm - related to above. pagination.cfm also had bad image urls
/stylesheets/admin_style.css - ditto above again
/pagetemplates/main_header.cfm - small tweak to the top nav
/cfcs/user.cfc:
	addGroup was broken in mysql
	deleteGroup didn't exist (oops)
	encryptpasswords wasn't being passed in as a setting
/cfcs/conference.cfc:
	When updating, don't assume a date exists in the db. It should - I believe this bug
	only fired for me do to my testing, but it won't hurt.
/cfcs/settings.ini.cfm - just the version

Zip had some SVN crap in it. Hopefully cleaner now.

2.001 (October 15, 2007)
/stylesheets/admin_style.css - Fix to CSS used for filter
/Application.cfm - fix for IE login issue
/cfcs/settings.ini.cfm - Version

2.0 (October 12, 2007)
Please read the Migration Guide in the to2 folder. This guide covers everything you need to do.

1.7.012 (May 1, 2007)
/admin/users_edit.cfm - Do not htmleditformat the password or email address.
/cfcs/settings.ini.cfm - Version 


1.7.012 (May 1, 2007)
/images/gravatar.gif - used for people who don't have gravatar accounts
/cfcs/message.cfc - use isTheUserInAnyRole
/newpost.cfm - ditto above
/messages.cfm - ditto above
/message_edit.cfm - ditto above
/thread.cfc - ditto above
/Application.cfm - case fix for the factory 
/cfcs/utils.cfc - Changed udf isUserInAnyRole to isTheUserInAnyRole. This was not done for any special purpose. Really.
/cfcs/settings.ini.cfm - changed a few values for my own testing, but the real change is the version 

1.7.011 (March 2, 2007)
/rss.cfm - Title wasn't dynamic
/cfcs/settings.ini.cfm - just a version change

1.7.010 (February 26, 2007)
/admin/users.cfm, threads.cfm, and messages.cfm support filtering
/tags/datatable.cfm - ditto above.

/messages.cfm - use renderMessage, not render (BlueDragon fix)
/login.cfm - param a few form fields I assumed existed
/Application.cfm - Use Factory - all factory code written by Rob Gonda
/includes/udf.cfm - renamed querysort udf (BD fix)
/stylesheets/style.css - style blockquote

Please note all CFCs updated to use the factory. I was lazy and didn't update the top headers to reflect the new dates.
/cfcs/message.cfc - use renderMessage, not render (BlueDragon fix)
/cfcs/message.cfc - When emailing, remove [code], [img] tags. I keep the insides, not the tags.
/cfcs/message.cfc - Add quote
/cfcs/settings.ini.cfm - Version only.

/install/mysql.sql - updated to use more indexes.

1.7.009 (December 18, 2006)
/messages.cfm - lowercase the hash for gravatar
/cfcs/settings.ini.cfm - Version only.

1.7.008 (December 8, 2006)
/admin/gen_stats.cfm - I changed how I got stats. It breaks encapsulation, but it is 10 times faster.
/admin/stats_charts.cfm - ditto above
/cfcs/message.cfc - Support for [img]. Idea taken from Rick Root's CFMBB
/cfcs/settings.ini.cfm - Version only.

1.7.007 (December 5, 2006)
/cfcs/message.cfc - Slight change to emails sent out - it now includes the username
/cfcs/settings.ini.cfm - Version only.

1.7.006 (November 16, 2006)
/cfcs/message.cfc - fix two bugs related to deleting of messages
/cfcs/settings.ini.cfm - Version only.
/Attachment.cfm - fix code that figures out attachment folder 

1.7.005 (November 14, 2006)
/cfcs/settings.ini.cfm - Version only.
/message_edit.cfm - error when attachments weren't enabled

1.7.004 (November 9, 2006)
/cfcs/settings.ini.cfm - Version only.
/message.cfc - In the past, if the sendOnPost person was subscribed to a thread, s/he would get 2 emails per post. Now you only get one.
I also tweaked the message sent to subscribers a bit. I added the Conference/Forum/Thread Name to the body.
/pagetemplates/main_footer.cfm - Changed footer link to riaforge.

1.7.003 (November 6, 2006)
/cfcs/settings.ini.cfm - Version only.
/user.cfc - if no confirmation required, set confirmation to 1
/message.cfc - I broke activateURL support, fixed now 

1.7.002 (November 6, 2006)
/admin/gen_stats.cfm - added &nbsp;s to a few rows so they show nicer in Firefox when the cells are empty.
/cfcs/settings.ini.cfm - Default to NOT encrypt passwords so default DB scripts work.
/newpost.cfm - Error if no attachment
/messages.cfm - ditto

1.7.001 (November 5, 2006)
/admin/conferences_edit.cfm + forums_edit.cfm changed textareas back to test
/cfcs/conferences+forums - varchar not longvarchar for description

DB scripts updated for above, also, I forgot to add the signature column

/cfcs/forums.cfc - bug in adding new forum

1.7 (November 3, 2006)

DB Changes:
forums - add attachments as a bit
messages - add attachment, filename as varchar/255
 
/admin/forums.cfm: Show attachments column
/admin/forums_edit.cfm: Allow attachments
/admin/messages_edit.cfm: Show and allow removal of attachments
/cfcs/forum.cfc - Attachment support
/cfcs/message.cfc - Attachment support, render of message entries moved in
/cfcs/settings.ini.cfm: New properties
	encryptpasswords - if true, encrypt passwords in the db and don't allow password reminders
	allowgravatars - if true, show gravatars
	safeExtensions - list of safe file extensions for attachments
/cfcs/utils.cfc - Some render functions moved out of udfs file and into here.
/cfcs/user.cfc - password encryption, signature support
/includes/udf.cfm - moved some funcs to utils.cfc
/stylesheets/style.css - a few new styles 
/tags/datatable.cfm - minor change
/tags/pagination.cfm - typo fix
/attachment.cfm - new file
/login.cfm - handle encryption and auto focus
/message_edit.cfm - attachment support
/messages.cfm - gravatar, sigs, attachments
/newpost.cfm - attachment support
/profile.cfm - signature support, support updating email
/search.cfm - js fix by user
/install/ All sql install files
/install/unsupported/ folder added. Has Oracle mods for older version.
/messages.cfm, newpost.cfm - show renderHelp
/cfcs/message.cfc - add renderHelp


1.6.2 (August 4, 2006)
/forums.cfm, /index.cfm, /login.cfm, /message_edit.cfm, /messages.cfm, /newpost.cfm, /profile.cfm, /search.cfm, threads.cfm - Show title

Oracle version is now in the unsupported version. 
1.6.1 (August 3, 2006)
Typo in SQLServer install script. Thanks Josh Rogers. No version change.

1.6.1 (July 27, 2006)
/install/ - All DB scripts updated. The size of the name fields for 
conferences, forums, threads, and messages are now all set to a max
of 255. There was also a bug in the mysql script that limited the size
on one field to a low number.

/admin/conferences_edit, forums_edit, threads_edit, messages_edit - 
all had the sizes removed from name fields.

/cfcs/conferences+messages+forums+threads.cfc - support for new size
and new email of full messages. Also added wrap to emails.

/cfcs/settings.ini.cfm - added fullemails key

/messages.cfm + /newposts.cfm - updated with new sizes

1.6.002 (July 21, 2006)
DB install scripts had a bug.
/cfcs/settings.ini.cfm - just a version change

1.6.001 (July 17, 2006)
/admin/user_edit.cfm - Bug when requireconfirmation was false
/admin/Application.cfm, /Application.cfm - better "is admin file" checking. 
/cfcs/settings.ini.cfm - Just a version change

1.6 (final release July 12, 2006)

DB CHANGES: Add confirmed as a bit property to the users table. If you wish to use confirmations,
you must write a sql query to update all old users and mark them confirmed.

FILE CHANGES: Note the updated files below. Most importantly, you need to rename settings.ini to 
settings.ini.cfm and add requireconfirmation, title fields.

/admin/users.cfm - show confirmation
/admin/users_edit.cfm - show confirmation, require one group
/cfc/conference.cfc, forum.cfc, thread.cfc - show last user
/cfc/message.cfc - fix saving for moderators, make title dynamic
/cfc/user.cfc - confirmation support and dynamic title
/cfc/galleon.cfc - use a cfm file
/includes/udf.cfm - various
/pagetemplates/main_* - Support dynamic title, show version
/stylesheets/style.css - minor change to footer
/tags/datatabase.cfm - confirmation support
/tags/breadcrumbs.cfm - minor layout mod
/Application.cfm - Better admin check, logout fix
/confirm.cfm - new file
/threads.cfm - show last user
/search.cfm - auto focus on search box
/login.cfm - require confirmation changes
/index.cfm, /forums.cfm - show last user
/installation - Word doc updated, PDF version added, and SQL install files updated

1.6 (beta released July 6, 2006)
These notes are NOT complete. Install instructions NOT updated. File headers NOT updated.
Please add "confirmed" as a bit property to the users table. Better release notes to ship in the 
final 1.6 version.

1.5 (no new version number) (released 11/22/05)
/cfcs/conference.cfc - restrict length of search term and delete subscription clean ip
/cfcs/forum.cfc - ditto
/cfcs/message.cfc - just search term limit
/cfcs/thread.cfc - search limit + sub fix (as conference.cfc)
/pagetemplates/* All updated to turn off cfoutput only, and changed footer
/stylesheets/style.css - added style for footer a
/tags/pagination.cfm - another IE bug fix
/search.cfm - limit size of searchstring
/messages.cfm - allow bigger titles 
/install/ SQL scripts updated to reflect bigger message title.

1.5 (no new version number) (released 10/10/05)
/pagetemplates/main_header.cfm - quick mod to login link on top
/members.cfm - fixes for IE bug, and prevent message add if not logged in

1.5 (no new version) (released 10/6/05)
/cfcs/user.cfc - fixed bug with subscribe 
/pagetemplates/main_header.cfm

1.5 (released 9/15/05)
/cfcs/conferences.cfc - getConferences returns threadid of last post
/cfcs/forum.cfc - getForums returns threadid of last post
/includes/udf.cfm - udfs in support of sorting mainly
/installation/mysql.sql - missing ; at end
/stylesheets/style.css - change to support sorting
/Application.cfm - support for sorting
/forums.cfm - ditto
/index.cfm - ditto 
/messages.cfm - ditto
/threads.cfm - ditto

The last 4 files also had a bug fix applied to paging, and links to last posts added.

/Application.cfm - use an error template, error.cfm

1.4.1  (released 9/9/05)
Admin pages expanded again to give more room. More information shows up as well. So for example, you see in the messages table the thread, forum, 
and conference the message belongs to. 

/admin/conferences.cfm - changed columns
/admin/forums.cfm - ditto
/admin/messages.cfm - ditto
/admin/threads.cfm - ditto
/cfcs/message.cfm - new cols return on getAll
/cfcs/settings.ini - new version
/pagetemplates/admin_header.cfm - small formatting changes
/stysheets/style.css - ditto
/tags/datatable.cfm - sorting added (finally)


1.4 (released 8/29/05)
Unfortunately, I can't really list out the files that have changed since pretty much all files 
have changed. Here are the changes in features:

No need for a mapping.
A new settings.ini property, tableprefix, allows you to specify a prefix in front of each table name.

So what does this mean? Your old table names would have looked like: conferences, threads, etc. If
you needed to put these tables into an existing database, it may conflict with existing tables. Now
you can use table names with a prefix, like galleon_. Update the settings file with this prefix, and
Galleon will use the prefix when performing sql operations.

Default install scripts use table names with galleon_ in front. Default settings.ini file uses this
as a prefix.

Sticky Threads: If a thread is marked as sticky, it will sit on top of the forum.

Ranks: Allows you to give ranks to people based on the number of posts they have created.

Admin - updated the look a tiny bit, and moved some general stats to the default admin home page.



1.3.7 (released 8/9/05)
/rss.cfm - Links in the RSS need to be unique, so added a row counter. Thanks to Tom Thomas
/messages.cfm - Fix typo
/pagetemplates/main_header.cfm - Add Firefox auto-rss. Thanks to Tom Thomas.
/stylesheets/style.css - fix for links in message footer


1.3.6 (released 8/3/05)
/admin/users.cfm and /admin/users_edit.cfm - fixes to bugs related to 1.3.5
/cfcs/user.cfc - ditto above
/pagetemplates/main_header.cfm - Use meta tags
/messages.cfm and /newpost.cfm - refresh user cache on post
/messages.cfm - reworked the bottom link a bit

1.3.5 (released 7/29/05)
This releases changes how subscriptions work. In the past, as a user, you would just say yes or no to getting
email when people post to threads you posted to. Now you have explicit control over what you subscribe to.

You must updated your database. There is a new table, subscriptions.
Also, the users table has removed the "sendnotifications" column.

/profile.cfm, /login.cfm - changes to subscription support
/forums.cfm - pass mode to pagination tag
/messages.cfm, /newport.cfm - subscribe option
/cfc/user.cfc and messages.cfc - changes for subscription
/tags/pagination.cfm - show button
All db scripts updated.


1.3.4 (released 7/15/05)
cfcs/messages.cfc - I pass in the settings now.
cfc/application.cfc renamed to galleon.cfc
stylesheets/style.css - updated with a new style
tags/pagination.cfm - changed rereplace to a nocase version
messages.cfm - links to invidual messages, and hide bogus error msg


1.3.3 (release 6/17/05)
Just changed the Reply link to make it auto go to login if not logged on

1.3.2 (Release April 15, 2005)
Fix in getForums for MS Access in forum.cfc
Minor layout bugs fixed in index.cfm and forums.cfm
When we auto-push in index.cfm, addToken=false

1.3.1 (Released April 8, 2005)
Fixed a bug in page counting: index.cfm, forums.cfm, threads.cfm, messages.cfm 
Removed lastupdated stuff in admin as I'm tired of updating it.

1.3 (Released April 6, 2005)
Msg count and last post in conf/forums

1.2 (Released March 31, 2005)
Re-arranged a bit about you post stuff.
Re-arranged display of posts a bit.
Fixed bad Util call in messages.cfc.
Remember-me functionality.

1.1.1 (Released February 3, 2005)
Fix to conference.cfc getLatestPosts() error for mysql
Update admin/index.cfm with version #.

1.1 (Released February)
Support for mysql, msaccess. Search update


