//
//  SCWaterfallView.m
//  SnowCat
//
//  Created by Moky on 15-5-8.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "SCNib.h"
#import "SCView.h"
#import "SCWaterfallView.h"

@implementation SCWaterfallView

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib

- (void) dealloc
{
	self.nodeFile = nil;
	
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCWaterfallView
{
	_scTag = 0;
	self.nodeFile = nil;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCWaterfallView];
	}
	return self;
}

// default initializer
- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeSCWaterfallView];
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

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIWaterfallView *)waterfallView
{
	if (![SCView setAttributes:dict to:waterfallView]) {
		return NO;
	}
	
	// direction
	NSString * direction = [dict objectForKey:@"direction"];
	if (direction) {
		waterfallView.direction = UIWaterfallViewDirectionFromString(direction);
	}
	
	// space
	id space = [dict objectForKey:@"space"];
	if (space) {
		waterfallView.space = [space floatValue];
	}
	
	// spaceHorizontal
	id spaceHorizontal = [dict objectForKey:@"spaceHorizontal"];
	if (spaceHorizontal) {
		waterfallView.spaceHorizontal = [spaceHorizontal floatValue];
	}
	
	// spaceVertical
	id spaceVertical = [dict objectForKey:@"spaceVertical"];
	if (spaceVertical) {
		waterfallView.spaceVertical = [spaceVertical floatValue];
	}
	
	return YES;
}

@end
