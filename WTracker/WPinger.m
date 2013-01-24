//
//  WPinger.m
//  WTracker
//
//  Created by Boris Remizov on 1/24/13.
//
//

#import "WPinger.h"
#import "WTracker.h"

#define WPingerAperture 5.0

static NSString* const WPingEndpoint = @"https://www.woopra.com/track/ping/";

@interface WPinger()

- (void)startStopPingTimerAccordingToTrackerState;
- (NSArray*)monitoredTrackerProperties;

- (void)pingTimerDidFire:(NSTimer*)timer;

@end

@implementation WPinger
{
	WTracker* _tracker;
	NSTimer* _pingTimer;
}

@synthesize tracker = _tracker;

- (id)initWithTracker: (WTracker*)aTracker
{
	self = [super init];
	if (!self) return nil;
	
	_tracker = aTracker;
	
	// observe WTracker values to start/stop ping timer
	for (NSString* property in [self monitoredTrackerProperties])
		[aTracker addObserver:self forKeyPath:property options:NSKeyValueObservingOptionNew context:NULL];
	
	[self startStopPingTimerAccordingToTrackerState];

	return self;
}

- (void)dealloc
{
	[_pingTimer invalidate];

	for (NSString* property in [self monitoredTrackerProperties])
		[self.tracker removeObserver:self forKeyPath:property];
	
	[super dealloc];
}

- (NSArray*)monitoredTrackerProperties
{
	return [NSArray arrayWithObjects:@"pingEnabled", @"timeout", @"visitor", @"host", nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (self.tracker == object && [[self monitoredTrackerProperties] containsObject:keyPath])
		[self startStopPingTimerAccordingToTrackerState];
	else
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)startStopPingTimerAccordingToTrackerState
{
	[_pingTimer invalidate];
	_pingTimer = nil;

	if ([self.tracker.domain length] > 0 &&
		self.tracker.visitor &&
		self.tracker.pingEnabled &&
		self.tracker.idleTimeout > WPingerAperture)
	{
		// start ping timer if timeout more then WPingerAperture seconds
		_pingTimer = [NSTimer scheduledTimerWithTimeInterval: self.tracker.idleTimeout - WPingerAperture
													  target:self
													selector:@selector(pingTimerDidFire:)
													userInfo:nil
													 repeats:YES];
		[self pingTimerDidFire:_pingTimer];
	}
}

- (void)pingTimerDidFire:(NSTimer*)timer
{
	NSString* parameters = [NSString stringWithFormat:@"?host=%@&response=xml&cookie=%@&meta=VGhpcyBpcyBhIHRlc3Q&timeout=%d",
							self.tracker.domain, self.tracker.visitor.cookie, (int)(self.tracker.idleTimeout * 1000)];
	NSURLRequest* pingRequest = [NSURLRequest requestWithURL: [NSURL URLWithString: [[WPingEndpoint stringByAppendingString:parameters] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	[NSURLConnection connectionWithRequest:pingRequest delegate:nil];
}

@end
