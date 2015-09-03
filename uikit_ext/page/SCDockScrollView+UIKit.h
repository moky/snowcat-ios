//
//  UIDockScrollView.h
//  SnowCat
//
//  Created by Moky on 15-5-5.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "SCPageScrollView+UIKit.h"

@interface UIDockScrollView : UIPageScrollView

@property(nonatomic, readwrite) BOOL reflectionEnabled; // default is YES

@property(nonatomic, readwrite) CGFloat scale; // default is 0.2

- (void) performEffectOnScrollView:(UIScrollView *)scrollView;

@end
