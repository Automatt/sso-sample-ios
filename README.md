# sso-sample-ios

This sample demonstrates signin using SafariViewController by implementing the following steps:

1. Application opens SafariViewController to correct URL to trigger log in flow
2. Server presents an HTML log in screen in the SVC, and the user fills it out
3. Upon success, server returns a redirect to a custom url scheme ("sso-sample://oauth/result")
4. Application receives an event for this custom scheme in AppDelegate
5. Application retreives session token from url parameters, stores token
6. Application confirms the session is valid and dismisses SafariViewController

On subsequent log in attempts, the server will notice the valid session and skip the login form, returning the success url immediately.
