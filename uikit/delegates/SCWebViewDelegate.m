//
//  SCWebViewDelegate.m
//  SnowCat
//
//  Created by Moky on 14-4-14.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCEventHandler.h"
#import "SCWebViewDelegate+JSBridge.h"
#import "SCWebViewDelegate.h"

@implementation SCWebViewDelegate

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	self = [self init];
	if (self) {
		// TODO: set attributes here
	}
	return self;
}

#pragma mark - UIWebViewDelegate

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	if ([request.URL.scheme isEqualToString:@"snowcat"]) {
		[self invokeFromWebView:webView withURL:request.URL]; // invoke
		return NO;
	}
	
	return YES;
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
	SCLog(@"onStart: %@", webView);
	SCDoEvent(@"onStart", webView);
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
	SCLog(@"onFinish: %@", webView);
	SCDoEvent(@"onFinish", webView);
	SCDoEvent(@"onLoad", webView);
	
	[self injectionForWebView:webView]; // inject
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	SCLog(@"onFail: %@, error: %@", webView, error);
	SCDoEvent(@"onFail", webView);
	SCDoEvent(@"onError", webView);
}

@end
