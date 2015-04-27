//
//  SCNavigationBar.m
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Moky. All rights reserved.
//

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
	
	// translucent
	id translucent = [dict objectForKey:@"translucent"];
	if (translucent) {
		navigationBar.translucent = [translucent boolValue];
	}
	
	// items
	
	// tintColor
	NSDictionary * tintColor = [dict objectForKey:@"tintColor"];
	if (tintColor) {
		SCColor * color = [SCColor create:tintColor autorelease:NO];
		navigationBar.tintColor = color;
		[color release];
	}
	
	// shadowImage
	NSDictionary * shadowImage = [dict objectForKey:@"shadowImage"];
	if (shadowImage) {
		SCImage * image = [SCImage create:shadowImage autorelease:NO];
		navigationBar.shadowImage = image;
		[image release];
	}
	
	// titleTextAttributes
	NSDictionary * titleTextAttributes = [dict objectForKey:@"titleTextAttributes"];
	if (titleTextAttributes) {
		navigationBar.titleTextAttributes = titleTextAttributes;
	}
	
	return YES;
}

@end
