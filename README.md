# sso-sample-ios

This sample demonstrates how to use SafariViewController as part of an SSO implementation.

Familiarity with OpenID Connect or SAML is assumed.  Implementing these are left as an exercise to the user.

An working implementation would follow these steps:

1. Application retreives URL to use from NSUserDefaults, if it is present
2. Application opens SafariViewController to the correct URL to trigger log in flow
3. Server presents an HTML log in screen in the SVC, and the user fills it out
4. Upon success, server returns a redirect to a custom url scheme ("sso-sample://oauth/result")
5. Application receives an event for this custom scheme in AppDelegate
6. Application retreives security token from url parameters
7. Application establishes a valid session using the security token
8. With a valid session, Application dismisses SafariViewController

On subsequent log in attempts, the application must confirm that it's local session is valid and sign in again if not.
