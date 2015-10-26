//
//  SCWebViewDelegate+JSBridge.m
//  SnowCat
//
//  Created by Moky on 15-2-11.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCClient.h"
#import "SCURL.h"
#import "SCString.h"
#import "SCWebView+JSBridge.h"
#import "SCWebViewDelegate+JSBridge.h"

#define SC_WEBVIEW_JSBRIDGE_FILES @[                                           \
                                     @"snowcat.base.js",                       \
                                     @"snowcat.bridge.js",                     \
                                     @"snowcat.extension.js",                  \
                                     @"snowcat.main.js"                        \
                                   ]                                           \
                                           /* EOF 'SC_WEBVIEW_JSBRIDGE_FILES' */

@implementation SCWebViewDelegate (JSBridge)

// inject "snowcat.bridge.js"
- (NSString *) injectionForWebView:(UIWebView *)webView
{
	NSString * file;
	SC_FOR_EACH(file, SC_WEBVIEW_JSBRIDGE_FILES) {
		file = [SCApplicationDirectory() stringByAppendingPathComponent:file];
		[SCWebView inject:file webview:webView];
	}
	return nil;
}

// callback via "snowcat.bridge.js"
- (BOOL) invokeFromWebView:(UIWebView *)webView withURL:(NSURL *)URL
{
	NSString * object = URL.host;
	NSString * method = URL.path;
	NSDictionary * parameters = [URL parameters];
	return [self invokeFromWebView:webView withHost:object path:method parameters:parameters];
}

- (BOOL) invokeFromWebView:(UIWebView *)webView withHost:(NSString *)object path:(NSString *)method parameters:(NSDictionary *)parameters
{
	// notification
	if ([object isEqualToString:@"notification"]) {
		if ([method isEqualToString:@"/post"]) {
			NSString * event = [parameters objectForKey:@"event"];
			NSAssert([event isKindOfClass:[NSString class]], @"event error: %@", event);
			id userInfo = [parameters objectForKey:@"userInfo"];
			if (userInfo) {
				userInfo = NSObjectFromJSONString(userInfo);
			}
			NSAssert(!userInfo || [userInfo isKindOfClass:[NSDictionary class]], @"userInfo error: %@", userInfo);
			
			NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
			[center postNotificationName:event object:webView userInfo:userInfo];
			
			return YES;
		}
	}
	
	return NO;
}

@end
