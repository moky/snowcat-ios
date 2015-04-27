//
//  SCWebViewDelegate+JSBridge.h
//  SnowCat
//
//  Created by Moky on 15-2-11.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "SCWebViewDelegate.h"

@interface SCWebViewDelegate (JSBridge)

// inject "snowcat.bridge.js"
- (void) injectionForWebView:(UIWebView *)webView;

// callback via "snowcat.bridge.js"
- (void) invokeFromWebView:(UIWebView *)webView withURL:(NSURL *)URL;

@end
