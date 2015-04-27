//
//  SCWebView.h
//  SnowCat
//
//  Created by Moky on 14-3-24.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCUIKit.h"

UIKIT_EXTERN UIWebViewNavigationType UIWebViewNavigationTypeFromString(NSString * string);

@interface SCWebView : UIWebView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIWebView *)webView;

@end
