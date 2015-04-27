//
//  SCSegmentedScrollView.h
//  SnowCat
//
//  Created by Moky on 15-4-9.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "SCView.h"

//
//  Description:
//      A group of scroll views under segmented control
//
@interface UISegmentedScrollView : UIView<UIScrollViewDelegate>

@property(nonatomic, readonly) UIView * controlView;

@property(nonatomic, readwrite) BOOL animated;
@property(nonatomic, readwrite) NSUInteger selectedIndex;
@property(nonatomic, readwrite) CGPoint contentOffset;

@end

#pragma mark -

@interface SCSegmentedScrollView : UISegmentedScrollView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UISegmentedScrollView *)segmentedScrollView;

@end
