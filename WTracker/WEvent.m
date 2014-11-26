//
//  WEvent.m
//  WTracker
//
//  Created by Boris Remizov on 1/23/13.
//
//

#import "WEvent.h"

@implementation WEvent

+ (WEvent*)eventWithName:(NSString*)name
{
	return [[[WEvent alloc] initWithName:name] autorelease];
}

- (id)initWithName: (NSString*)name
{
	self = [super init];
	if (!self) return nil;

	[self addProperty:@"~event" value:name];

	return self;
}

- (void) withBrowser:(NSString *)browser
{
    [self addProperty:@"~browser" value:browser];
}

- (void) withOS:(NSString *)os
{
    [self addProperty:@"~os" value:os];
}

- (void) withIP:(NSString *)ip
{
    [self addProperty:@"~ip" value:ip];
}

@end
