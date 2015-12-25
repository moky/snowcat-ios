//
//  SCWebView+JSBridge.h
//  SnowCat
//
//  Created by Moky on 15-2-11.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "SCWebView.h"

//__TVOS_PROHIBITED
@interface SCWebView (JSBridge)

// fire event for javascript
- (void) fire:(NSString *)event;
- (void) fire:(NSString *)event withData:(NSObject *)data;

@end
