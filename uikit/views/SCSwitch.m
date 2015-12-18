//
//  SCSwitch.m
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCEventHandler.h"
#import "SCNib.h"
#import "SCColor.h"
#import "SCImage.h"
#import "SCSwitch.h"

#if !TARGET_OS_TV

@implementation SCSwitch

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

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UISwitch *)uiSwitch
{
	if (![SCControl setAttributes:dict to:uiSwitch]) {
		return NO;
	}
	
	SC_SET_ATTRIBUTES_AS_UICOLOR(uiSwitch, dict, onTintColor);
	SC_SET_ATTRIBUTES_AS_UICOLOR(uiSwitch, dict, tintColor);
	SC_SET_ATTRIBUTES_AS_UICOLOR(uiSwitch, dict, thumbTintColor);
	SC_SET_ATTRIBUTES_AS_UIIMAGE(uiSwitch, dict, onImage);
	SC_SET_ATTRIBUTES_AS_UIIMAGE(uiSwitch, dict, offImage);
	SC_SET_ATTRIBUTES_AS_BOOL   (uiSwitch, dict, on);
	
	return YES;
}

- (void) setOn:(BOOL)on
{
	if (on == self.on) {
		[super setOn:on];
	} else {
		[super setOn:on];
		// value changed, fire event
		NSString * eventName = on ? @"onSwitchOn" : @"onSwitchOff";
		SCDoEvent(eventName, self);
	}
}

@end

#endif
