//
//  SCCoverFlowView.m
//  SnowCat
//
//  Created by Moky on 14-7-8.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCNib.h"
#import "SCView+Transform.h"
#import "SCPageScrollViewDataSource.h"
#import "SCCoverFlowView.h"

@implementation UICoverFlowView

- (void) performEffectOnScrollView:(UIScrollView *)scrollView
{
	[self _performCoverFlowEffectOnScrollView:scrollView];
}

//
//  <Formulas>
//
//      1. rotate   : r = f(x) = atan(x)
//
//      2. scale    : s = g(x) = e^(-|x|)
//
//      3. position : l = h(x) = f(x) / (PI / 2)
//

// perform cover flow effect
- (void) _performCoverFlowEffectOnScrollView:(UIScrollView *)scrollView
{
	CGSize size = scrollView.bounds.size;
	CGPoint offset = scrollView.contentOffset;
	CGPoint center = CGPointMake(offset.x + size.width * 0.5, offset.y + size.height * 0.5);
	
	CGFloat distance;
	CGFloat rotate;
	CGFloat scale;
	CGFloat position;
	
	CGFloat SCALE_MIN   = self.scale;
	CGFloat SCALE_RANGE = 1.0f - SCALE_MIN;
	
	NSArray * subviews = scrollView.subviews;
	UIView * subview;
	NSUInteger count = [subviews count];
	
	if (self.direction == UIPageScrollViewDirectionHorizontal) {
		// distance between each item and the center item
		distance = - offset.x / size.width;
		
		for (NSInteger i = 0; i < count; ++i, distance += 1.0f) {
			// pick out each subview
			subview = [subviews objectAtIndex:i];
			
			// 0. reset
			[subview resetTransform];
			
			// 1. rotate
			rotate = atanf(distance);
			[subview rollWithRotation:-rotate]; // rotating around axis Y
			
			// 2. scale
			scale = expf(-fabsf(distance)) * SCALE_RANGE + SCALE_MIN;
			[subview scaleWithScale:scale];
			
			// 3. position
			position = rotate / M_PI_2 * subview.bounds.size.width;
			subview.center = CGPointMake(center.x + position, center.y);
		}
	} else {
		// distance between each item and the center item
		distance = - offset.y / size.height;
		
		for (NSInteger i = 0; i < count; ++i, distance += 1.0f) {
			// pick out each subview
			subview = [subviews objectAtIndex:i];
			
			// 0. reset
			[subview resetTransform];
			
			// 1. rotate
			rotate = atanf(distance);
			[subview pitchWithRotation:rotate]; // rotating around axis X
			
			// 2. scale
			scale = expf(-fabsf(distance)) * SCALE_RANGE + SCALE_MIN;
			[subview scaleWithScale:scale];
			
			// 3. position
			position = rotate / M_PI_2 * subview.bounds.size.height;
			subview.center = CGPointMake(center.x, center.y + position);
		}
	}
}

@end

#pragma mark -

@interface SCCoverFlowView ()

@property(nonatomic, retain) id<UIPageScrollViewDataSource> pageScrollViewDataSource;

@end

@implementation SCCoverFlowView

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib

@synthesize pageScrollViewDataSource = _pageScrollViewDataSource;

- (void) dealloc
{
	[_pageScrollViewDataSource release];
	
	[_nodeFile release];
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		_scTag = 0;
		self.nodeFile = nil;
		
		self.pageScrollViewDataSource = nil;
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		_scTag = 0;
		self.nodeFile = nil;
		
		self.pageScrollViewDataSource = nil;
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
	
	NSDictionary * dataSource = [dict objectForKey:@"dataSource"];
	if (dataSource) {
		self.pageScrollViewDataSource = [SCPageScrollViewDataSource create:dataSource];
		// self.dataSource only assign but won't retain the data delegate,
		// so don't release it now
		self.dataSource = _pageScrollViewDataSource;
	}
}

// awakeFromNib
SC_UIKIT_IMPLEMENT_AWAKE_FUNCTION()

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UICoverFlowView *)coverFlowView
{
	if (![SCPageScrollView setAttributes:dict to:coverFlowView]) {
		return NO;
	}
	
	return YES;
}

@end
