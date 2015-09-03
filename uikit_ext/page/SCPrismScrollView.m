//
//  SCPrismScrollView.m
//  SnowCat
//
//  Created by Moky on 14-4-17.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "SCNib.h"
#import "SCPageScrollView.h"
#import "SCPageScrollViewDataSource.h"
#import "SCPrismScrollView.h"

@interface SCPrismScrollView ()

@property(nonatomic, retain) id<UIPageScrollViewDataSource> pageScrollViewDataSource;

@end

@implementation SCPrismScrollView

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

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIPrismScrollView *)prismScrollView
{
	if (![SCPageScrollView setAttributes:dict to:prismScrollView]) {
		return NO;
	}
	
	return YES;
}

@end
