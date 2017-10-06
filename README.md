# DEPRECATED
This SDK has been replaced with a new version which is hosted in another repo.  This SDK may no longer funciton fully.  Please use the new SDK at: [https://github.com/Woopra/Woopra-iOS](https://github.com/Woopra/Woopra-iOS)

<h2>Woopra iOS SDK Documentation</h2>

When the app loads, you should load the Woopra Tracker and configure it.

``` objective-c
[WTracker sharedInstance].domain = @"mybusiness.com";
```

You can update your idle timeout (default: 30 seconds) by updating the timeout property in your WTracker instance:

``` objective-c
[WTracker sharedInstance].idleTimeout = 60;
```

If you want to keep the user online on Woopra even if they don't commit any event between the last event and the idleTimeout, you can enable auto pings.

``` objective-c
// Ping is disabled by default
[WTracker sharedInstance].pingEnabled = true;
```

To add custom visitor properties, you should edit the visitor object.

``` objective-c
[[WTracker sharedInstance].visitor addProperty:@"name" value:@"John Smith"]
[[WTracker sharedInstance].visitor addProperty:@"email" value:@"john@smith.com"]
```
Your custom visitor data will not be pushed until you send your first custom event. On website, the default event is a `pageview`. In mobile apps, we recommend that developers use the event `appview` when switching between Windows and Views.

To add send an `appview` event:

``` objective-c
// create event "appview"
WEvent* event = [WEvent eventWithName:@"appview"];
// add property "view" with value "login-view"
[event addProperty:@"view": value:@"login-view"];
// track event
[[WTracker sharedInstance] trackEvent:event];
```
