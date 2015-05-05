//
//  WTracker.m
//  WTracker
//
//  Created by Woopra on 1/23/13.
//
//

#import "WTracker.h"
#import "WPinger.h"
#import <UIKit/UIKit.h>

static NSString* const WEventEndpoint = @"http://www.woopra.com/track/ce/";

@implementation WTracker

@synthesize domain, idleTimeout, pingEnabled, visitor, referer;

static WTracker* gSingleton = nil;
static WPinger* gPinger = nil;

+ (WTracker*)sharedInstance
{
	if (nil == gSingleton)
	{
		gSingleton = [[WTracker alloc] init];
		gPinger = [[WPinger alloc] initWithTracker:gSingleton];

		// create dummy visitor object to track 'anonimous' events
		gSingleton.visitor = [WVisitor anonymousVisitor];
	}
	
	return gSingleton;
}

- (instancetype)init
{
	self = [super init];
	if (!self) return nil;
	
	// default timeout value for Woopra service
	self.idleTimeout = 30.0;

    // initialize some properties
    [self addProperty:@"device" value:[UIDevice currentDevice].model];
    [self addProperty:@"os" value:[NSString stringWithFormat:@"%@ %@", [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion]];
    [self addProperty:@"browser" value:[[NSBundle mainBundle] objectForInfoDictionaryKey:(__bridge NSString*)kCFBundleNameKey]];

	return self;
}

- (void)dealloc
{
	self.domain = nil;
	self.visitor = nil;
	self.referer = nil;

	[super dealloc];
}

- (BOOL)trackEvent: (WEvent*)event
{
	// check parameters
	if (nil == self.domain)
	{
		NSLog(@"WTracker.domain property must be set before [WTracker trackEvent:] invocation. Ex.: tracker.domain = mywebsite.com");
		return FALSE;
	}
	
	if (nil == self.visitor)
	{
		NSLog(@"WTracker.visitor property must be set before [WTracker trackEvent:] invocation");
		return FALSE;
	}
	
	NSMutableString* parameters = [NSMutableString stringWithFormat:@"?app=ios&host=%@&cookie=%@&response=xml&timeout=%d",
								   self.domain, self.visitor.cookie, (int)(self.idleTimeout * 1000)];
	if (self.referer)
		[parameters appendFormat:@"&referer=%@", self.referer];

    // Add self's properties
    for (NSString* k in self.properties)
        [parameters appendFormat:@"ce_%@=%@", k, self.properties[k]];

	// Add visitors properties
	NSDictionary* prop = self.visitor.properties;
	for (NSString* k in prop)
		[parameters appendFormat:@"&cv_%@=%@", k, [prop objectForKey:k]];
	
	// Add Event Properties
	prop = event.properties;
    for (NSString* k in prop){
        if([k hasPrefix:@"~"]){
            /*
             * system property
             */
            [parameters appendFormat:@"&%@=%@", [k substringFromIndex:1], [prop objectForKey:k]];
        }else{
            [parameters appendFormat:@"&ce_%@=%@", k, [prop objectForKey:k]];
        }
    }
	
	// submit asynchronous track request
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:
									[NSURL URLWithString: [[WEventEndpoint stringByAppendingString:parameters] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	[NSURLConnection connectionWithRequest:request delegate:self];
	
	return TRUE;
}

- (BOOL)trackEventNamed:(NSString*)eventName
{
	return [self trackEvent: [WEvent eventWithName:eventName]];
}

@end
