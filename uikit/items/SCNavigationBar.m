//
//  SCNavigationBar.m
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCClient.h"
#import "SCInterface.h"
#import "SCColor.h"
#import "SCImage.h"
#import "SCNavigationBar.h"

@implementation SCNavigationBar

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib

- (void) dealloc
{
	[_nodeFile release];
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCNavigationBar
{
	_scTag = 0;
	self.nodeFile = nil;
	
	// default properties
//	self.translucent = NO;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCNavigationBar];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeSCNavigationBar];
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

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) _setIOS7Attributes:(NSDictionary *)dict to:(UINavigationBar *)navigationBar
{
#ifdef __IPHONE_7_0
	
	CGFloat systemVersion = SCSystemVersion();
	if (systemVersion < 7.0f) {
		return NO;
	}
	
	SC_SET_ATTRIBUTES_AS_UICOLOR(navigationBar, dict, barTintColor);
	SC_SET_ATTRIBUTES_AS_UIIMAGE(navigationBar, dict, backIndicatorImage);
	SC_SET_ATTRIBUTES_AS_UIIMAGE(navigationBar, dict, backIndicatorTransitionMaskImage);
	
#endif
	
	return YES;
}

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UINavigationBar *)navigationBar
{
	if (![SCView setAttributes:dict to:navigationBar]) {
		return NO;
	}
	
	// barStyle
	NSString * barStyle = [dict objectForKey:@"barStyle"];
	if (barStyle) {
		navigationBar.barStyle = UIBarStyleFromString(barStyle);
	}
	
	// delegate
	
	SC_SET_ATTRIBUTES_AS_BOOL   (navigationBar, dict, translucent);
	
	// items
	
	SC_SET_ATTRIBUTES_AS_UICOLOR(navigationBar, dict, tintColor);
	SC_SET_ATTRIBUTES_AS_UIIMAGE(navigationBar, dict, shadowImage);
	
	// titleTextAttributes
	NSDictionary * titleTextAttributes = [dict objectForKey:@"titleTextAttributes"];
	if (titleTextAttributes) {
		// TODO: convert the keys & values
		navigationBar.titleTextAttributes = titleTextAttributes;
	}
	
	return YES;
}

@end
