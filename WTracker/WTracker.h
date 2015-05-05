//
//  WTracker.h
//  WTracker
//
//  Created by Boris Remizov on 1/23/13.
//
//

#import <WTracker/WVisitor.h>
#import <WTracker/WEvent.h>
#import <WTracker/WPropertiesContainer.h>
#import <Foundation/Foundation.h>

@interface WTracker : WPropertiesContainer

// Identifies which project environment your sending this tracking request to.
@property (nonatomic, copy) NSString* domain;

// 
@property (nonatomic, retain) WVisitor* visitor;

// In seconds, defaults to 30, after which the event will expire and the visitor will considered offline.
@property (nonatomic) NSTimeInterval idleTimeout;

// ping requests can be periodically sent to Woopra servers to refresh the visitor timeout counter. This is used if it’s important to keep a visitor status ‘online’ when he’s inactive for a long time (for cases such as watching a long video).
@property (nonatomic) BOOL pingEnabled;

// visit’s referring URL, Woopra servers will match the URL against a database of referrers and will generate a referrer type and search terms when applicable. The referrers data will be automatically accessible from the Woopra clients.
@property (nonatomic, copy) NSString* referer;


+ (WTracker*)sharedInstance;

- (BOOL)trackEvent:(WEvent*)event;
- (BOOL)trackEventNamed:(NSString*)eventName;

@end
