//
//  WPinger.h
//  WTracker
//
//  Created by Boris Remizov on 1/24/13.
//
//

#import "WTracker.h"
#import <Foundation/Foundation.h>

@interface WPinger : NSObject

@property (nonatomic, readonly) WTracker* tracker;

- (id)initWithTracker: (WTracker*)tracker;

@end
