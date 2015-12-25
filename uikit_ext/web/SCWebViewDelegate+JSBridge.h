//
//  SCWebViewDelegate+JSBridge.h
//  SnowCat
//
//  Created by Moky on 15-2-11.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "SCWebViewDelegate.h"

//__TVOS_PROHIBITED
@interface SCWebViewDelegate (JSBridge)

// inject "snowcat.bridge.js"
- (NSString *) injectionForWebView:(UIWebView *)webView;

// callback via "snowcat.bridge.js"
- (BOOL) invokeFromWebView:(UIWebView *)webView withURL:(NSURL *)URL;

// override this function to handle other message invoke from webview
- (BOOL) invokeFromWebView:(UIWebView *)webView withHost:(NSString *)object path:(NSString *)method parameters:(NSDictionary *)parameters;

@end
