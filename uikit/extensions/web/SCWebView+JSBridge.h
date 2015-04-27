//
//  SCWebView+JSBridge.h
//  SnowCat
//
//  Created by Moky on 15-2-11.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "SCWebView.h"

@interface SCWebView (JSBridge)

@property(nonatomic, readonly) NSString * title;
@property(nonatomic, readonly) NSURL * URL;

- (void) inject:(NSString *)jsFile;

// fire event for javascript
- (void) fire:(NSString *)event;

@end
