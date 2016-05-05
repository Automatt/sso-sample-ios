# sso-sample-ios

This sample demonstrates signin using SafariViewController by implementing the following steps:

1. Application opens SafariViewController to correct URL to trigger log in flow
2. Server presents an HTML log in screen in the SVC, and the user fills it out
3. Upon success, server returns a redirect to a custom url scheme ("sso-sample://oauth/result")
4. Application receives an event for this custom scheme in AppDelegate
5. Application retreives security token from url parameters
6. Application establishes a valid session using the security token
6. With a valid session, Application dismisses SafariViewController

On subsequent log in attempts, the application must confirm that it's local session is valid and SSO again if not.
