//
//  SCWebView+JSBridge.m
//  SnowCat
//
//  Created by Moky on 15-2-11.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCWebView+JSBridge.h"

@implementation SCWebView (JSBridge)

// fire event for javascript
- (void) fire:(NSString *)event
{
	[self fire:event withData:nil];
}

- (void) fire:(NSString *)event withData:(NSObject *)data
{
	NSString * params = data ? JSONStringFromNSObject(data) : @"null";
	NSString * javascript = [[NSString alloc] initWithFormat:@"(function() {   \
								try {                                          \
									snowcat.fire('%@', %@);                    \
								} catch (e) {                                  \
									return e.description;                      \
								}                                              \
								return 'OK';                                   \
							 })();", event, params];
	
	NSString * result = [self stringByEvaluatingJavaScriptFromString:javascript];
	[javascript release];
	
	if (result) {
		NSAssert([result isEqualToString:@"OK"], @"error: %@", result);
	}
}

@end
