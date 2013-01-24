//
//  WPropertiesContainer.h
//  WTracker
//
//  Created by Boris Remizov on 1/24/13.
//
//

#import <Foundation/Foundation.h>

@interface WPropertiesContainer : NSObject

@property (nonatomic, readonly, copy) NSDictionary* properties;

/**
 *
 * @param key
 * @param value
 */

- (void)addProperty:(NSString*)key value:(NSString*)value;

/**
 *
 * @param properties
 */

- (void)addProperties:(NSDictionary*)properties;

@end
