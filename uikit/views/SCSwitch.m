//
//  SCSwitch.m
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCEventHandler.h"
#import "SCNib.h"
#import "SCColor.h"
#import "SCImage.h"
#import "SCSwitch.h"

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
	
	// onTintColor
	NSDictionary * onTintColor = [dict objectForKey:@"onTintColor"];
	if (onTintColor) {
		SCColor * color = [SCColor create:onTintColor autorelease:NO];
		uiSwitch.onTintColor = color;
		[color release];
	}
	
	// tintColor
	NSDictionary * tintColor = [dict objectForKey:@"tintColor"];
	if (tintColor) {
		SCColor * color = [SCColor create:tintColor autorelease:NO];
		uiSwitch.tintColor = color;
		[color release];
	}
	
	// thumbTintColor
	NSDictionary * thumbTintColor = [dict objectForKey:@"thumbTintColor"];
	if (thumbTintColor) {
		SCColor * color = [SCColor create:thumbTintColor autorelease:NO];
		uiSwitch.thumbTintColor = color;
		[color release];
	}
	
	// onImage
	NSDictionary * onImage = [dict objectForKey:@"onImage"];
	if (onImage) {
		SCImage * image = [SCImage create:onImage autorelease:NO];
		uiSwitch.onImage = image;
		[image release];
	}
	
	// offImage
	NSDictionary * offImage = [dict objectForKey:@"offImage"];
	if (offImage) {
		SCImage * image = [SCImage create:offImage autorelease:NO];
		uiSwitch.offImage = image;
		[image release];
	}
	
	// on
	id on = [dict objectForKey:@"on"];
	if (on) {
		uiSwitch.on = [on boolValue];
	}
	
	return YES;
}

- (void) setOn:(BOOL)on
{
	if (on != self.on) {
		// value changed, fire event
		NSString * eventName = on ? @"onSwitchOn" : @"onSwitchOff";
		SCDoEvent(eventName, self);
	}
	[super setOn:on];
}

@end
