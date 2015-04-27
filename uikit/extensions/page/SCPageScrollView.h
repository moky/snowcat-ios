//
//  SCPageScrollView.h
//  SnowCat
//
//  Created by Moky on 14-3-29.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCView.h"

typedef NS_ENUM(NSInteger, UIPageScrollViewDirection) {
	UIPageScrollViewDirectionVertical,
	UIPageScrollViewDirectionHorizontal,
};

UIKIT_EXTERN UIPageScrollViewDirection UIPageScrollViewDirectionFromString(NSString * string);

@protocol UIPageScrollViewDataSource;

@interface UIPageScrollView : UIView<UIScrollViewDelegate>

@property(nonatomic, assign) id<UIPageScrollViewDataSource> dataSource;

@property(nonatomic, readwrite) UIPageScrollViewDirection direction;
@property(nonatomic, readonly) NSUInteger pageCount;
@property(nonatomic, readwrite) NSUInteger currentPage;

@property(nonatomic, readonly) UIScrollView * scrollView; // inner scroll view
//@protected:
@property(nonatomic, retain) UIPageControl * pageControl;

@property(nonatomic, readwrite) BOOL animated; // whether animated while turning page
@property(nonatomic, readwrite) CGSize contentSize; // content size of inner scroll view

@property(nonatomic, readwrite) NSUInteger preloadedPageCount; // default is 1

- (void) reloadData;

- (void) scrollToNextPage;

//@protected:
- (UIView *) showSubviewAtIndex:(NSUInteger)index; // return the new view shown at index

@end

#pragma mark -

@interface SCPageScrollView : UIPageScrollView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIPageScrollView *)pageScrollView;

@end
