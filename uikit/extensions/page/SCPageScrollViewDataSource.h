//
//  SCPageScrollViewDataSource.h
//  SnowCat
//
//  Created by Moky on 14-7-6.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCUIKit.h"

@class UIPageScrollView;

@protocol UIPageScrollViewDataSource <NSObject>

- (void) reloadData:(UIPageScrollView *)pageScrollView;

@required

- (NSUInteger) presentationCountForPageScrollView:(UIPageScrollView *)pageScrollView;

- (UIView *) pageScrollView:(UIPageScrollView *)pageScrollView viewAtIndex:(NSUInteger)index;

@optional

- (UIView *) pageScrollView:(UIPageScrollView *)pageScrollView viewBeforeView:(UIView *)view;
- (UIView *) pageScrollView:(UIPageScrollView *)pageScrollView viewAfterView:(UIView *)view;

@end

#pragma mark -

@protocol SCPageScrollViewDataSource <UIPageScrollViewDataSource>

@end

@interface SCPageScrollViewDataSource : SCObject<SCPageScrollViewDataSource>

- (void) setData:(NSArray *)array;

@end
