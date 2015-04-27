//
//  SCDockScrollView.h
//  SnowCat
//
//  Created by Moky on 14-8-5.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCPageScrollView.h"

@interface UIDockScrollView : UIPageScrollView

@property(nonatomic, readwrite) BOOL reflectionEnabled; // default is YES

@property(nonatomic, readwrite) CGFloat scale; // default is 0.2

- (void) performEffectOnScrollView:(UIScrollView *)scrollView;

@end

@interface SCDockScrollView : UIDockScrollView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIDockScrollView *)dockScrollView;

@end
