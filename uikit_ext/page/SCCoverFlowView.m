//
//  SCCoverFlowView.m
//  SnowCat
//
//  Created by Moky on 14-7-8.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "SCNib.h"
#import "SCPageScrollView.h"
#import "SCPageScrollViewDataSource.h"
#import "SCCoverFlowView.h"

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
