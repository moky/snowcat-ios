//
//  SCControl.m
//  SnowCat
//
//  Created by Moky on 14-3-18.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCLog.h"
#import "SCNib.h"
#import "SCControl.h"

//typedef NS_ENUM(NSInteger, UIControlContentVerticalAlignment) {
//    UIControlContentVerticalAlignmentCenter  = 0,
//    UIControlContentVerticalAlignmentTop     = 1,
//    UIControlContentVerticalAlignmentBottom  = 2,
//    UIControlContentVerticalAlignmentFill    = 3,
//};
UIControlContentVerticalAlignment UIControlContentVerticalAlignmentFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Center")
			return UIControlContentVerticalAlignmentCenter;
		SC_SWITCH_CASE(string, @"Top")
			return UIControlContentVerticalAlignmentTop;
		SC_SWITCH_CASE(string, @"Bottom")
			return UIControlContentVerticalAlignmentBottom;
		SC_SWITCH_CASE(string, @"Fill")
			return UIControlContentVerticalAlignmentFill;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}
//typedef NS_ENUM(NSInteger, UIControlContentHorizontalAlignment) {
//    UIControlContentHorizontalAlignmentCenter = 0,
//    UIControlContentHorizontalAlignmentLeft   = 1,
//    UIControlContentHorizontalAlignmentRight  = 2,
//    UIControlContentHorizontalAlignmentFill   = 3,
//};
UIControlContentHorizontalAlignment UIControlContentHorizontalAlignmentFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Center")
			return UIControlContentHorizontalAlignmentCenter;
		SC_SWITCH_CASE(string, @"Left")
			return UIControlContentHorizontalAlignmentLeft;
		SC_SWITCH_CASE(string, @"Right")
			return UIControlContentHorizontalAlignmentRight;
		SC_SWITCH_CASE(string, @"Fill")
			return UIControlContentHorizontalAlignmentFill;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

@implementation SCControl

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib

- (void) dealloc
{
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
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		_scTag = 0;
		self.nodeFile = nil;
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

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIControl *)control
{
	if (![SCView setAttributes:dict to:control]) {
		SCLog(@"failed to set attributes: %@", dict);
		return NO;
	}
	
	// enabled
	id enabled = [dict objectForKey:@"enabled"];
	if (enabled) {
		control.enabled = [enabled boolValue];
	}
	
	// selected
	id selected = [dict objectForKey:@"selected"];
	if (selected) {
		control.selected = [selected boolValue];
	}
	
	// highlighted
	id highlighted = [dict objectForKey:@"highlighted"];
	if (highlighted) {
		control.highlighted = [highlighted boolValue];
	}
	
	// contentVerticalAlignment
	NSString * contentVerticalAlignment = [dict objectForKey:@"contentVerticalAlignment"];
	if (contentVerticalAlignment) {
		control.contentVerticalAlignment = UIControlContentVerticalAlignmentFromString(contentVerticalAlignment);
	}
	
	// contentHorizontalAlignment
	NSString * contentHorizontalAlignment = [dict objectForKey:@"contentHorizontalAlignment"];
	if (contentHorizontalAlignment) {
		control.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFromString(contentHorizontalAlignment);
	}
	
	return YES;
}

@end
