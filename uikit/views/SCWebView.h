//
//  SCWebView.h
//  SnowCat
//
//  Created by Moky on 14-3-24.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "SCUIKit.h"

__TVOS_PROHIBITED
UIKIT_EXTERN UIWebViewNavigationType UIWebViewNavigationTypeFromString(NSString * string);

__TVOS_PROHIBITED
@interface SCWebView : UIWebView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIWebView *)webView;

@end
