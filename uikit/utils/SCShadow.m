//
//  SCShadow.m
//  SnowCat
//
//  Created by Moky on 15-5-14.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCColor.h"
#import "SCShadow.h"

@implementation SCShadow

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	self = [self init];
	if (self) {
		[self setAttributes:dict];
	}
	return self;
}

// create:
SC_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

//@property (nonatomic, assign) CGSize shadowOffset;      // offset in user space of the shadow from the original drawing
//@property (nonatomic, assign) CGFloat shadowBlurRadius; // blur radius of the shadow in default user space units
//@property (nonatomic, retain) id shadowColor;           // color used for the shadow (default is black with an alpha value of 1/3)
+ (BOOL) setAttributes:(NSDictionary *)dict to:(NSShadow *)shadow
{
	NSAssert([dict isKindOfClass:[NSDictionary class]], @"parameters error: %@", dict);
	
	// shadowOffset
	NSString * shadowOffset = [dict objectForKey:@"shadowOffset"];
	if (shadowOffset) {
		shadow.shadowOffset = CGSizeFromString(shadowOffset);
	}
	
	SC_SET_ATTRIBUTES_AS_FLOAT(shadow, dict, shadowBlurRadius);
	
	SC_SET_ATTRIBUTES_AS_UICOLOR(shadow, dict, shadowColor);
	
	return YES;
}

@end
