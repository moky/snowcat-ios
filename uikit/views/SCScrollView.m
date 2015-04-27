//
//  SCScrollView.m
//  SnowCat
//
//  Created by Moky on 14-3-17.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCLog.h"
#import "SCNib.h"
#import "SCGeometry.h"
#import "SCView+Geometry.h"
#import "SCScrollViewDelegate.h"
#import "SCScrollView.h"

//typedef NS_ENUM(NSInteger, UIScrollViewIndicatorStyle) {
//    UIScrollViewIndicatorStyleDefault,     // black with white border. good against any background
//    UIScrollViewIndicatorStyleBlack,       // black only. smaller. good against a white background
//    UIScrollViewIndicatorStyleWhite        // white only. smaller. good against a black background
//};
UIScrollViewIndicatorStyle UIScrollViewIndicatorStyleFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Black")
			return UIScrollViewIndicatorStyleBlack;
		SC_SWITCH_CASE(string, @"White")
			return UIScrollViewIndicatorStyleWhite;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return UIScrollViewIndicatorStyleDefault;
}

@interface SCScrollView ()

@property(nonatomic, retain) id<SCScrollViewDelegate> scrollViewDelegate;

@end

@implementation SCScrollView

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib
@synthesize scrollViewDelegate = _scrollViewDelegate;

- (void) dealloc
{
	[_scrollViewDelegate release];
	[_nodeFile release];
	
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCScrollView
{
	_scTag = 0;
	self.nodeFile = nil;
	
	self.scrollViewDelegate = nil;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCScrollView];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeSCScrollView];
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	self = [self initWithFrame:CGRectZero];
	if (self) {
		[self buildHandlers:dict];
	}
	return self;
}

// buildHandlers:
- (void) buildHandlers:(NSDictionary *)dict
{
	[SCResponder onCreate:self withDictionary:dict];
	
	NSDictionary * delegate = [dict objectForKey:@"delegate"];
	if (delegate) {
		self.scrollViewDelegate = [SCScrollViewDelegate create:delegate];
		// self.delegate only assign but won't retain the action delegate,
		// so don't release it now
		self.delegate = _scrollViewDelegate;
	}
}

// awakeFromNib
SC_UIKIT_IMPLEMENT_AWAKE_FUNCTION()

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIScrollView *)scrollView
{
	if (![SCView setAttributes:dict to:scrollView]) {
		SCLog(@"failed to set attributes: %@", dict);
		return NO;
	}
	
	SC_SET_ATTRIBUTES_AS_CGPOINT(scrollView, dict, contentOffset);
	
	// content size
	NSString * contentSize = [dict objectForKey:@"contentSize"];
	if (contentSize) {
		scrollView.contentSize = CGSizeFromStringWithNode(contentSize, scrollView);
	} else {
		[SCScrollView adjustContentSizeOfScrollView:scrollView];
		if ([scrollView isKindOfClass:[SCScrollView class]]) {
			// for autoresize the contentSize
			scrollView.delegate = (SCScrollView *)scrollView;
		}
	}
	
	// contentInset
	NSString * contentInset = [dict objectForKey:@"contentInset"];
	if (contentInset) {
		scrollView.contentInset = UIEdgeInsetsFromString(contentInset);
	}
	
	// delegate
	
	SC_SET_ATTRIBUTES_AS_BOOL   (scrollView, dict, directionalLockEnabled);
	SC_SET_ATTRIBUTES_AS_BOOL   (scrollView, dict, bounces);
	SC_SET_ATTRIBUTES_AS_BOOL   (scrollView, dict, alwaysBounceVertical);
	SC_SET_ATTRIBUTES_AS_BOOL   (scrollView, dict, alwaysBounceHorizontal);
	SC_SET_ATTRIBUTES_AS_BOOL   (scrollView, dict, pagingEnabled);
	SC_SET_ATTRIBUTES_AS_BOOL   (scrollView, dict, scrollEnabled);
	SC_SET_ATTRIBUTES_AS_BOOL   (scrollView, dict, showsVerticalScrollIndicator);
	SC_SET_ATTRIBUTES_AS_BOOL   (scrollView, dict, showsHorizontalScrollIndicator);
	
	// scrollIndicatorInsets
	NSString * scrollIndicatorInsets = [dict objectForKey:@"scrollIndicatorInsets"];
	if (scrollIndicatorInsets) {
		scrollView.scrollIndicatorInsets = UIEdgeInsetsFromString(scrollIndicatorInsets);
	}
	
	// indicator style
	NSString * indicatorStyle = [dict objectForKey:@"indicatorStyle"];
	if (indicatorStyle) {
		scrollView.indicatorStyle = UIScrollViewIndicatorStyleFromString(indicatorStyle);
	}
	
	SC_SET_ATTRIBUTES_AS_FLOAT  (scrollView, dict, decelerationRate);
	
	// tracking
	// dragging
	// decelerating
	
	SC_SET_ATTRIBUTES_AS_BOOL   (scrollView, dict, delaysContentTouches);
	SC_SET_ATTRIBUTES_AS_BOOL   (scrollView, dict, canCancelContentTouches);
	
	SC_SET_ATTRIBUTES_AS_FLOAT  (scrollView, dict, minimumZoomScale);
	SC_SET_ATTRIBUTES_AS_FLOAT  (scrollView, dict, maximumZoomScale);
	SC_SET_ATTRIBUTES_AS_FLOAT  (scrollView, dict, zoomScale);
	SC_SET_ATTRIBUTES_AS_BOOL   (scrollView, dict, bouncesZoom);
	
	// zooming
	// zoomBouncing
	
	SC_SET_ATTRIBUTES_AS_BOOL   (scrollView, dict, scrollsToTop);
	
	// panGestureRecognizer
	// pinchGestureRecognizer
	
	// keyboardDismissMode
	
	return YES;
}

+ (void) adjustContentSizeOfScrollView:(UIScrollView *)scrollView
{
	scrollView.contentSize = [SCView sizeThatFits:CGSizeZero to:scrollView];
}

//- (void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	[SCScrollView adjustContentSizeOfScrollView:scrollView];
}

@end
