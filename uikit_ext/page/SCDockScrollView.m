//
//  SCDockScrollView.m
//  SnowCat
//
//  Created by Moky on 14-8-5.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "SCNib.h"
#import "SCPageScrollView.h"
#import "SCPageScrollViewDataSource.h"
#import "SCDockScrollView.h"

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
