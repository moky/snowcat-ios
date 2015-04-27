//
//  SCPageControl.m
//  SnowCat
//
//  Created by Moky on 14-3-29.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCNib.h"
#import "SCColor.h"
#import "SCEventHandler.h"
#import "SCPageControl.h"

@implementation SCPageControl

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib

- (void) dealloc
{
	[_nodeFile release];
	
	[self removeTarget:self action:@selector(onChange:) forControlEvents:UIControlEventValueChanged];
	
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCPageControl
{
	_scTag = 0;
	self.nodeFile = nil;
	
	// Note that the target is not retained, so this assignment won't cause memory leaks
	[self addTarget:self action:@selector(onChange:) forControlEvents:UIControlEventValueChanged];
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCPageControl];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeSCPageControl];
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
SC_UIKIT_IMELEMENT_BUILD_HANDLERS_FUNCTION()

// awakeFromNib
SC_UIKIT_IMPLEMENT_AWAKE_FUNCTION()

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIPageControl *)pageControl
{
	[pageControl sizeToFit];
	
	if (![SCControl setAttributes:dict to:pageControl]) {
		SCLog(@"failed to set attributes: %@", dict);
		return NO;
	}
	
	// numberOfPages
	// currentPage
	
	// hidesForSinglePage
	id hidesForSinglePage = [dict objectForKey:@"hidesForSinglePage"];
	if (hidesForSinglePage) {
		pageControl.hidesForSinglePage = [hidesForSinglePage boolValue];
	}
	
	// defersCurrentPageDisplay
	id defersCurrentPageDisplay = [dict objectForKey:@"defersCurrentPageDisplay"];
	if (defersCurrentPageDisplay) {
		pageControl.defersCurrentPageDisplay = [defersCurrentPageDisplay boolValue];
	}
	
	// pageIndicatorTintColor
	NSDictionary * pageIndicatorTintColor = [dict objectForKey:@"pageIndicatorTintColor"];
	if (pageIndicatorTintColor) {
		SCColor * color = [SCColor create:pageIndicatorTintColor autorelease:NO];
		pageControl.pageIndicatorTintColor = color;
		[color release];
	}
	
	// currentPageIndicatorTintColor
	NSDictionary * currentPageIndicatorTintColor = [dict objectForKey:@"currentPageIndicatorTintColor"];
	if (currentPageIndicatorTintColor) {
		SCColor * color = [SCColor create:currentPageIndicatorTintColor autorelease:NO];
		pageControl.currentPageIndicatorTintColor = color;
		[color release];
	}
	
	return YES;
}

#pragma mark - Value Event Interfaces

- (void) onChange:(id)sender
{
	SCLog(@"onChange: %@", sender);
	SCDoEvent(@"onChange", sender);
}

@end
