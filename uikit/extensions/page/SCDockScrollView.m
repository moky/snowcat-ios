//
//  SCDockScrollView.m
//  SnowCat
//
//  Created by Moky on 14-8-5.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCNib.h"
#import "SCView+Reflection.h"
#import "SCView+Transform.h"
#import "SCPageScrollViewDataSource.h"
#import "SCDockScrollView.h"

@implementation UIDockScrollView

@synthesize reflectionEnabled = _reflectionEnabled;
@synthesize scale = _scale;

- (void) _initializeUIDockScrollView
{
	_reflectionEnabled = YES;
	
	_scale = 0.2f;
	
	// pre-load TWO MORE view here
	// cause the cover flow will show part of next view in the right side
	self.preloadedPageCount = 2;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeUIDockScrollView];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeUIDockScrollView];
	}
	return self;
}

- (void) addSubview:(UIView *)view
{
	if (_reflectionEnabled) {
		[view showReflection];
	}
	[super addSubview:view];
}

// if new subview comes, perform dock effect
- (UIView *) showSubviewAtIndex:(NSUInteger)index
{
	UIView * view = [super showSubviewAtIndex:index];
	[self performEffectOnScrollView:self.scrollView];
	return view;
}

- (void) performEffectOnScrollView:(UIScrollView *)scrollView
{
	[self _performDockEffectOnScrollView:scrollView];
}

//
//  <Formulas>
//
//      1. rotate   : r = f(x) = atan(x)
//
//      2. scale    : s = g(x) = e^(-|x|)
//
//      3. position : ...
//

// perform dock effect
- (void) _performDockEffectOnScrollView:(UIScrollView *)scrollView
{
	CGSize size = scrollView.bounds.size;
	CGPoint offset = scrollView.contentOffset;
	CGPoint center = CGPointMake(offset.x + size.width * 0.5, offset.y + size.height * 0.5);
	
	CGFloat distance;
	CGFloat rotate;
	CGFloat scale;
	CGFloat position;
	
	CGFloat SCALE_MIN   = _scale;
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
			//[subview rollWithRotation:-rotate]; // rotating around axis Y
			
			// 2. scale
			scale = expf(-fabsf(distance)) * SCALE_RANGE + SCALE_MIN;
			[subview scaleWithScale:scale];
			
			// 3. position
			position = (rotate / M_PI_2 * (1.0f + SCALE_RANGE) + distance * SCALE_MIN) * subview.bounds.size.width;
			subview.center = CGPointMake(center.x + position,
										 center.y + (1.0f - scale) * subview.bounds.size.height * 0.5f);
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
			//[subview pitchWithRotation:rotate]; // rotating around axis X
			
			// 2. scale
			scale = expf(-fabsf(distance)) * SCALE_RANGE + SCALE_MIN;
			[subview scaleWithScale:scale];
			
			// 3. position
			position = (rotate / M_PI_2 * (1.0f + SCALE_RANGE) + distance * SCALE_MIN) * subview.bounds.size.height;
			subview.center = CGPointMake(center.x + (1.0f - scale) * subview.bounds.size.width * 0.5f,
										 center.y + position);
		}
	}
}

#pragma mark - UIScrollViewDelegate

// any offset changes, perform cover flow effect
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
	[self performEffectOnScrollView:scrollView];
}

@end

#pragma mark -

@interface SCDockScrollView ()

@property(nonatomic, retain) id<UIPageScrollViewDataSource> pageScrollViewDataSource;

@end

@implementation SCDockScrollView

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

- (void) _initializeSCDockScrollView
{
	_scTag = 0;
	self.nodeFile = nil;
	
	self.pageScrollViewDataSource = nil;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCDockScrollView];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeSCDockScrollView];
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

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIDockScrollView *)dockScrollView
{
	if (![SCPageScrollView setAttributes:dict to:dockScrollView]) {
		return NO;
	}
	
	// reflectionEnabled
	id reflectionEnabled = [dict objectForKey:@"reflectionEnabled"];
	if (reflectionEnabled) {
		dockScrollView.reflectionEnabled = [reflectionEnabled boolValue];
	}
	
	// scale
	id scale = [dict objectForKey:@"scale"];
	if (scale) {
		dockScrollView.scale = [scale floatValue];
	}
	
	return YES;
}

@end
