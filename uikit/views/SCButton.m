//
//  SCButton.m
//  SnowCat
//
//  Created by Moky on 14-3-18.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCClient.h"
#import "SCAttributedString.h"
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
		SC_SWITCH_CASE(string, @"Round")   // RoundedRect
			return UIButtonTypeRoundedRect;
		SC_SWITCH_CASE(string, @"Detail")  // DetailDisclosure
			return UIButtonTypeDetailDisclosure;
		SC_SWITCH_CASE(string, @"Light")   // InfoLight
			return UIButtonTypeInfoLight;
		SC_SWITCH_CASE(string, @"Dark")    // InfoDark
			return UIButtonTypeInfoDark;
		SC_SWITCH_CASE(string, @"Contact") // ContactAdd
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
	
	// titleColor
	id titleColor = [dict objectForKey:@"titleColor"];
	if (!titleColor) {
		titleColor = [dict objectForKey:@"color"];
	}
	if (titleColor) {
		SCColor * color = [SCColor create:titleColor];
		[button setTitleColor:color forState:state];
	}
	
	// titleShadowColor
	id titleShadowColor = [dict objectForKey:@"titleShadowColor"];
	if (!titleShadowColor) {
		titleShadowColor = [dict objectForKey:@"shadowColor"];
	}
	if (titleShadowColor) {
		SCColor * color = [SCColor create:titleShadowColor];
		[button setTitleShadowColor:color forState:state];
	}
	
	// image
	id image = [dict objectForKey:@"image"];
	if (image) {
		SCImage * img = [SCImage create:image];
		[button setImage:img forState:state];
	}
	
	// background image
	id backgroundImage = [dict objectForKey:@"backgroundImage"];
	if (!backgroundImage) {
		backgroundImage = [dict objectForKey:@"background"];
	}
	if (backgroundImage) {
		SCImage * bg = [SCImage create:backgroundImage];
		[button setBackgroundImage:bg forState:state];
	}
	
#ifdef __IPHONE_6_0
	CGFloat systemVersion = SCSystemVersion();
	if (systemVersion < 6.0f) {
		return YES;
	}
	
	// attributedTitle
	id attributedTitle = [dict objectForKey:@"attributedTitle"];
	if (attributedTitle) {
		NSAttributedString * as = [SCAttributedString create:attributedTitle];
		[button setAttributedTitle:as forState:state];
	}
#endif
	
	return YES;
}

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIButton *)button
{
	NSAssert([dict isKindOfClass:[NSDictionary class]], @"parameters error: %@", dict);
	
	SC_SET_ATTRIBUTES_AS_UIEDGEINSETS(button, dict, contentEdgeInsets);
	SC_SET_ATTRIBUTES_AS_UIEDGEINSETS(button, dict, titleEdgeInsets);
	SC_SET_ATTRIBUTES_AS_BOOL        (button, dict, reversesTitleShadowWhenHighlighted);
	SC_SET_ATTRIBUTES_AS_UIEDGEINSETS(button, dict, imageEdgeInsets);
	SC_SET_ATTRIBUTES_AS_BOOL        (button, dict, adjustsImageWhenHighlighted);
	SC_SET_ATTRIBUTES_AS_BOOL        (button, dict, adjustsImageWhenDisabled);
#if !TARGET_OS_TV
	SC_SET_ATTRIBUTES_AS_BOOL        (button, dict, showsTouchWhenHighlighted);
#endif
	SC_SET_ATTRIBUTES_AS_UICOLOR     (button, dict, tintColor);
	
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
	// because we need to call 'sizeToFit',
	// so must setting the geometry attributes before calling super
	return [SCControl setAttributes:dict to:button];
}

#pragma mark - Button Interfaces

- (void) onClick:(id)sender
{
	SCLog(@"onClick: %@", sender);
	SCDoEvent(@"onClick", sender);
}

@end
