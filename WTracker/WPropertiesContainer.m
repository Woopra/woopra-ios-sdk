//
//  WPropertiesContainer.m
//  WTracker
//
//  Created by Boris Remizov on 1/24/13.
//
//

#import "WPropertiesContainer.h"

@implementation WPropertiesContainer
{
	NSMutableDictionary* _properties;
}

@synthesize properties = _properties;

- (id)init
{
	self = [super init];
	if (!self) return nil;
	
	_properties = [[NSMutableDictionary alloc] init];
	
	return self;
}

- (void)dealloc
{
	[_properties release];
	[super dealloc];
}

- (void)addProperty: (NSString*)key value:(NSString*)value
{
	if (value && key)
		[_properties setObject: [[value copy] autorelease] forKey:key];
}

- (void)addProperties:(NSDictionary*)properties
{
	if (properties)
		[_properties addEntriesFromDictionary:properties];
}

@end
