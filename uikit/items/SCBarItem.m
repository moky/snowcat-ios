//
//  SCBarItem.m
//  SnowCat
//
//  Created by Moky on 14-3-17.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCAttributedString+UIKit.h"
#import "SCImage.h"
#import "SCBarItem.h"

@implementation SCBarItem

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	self = [self init];
	if (self) {
	}
	return self;
}

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIBarItem *)barItem forState:(UIControlState)state
{
	NSAssert([dict isKindOfClass:[NSDictionary class]], @"parameters error: %@", dict);
	
	// titleTextAttributes
	NSDictionary * titleTextAttributes = [dict objectForKey:@"titleTextAttributes"];
	if (titleTextAttributes) {
		NSDictionary * attr = [SCAttributedString attributesWithDictionary:titleTextAttributes];
		NSAssert([attr isKindOfClass:[NSDictionary class]], @"error: %@", titleTextAttributes);
		[barItem setTitleTextAttributes:attr forState:state];
	}
	
	return YES;
}

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIBarItem *)barItem
{
	NSAssert([dict isKindOfClass:[NSDictionary class]], @"parameters error: %@", dict);
	
	SC_SET_ATTRIBUTES_AS_BOOL            (barItem, dict, enabled);
	SC_SET_ATTRIBUTES_AS_LOCALIZED_STRING(barItem, dict, title);
	SC_SET_ATTRIBUTES_AS_UIIMAGE         (barItem, dict, image);
	SC_SET_ATTRIBUTES_AS_UIEDGEINSETS    (barItem, dict, imageInsets);
#if !TARGET_OS_TV
	SC_SET_ATTRIBUTES_AS_UIIMAGE         (barItem, dict, landscapeImagePhone);
	SC_SET_ATTRIBUTES_AS_UIEDGEINSETS    (barItem, dict, landscapeImagePhoneInsets);
#endif
	SC_SET_ATTRIBUTES_AS_INTEGER         (barItem, dict, tag);
	
	// control states
	NSDictionary * states = [dict objectForKey:@"states"];
	{
		// normal
		NSDictionary * normal = [states objectForKey:@"normal"];
		if (!normal) {
			normal = dict; // default values
		}
		[self setAttributes:normal to:barItem forState:UIControlStateNormal];
		
		// highlighted
		NSDictionary * highlighted = [states objectForKey:@"highlighted"];
		if (highlighted) {
			[self setAttributes:highlighted to:barItem forState:UIControlStateHighlighted];
		}
		
		// disabled
		NSDictionary * disabled = [states objectForKey:@"disabled"];
		if (disabled) {
			[self setAttributes:disabled to:barItem forState:UIControlStateDisabled];
		}
		
		// selected
		NSDictionary * selected = [states objectForKey:@"selected"];
		if (selected) {
			[self setAttributes:selected to:barItem forState:UIControlStateSelected];
		}
	}
	
	return YES;
}

@end
