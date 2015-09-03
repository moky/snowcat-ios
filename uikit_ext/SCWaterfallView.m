//
//  SCWaterfallView.m
//  SnowCat
//
//  Created by Moky on 15-5-8.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCNib.h"
#import "SCView.h"
#import "SCWaterfallView.h"

//typedef NS_ENUM(NSUInteger, UIWaterfallViewDirection) {
//	UIWaterfallViewDirectionTopLeft,     // place each subview as TOP as possible, if reach the TOP, as LEFT as possible
//	UIWaterfallViewDirectionTopRight,    // TOP first, and then RIGHT
//
//	UIWaterfallViewDirectionBottomLeft,  // BOTTOM first, and then LEFT
//	UIWaterfallViewDirectionBottomRight, // BOTTOM first, and then RIGHT
//
//	UIWaterfallViewDirectionLeftTop,     // LEFT first, and then TOP
//	UIWaterfallViewDirectionLeftBottom,  // LEFT first, and then BOTTOM
//
//	UIWaterfallViewDirectionRightTop,    // RIGHT first, and then TOP
//	UIWaterfallViewDirectionRightBottom, // RIGHT first, and then BOTTOM
//};
UIWaterfallViewDirection UIWaterfallViewDirectionFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"TopLeft")
			return UIWaterfallViewDirectionTopLeft;
		SC_SWITCH_CASE(string, @"TopRight")
			return UIWaterfallViewDirectionTopRight;
		SC_SWITCH_CASE(string, @"BottomLeft")
			return UIWaterfallViewDirectionBottomLeft;
		SC_SWITCH_CASE(string, @"BottomRight")
			return UIWaterfallViewDirectionBottomRight;
		SC_SWITCH_CASE(string, @"LeftTop")
			return UIWaterfallViewDirectionLeftTop;
		SC_SWITCH_CASE(string, @"LeftBottom")
			return UIWaterfallViewDirectionLeftBottom;
		SC_SWITCH_CASE(string, @"RightTop")
			return UIWaterfallViewDirectionRightTop;
		SC_SWITCH_CASE(string, @"RightBottom")
			return UIWaterfallViewDirectionRightBottom;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

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
