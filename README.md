BugSquasher
===========
Not beautiful, but very functional.

Jira plugin for iOS
- Overwrite the volume buttons to allow users/qa to easily log issue
- Login to jira handled
- Automagiaclly adds logging info to the ticket using ASL
- Attach screen shots from your device to the ticket.
- Version no included in the ticket
- Set title and description through the plugin
- Runs when DEBUG flag is set


Setup
Add the following line to app delegate 
-  rest endpoint and project id(case sensitive) are just needed
[[JDBugSquasher sharedInstance]setupWithBaseApiUrl:@"https://mttnow.atlassian.net/rest/api/latest/" andProjectKey:@"TEST"];

