//
//  UISegmentedScrollView.h
//  SnowCat
//
//  Created by Moky on 15-5-5.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UISegmentedScrollViewControlPosition) {
	UISegmentedScrollViewControlPositionTop,
	UISegmentedScrollViewControlPositionBottom,
	UISegmentedScrollViewControlPositionLeft,
	UISegmentedScrollViewControlPositionRight,
};

UIKIT_EXTERN UISegmentedScrollViewControlPosition UISegmentedScrollViewControlPositionFromString(NSString * string);

//
//  Description:
//      A group of scroll views under segmented control
//
@interface UISegmentedScrollView : UIView<UIScrollViewDelegate>

@property(nonatomic, assign) UIView * controlView;
@property(nonatomic, readwrite) UISegmentedScrollViewControlPosition controlPosition;

@property(nonatomic, readwrite) BOOL animated;
@property(nonatomic, readwrite) NSUInteger selectedIndex;

@end
