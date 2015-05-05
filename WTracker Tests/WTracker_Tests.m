//
//  Test0.m
//  WTracker
//
//  Created by jad younan on 11/25/14.
//
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface WTracker_Tests : XCTestCase

@end

@implementation WTracker_Tests

- (void)setUp {
    [WTracker sharedInstance].domain = @"jadyounan.com";


}

- (void)tearDown {

}

- (void)testExample {

    // create event "appview"
    WEvent* event = [WEvent eventWithName:@"test event"];

    // add property "view" with value "login-view"
    [event addProperty:@"abc" value:@"def"];

    // track event
    [[WTracker sharedInstance] trackEvent:event];

}

- (void)testPerformanceExample {

}

@end
