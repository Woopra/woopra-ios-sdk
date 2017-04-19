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

static NSString* const WEventEndpoint = @"https://www.woopra.com/track/ce/";

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
    
    NSURLComponents* urlComponents = [NSURLComponents componentsWithURL:[NSURL URLWithString:WEventEndpoint]
                                                resolvingAgainstBaseURL:true];
    NSMutableArray* queryItems = [NSMutableArray array];
	[queryItems addObject:[NSURLQueryItem queryItemWithName:@"app"
                                                      value:@"ios"]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"host"
                                                      value:self.domain]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"cookie"
                                                      value:self.visitor.cookie]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"response"
                                                      value:@"xml"]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"timeout"
                                                      value:[[NSNumber numberWithInt:self.idleTimeout * 1000] description]]];
    
    if (self.referer) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"referer"
                                                          value:self.referer]];
    }

    // Add self's properties
    for (NSString* k in self.properties) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:[NSString stringWithFormat:@"ce_%@", k]
                                                          value:self.properties[k]]];
    }
    
    // Add visitors properties
    NSDictionary* prop = self.visitor.properties;
    for (NSString* k in prop) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:[NSString stringWithFormat:@"ce_%@", k]
                                                          value:[prop objectForKey:k]]];
    }
    
    // Add Event Properties
    prop = event.properties;
    for (NSString* k in prop){
        id value = [prop objectForKey:k];
        
        if([k hasPrefix:@"~"]){
            /*
             * system property
             */
            [queryItems addObject:[NSURLQueryItem queryItemWithName:[k substringFromIndex:1]
                                                              value:value]];
        }else{
            [queryItems addObject:[NSURLQueryItem queryItemWithName:[NSString stringWithFormat:@"ce_%@", k]
                                                              value:value]];
        }
    }
    
    urlComponents.queryItems = [queryItems copy];
	
    NSURL* url = urlComponents.URL;
    
	// submit asynchronous track request
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
	[NSURLConnection connectionWithRequest:request delegate:self];
	
	return TRUE;
}

- (BOOL)trackEventNamed:(NSString*)eventName
{
	return [self trackEvent: [WEvent eventWithName:eventName]];
}

@end
