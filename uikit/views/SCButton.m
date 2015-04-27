//
//  SCButton.m
//  SnowCat
//
//  Created by Moky on 14-3-18.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCLog.h"
#import "SCNib.h"
#import "SCColor.h"
#import "SCImage.h"
#import "SCEventHandler.h"
#import "SCButton.h"

//typedef NS_ENUM(NSInteger, UIButtonType) {
//    UIButtonTypeCustom = 0,           // no button type
//    UIButtonTypeRoundedRect,          // rounded rect, flat white button, like in address card
//	
//    UIButtonTypeDetailDisclosure,
//    UIButtonTypeInfoLight,
//    UIButtonTypeInfoDark,
//    UIButtonTypeContactAdd,
//};
UIButtonType UIButtonTypeFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Custom")
			return UIButtonTypeCustom;
		SC_SWITCH_CASE(string, @"Round")
			return UIButtonTypeRoundedRect;
		SC_SWITCH_CASE(string, @"Detail")
			return UIButtonTypeDetailDisclosure;
		SC_SWITCH_CASE(string, @"Light")
			return UIButtonTypeInfoLight;
		SC_SWITCH_CASE(string, @"Dark")
			return UIButtonTypeInfoDark;
		SC_SWITCH_CASE(string, @"Contact")
			return UIButtonTypeContactAdd;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

@implementation SCButton

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib

- (void) dealloc
{
	[_nodeFile release];
	
	[self removeTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
	
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCButton
{
	_scTag = 0;
	self.nodeFile = nil;
	
	// Note that the target is not retained, so this assignment won't cause memory leaks
	[self addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCButton];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeSCButton];
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

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIButton *)button forState:(UIControlState)state
{
	NSAssert([dict isKindOfClass:[NSDictionary class]], @"parameters error: %@", dict);
	
	// title
	NSString * title = [dict objectForKey:@"title"];
	if (title) {
		title = SCLocalizedString(title, nil);
		[button setTitle:title forState:state];
	}
	
	// color
	id color = [dict objectForKey:@"color"];
	if (color) {
		SCColor * titleColor = [SCColor create:color autorelease:NO];
		[button setTitleColor:titleColor forState:state];
		[titleColor release];
	}
	
	// image
	id image = [dict objectForKey:@"image"];
	if (image) {
		SCImage * img = [SCImage create:image autorelease:NO];
		[button setImage:img forState:state];
		[img release];
	}
	
	// background image
	id backgroundImage = [dict objectForKey:@"backgroundImage"];
	if (!backgroundImage) {
		backgroundImage = [dict objectForKey:@"background"];
	}
	if (backgroundImage) {
		SCImage * bg = [SCImage create:backgroundImage autorelease:NO];
		[button setBackgroundImage:bg forState:state];
		[bg release];
	}
	
	return YES;
}

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIButton *)button
{
	NSAssert([dict isKindOfClass:[NSDictionary class]], @"parameters error: %@", dict);
	
	// control states
	NSDictionary * states = [dict objectForKey:@"states"];
	{
		// normal
		NSDictionary * normal = [states objectForKey:@"normal"];
		if (!normal) {
			normal = dict; // default values
		}
		[self setAttributes:normal to:button forState:UIControlStateNormal];
		
		// highlighted
		NSDictionary * highlighted = [states objectForKey:@"highlighted"];
		if (highlighted) {
			[self setAttributes:highlighted to:button forState:UIControlStateHighlighted];
		}
		
		// disabled
		NSDictionary * disabled = [states objectForKey:@"disabled"];
		if (disabled) {
			[self setAttributes:disabled to:button forState:UIControlStateDisabled];
		}
		
		// selected
		NSDictionary * selected = [states objectForKey:@"selected"];
		if (selected) {
			[self setAttributes:selected to:button forState:UIControlStateSelected];
		}
	}
	[button sizeToFit];
	
	if (![SCControl setAttributes:dict to:button]) {
		SCLog(@"failed to set attributes: %@", dict);
		return NO;
	}
	
	return YES;
}

#pragma mark - Button Interfaces

- (void) onClick:(id)sender
{
	SCLog(@"onClick: %@", sender);
	SCDoEvent(@"onClick", sender);
}

@end
