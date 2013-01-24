//
//  WVisitor.h
//  WTracker
//
//  Created by Boris Remizov on 1/23/13.
//
//

#import <WTracker/WPropertiesContainer.h>
#import <Foundation/Foundation.h>

@interface WVisitor : WPropertiesContainer

/**
 *
 * @param cookie
 */
@property (nonatomic, copy) NSString* cookie;

+ (WVisitor*)visitorWithCookie:(NSString*)cookie;
+ (WVisitor*)visitorWithEmail:(NSString*)address;

@end

@interface WVisitor(anonymous)

+ (WVisitor*)anonymousVisitor;

@end