BugSquasher
===========
Not beautiful, but very functional.

Jira plugin for iOS
===========
- Overwrite the volume buttons to allow users/qa to easily log issues
- Login to jira handled
- Automagiaclly adds system log files to the ticket using ASL
- Attach screen shots from your device to the ticket.
- Version no included in the ticket
- Set title and description through the plugin
- Runs when DEBUG flag is set


Setup
===========
Add the following line to app delegate 

[[JDBugSquasher sharedInstance]setupWithBaseApiUrl:@"https://mttnow.atlassian.net/rest/api/latest/" andProjectKey:@"TEST"];

rest endpoint and project id(case sensitive) are just needed
