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

- (instancetype)initWithName: (NSString*)name
{
	self = [super init];
	if (!self) return nil;

	[self addProperty:@"~event" value:name];

	return self;
}

@end
