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
	
	// enabled
	id enabled = [dict objectForKey:@"enabled"];
	if (enabled) {
		barItem.enabled = [enabled boolValue];
	}
	
	// title
	NSString * title = [dict objectForKey:@"title"];
	if (title) {
		title = SCLocalizedString(title, nil);
		barItem.title = title;
	}
	
	// image
	NSDictionary * image = [dict objectForKey:@"image"];
	if (image) {
		SCImage * img = [SCImage create:image autorelease:NO];
		barItem.image = img;
		[img release];
	}
	
	// landscapeImagePhone
	NSDictionary * landscapeImagePhone = [dict objectForKey:@"landscapeImagePhone"];
	if (landscapeImagePhone) {
		SCImage * img = [SCImage create:landscapeImagePhone autorelease:NO];
		barItem.landscapeImagePhone = img;
		[img release];
	}
	
	// imageInsets
	NSString * imageInsets = [dict objectForKey:@"imageInsets"];
	if (imageInsets) {
		barItem.imageInsets = UIEdgeInsetsFromString(imageInsets);
	}
	
	// landscapeImagePhoneInsets
	NSString * landscapeImagePhoneInsets = [dict objectForKey:@"landscapeImagePhoneInsets"];
	if (landscapeImagePhoneInsets) {
		barItem.landscapeImagePhoneInsets = UIEdgeInsetsFromString(landscapeImagePhoneInsets);
	}
	
	// tag
	id tag = [dict objectForKey:@"tag"];
	if (tag) {
		barItem.tag = [tag integerValue];
	}
	
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
