//
//  WVisitor.m
//  WTracker
//
//  Created by Boris Remizov on 1/23/13.
//
//

#import "WVisitor.h"
#import <CommonCrypto/CommonHMAC.h>
#import <uuid/uuid.h>

@implementation WVisitor

@synthesize cookie;

+ (NSString*)hashFromString: (NSString*)data
{
	const char *cKey  = "woopra_ios";
	const char *cData = [data cStringUsingEncoding:NSUTF8StringEncoding];
	uint8_t digest[CC_MD5_DIGEST_LENGTH];
	CCHmac(kCCHmacAlgMD5, cKey, strlen(cKey), cData, strlen(cData), digest);
	
	NSMutableString* output = [NSMutableString string];
	for(int i = 0; i < sizeof(digest); i++)
		[output appendFormat:@"%x", digest[i]];

	return output;
}

+ (WVisitor*)visitorWithCookie:(NSString*)cookie
{
	WVisitor* visitor = [[[WVisitor alloc] init] autorelease];
	visitor.cookie = cookie;
	
	return visitor;
}

+ (WVisitor*)visitorWithEmail:(NSString*)address
{
	WVisitor* visitor = [[[WVisitor alloc] init] autorelease];
	visitor.cookie = [self hashFromString:address];
	[visitor addProperty:@"email" value:address];
	
	return visitor;
}

- (void)dealloc
{
	self.cookie = nil;
	[super dealloc];
}

@end

@implementation WVisitor(anonymous)

+ (WVisitor*)anonymousVisitor
{
	NSString* anonymousCookie = [[NSUserDefaults standardUserDefaults] stringForKey:@"woopra_cookie"];
	if (nil == anonymousCookie)
	{
		// generate random cookie for anonimous visitor
		uuid_t rawCookie;
		uuid_generate(rawCookie);
		anonymousCookie = [NSString stringWithFormat:@"%x%x%x%x",
						   *(uint32_t*)rawCookie, *((uint32_t*)rawCookie + 1),
						   *((uint32_t*)rawCookie + 2), *((uint32_t*)rawCookie + 3)];
		
		[[NSUserDefaults standardUserDefaults] setObject:anonymousCookie forKey:@"woopra_cookie"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	
	return [self visitorWithCookie:anonymousCookie];
}

@end