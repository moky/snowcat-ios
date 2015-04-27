//
//  SCWebView+JSBridge.m
//  SnowCat
//
//  Created by Moky on 15-2-11.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCMemoryCache.h"
#import "SCWebView+JSBridge.h"

@implementation SCWebView (JSBridge)

- (NSString *) title
{
	return [self stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (NSURL *) URL
{
	NSString * href = [self stringByEvaluatingJavaScriptFromString:@"document.location.href"];
	return [NSURL URLWithString:href];
}

- (void) inject:(NSString *)jsFile
{
	SCLog(@"injecting %@", jsFile);
	
	SCMemoryCache * cache = [SCMemoryCache getInstance];
	NSString * javascript = [cache objectForKey:jsFile];
	if (!javascript) {
		// 1. load data from file
		NSData * data = [[NSData alloc] initWithContentsOfFile:jsFile];
		if (!data) {
			NSAssert(false, @"data error: %@", jsFile);
			return;
		}
		
		// 2. decode to string
		javascript = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		if (!javascript) {
			NSAssert(false, @"data error: %@", jsFile);
			[data release];
			return;
		}
		
		[cache setObject:javascript forKey:jsFile]; // javascript.retainCount++
		
		[javascript release];
		[data release];
	}
	
	// 3. inject
	[self stringByEvaluatingJavaScriptFromString:javascript];
}

// fire event for javascript
- (void) fire:(NSString *)event
{
	NSString * javascript = [[NSString alloc] initWithFormat:@"(function() {   \
								try {                                          \
									snowcat.fire('%@');                        \
								} catch (e) {                                  \
									return e.description;                      \
								}                                              \
								return 'OK';                                   \
							 })();", event];
	
	NSString * result = [self stringByEvaluatingJavaScriptFromString:javascript];
	[javascript release];
	
	if (result) {
		NSAssert([result isEqualToString:@"OK"], @"error: %@", result);
	}
}

@end
