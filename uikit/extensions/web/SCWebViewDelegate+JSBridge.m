//
//  SCWebViewDelegate+JSBridge.m
//  SnowCat
//
//  Created by Moky on 15-2-11.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCClient.h"
#import "SCURL.h"
#import "SCString.h"
#import "SCWebView+JSBridge.h"
#import "SCWebViewDelegate+JSBridge.h"

#define SC_WEBVIEW_JSBRIDGE_FILE    @"snowcat.bridge.js"
#define SC_WEBVIEW_JSBRIDGE_PATH    [SCApplicationDirectory() stringByAppendingPathComponent:SC_WEBVIEW_JSBRIDGE_FILE]

@implementation SCWebViewDelegate (JSBridge)

// inject "snowcat.bridge.js"
- (void) injectionForWebView:(UIWebView *)webView
{
	SCWebView * wv = (SCWebView *)webView;
	if ([wv isKindOfClass:[SCWebView class]]) {
		[wv inject:SC_WEBVIEW_JSBRIDGE_PATH];
	}
}

// callback via "snowcat.bridge.js"
- (void) invokeFromWebView:(UIWebView *)webView withURL:(NSURL *)URL
{
	NSString * object = URL.host;
	NSString * method = URL.path;
	NSDictionary * parameters = [SCURL parametersFromURL:URL];
	
	// notification
	if ([object isEqualToString:@"notification"]) {
		if ([method isEqualToString:@"/post"]) {
			NSString * event = [parameters objectForKey:@"event"];
			NSAssert([event isKindOfClass:[NSString class]], @"event error: %@", URL);
			id userInfo = [parameters objectForKey:@"userInfo"];
			if (userInfo) {
				userInfo = [SCString objectFromJsonString:userInfo];
			}
			NSAssert(!userInfo || [userInfo isKindOfClass:[NSDictionary class]], @"userInfo error: %@", URL);
			
			NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
			[center postNotificationName:event object:webView userInfo:userInfo];
		}
	}
	
	// ...
}

@end
