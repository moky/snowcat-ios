//
//  SCTabBar.m
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCClient.h"
#import "SCInterface.h"
#import "SCColor.h"
#import "SCImage.h"
#import "SCTabBarItem.h"
#import "SCTabBarDelegate.h"
#import "SCTabBar.h"

//typedef NS_ENUM(NSInteger, UITabBarItemPositioning) {
//	UITabBarItemPositioningAutomatic,
//	UITabBarItemPositioningFill,
//	UITabBarItemPositioningCentered,
//} NS_ENUM_AVAILABLE_IOS(7_0);
UITabBarItemPositioning UITabBarItemPositioningFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Auto")
			return UITabBarItemPositioningAutomatic;
		SC_SWITCH_CASE(string, @"Fill")
			return UITabBarItemPositioningFill;
		SC_SWITCH_CASE(string, @"Center")
			return UITabBarItemPositioningCentered;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

@interface SCTabBar ()

@property(nonatomic, retain) SCTabBarDelegate * tabBarDelegate;

@end

@implementation SCTabBar

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib
@synthesize tabBarDelegate = _tabBarDelegate;

- (void) dealloc
{
	[_tabBarDelegate release];
	[_nodeFile release];
	
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCTabBar
{
	_scTag = 0;
	self.nodeFile = nil;
	
	self.tabBarDelegate = nil;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCTabBar];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeSCTabBar];
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
- (void) buildHandlers:(NSDictionary *)dict
{
	[SCResponder onCreate:self withDictionary:dict];
	
	NSDictionary * delegate = [dict objectForKey:@"delegate"];
	if (delegate) {
		self.tabBarDelegate = [SCTabBarDelegate create:delegate];
		// self.delegate only assign but won't retain the action delegate,
		// so don't release it now
		self.delegate = _tabBarDelegate;
	}
}

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) _setIOS6Attributes:(NSDictionary *)dict to:(UITabBar *)tabBar
{
#ifdef __IPHONE_6_0
	
	CGFloat systemVersion = SCSystemVersion();
	if (systemVersion < 6.0f) {
		return NO;
	}
	
	// shadowImage
	NSDictionary * shadowImage = [dict objectForKey:@"shadowImage"];
	if (shadowImage) {
		SCImage * image = [SCImage create:shadowImage autorelease:NO];
		tabBar.shadowImage = image;
		[image release];
	}
	
#endif
	return YES;
}

+ (BOOL) _setIOS7Attributes:(NSDictionary *)dict to:(UITabBar *)tabBar
{
#ifdef __IPHONE_7_0
	
	CGFloat systemVersion = SCSystemVersion();
	if (systemVersion < 7.0f) {
		return NO;
	}
	
	// barTintColor
	NSDictionary * barTintColor = [dict objectForKey:@"barTintColor"];
	if (barTintColor) {
		SCColor * color = [SCColor create:barTintColor autorelease:NO];
		tabBar.barTintColor = color;
		[color release];
	}
	
	// itemPositioning
	NSString * itemPositioning = [dict objectForKey:@"itemPositioning"];
	if (itemPositioning) {
		tabBar.itemPositioning = UITabBarItemPositioningFromString(itemPositioning);
	}
	
	// itemWidth
	id itemWidth = [dict objectForKey:@"itemWidth"];
	if (itemWidth) {
		tabBar.itemWidth = [itemWidth floatValue];
	}
	
	// itemSpacing
	id itemSpacing = [dict objectForKey:@"itemSpacing"];
	if (itemSpacing) {
		tabBar.itemSpacing = [itemSpacing floatValue];
	}
	
	// barStyle
	NSString * barStyle = [dict objectForKey:@"barStyle"];
	if (barStyle) {
		tabBar.barStyle = UIBarStyleFromString(barStyle);
	}
	
	// translucent
	id translucent = [dict objectForKey:@"translucent"];
	if (translucent) {
		tabBar.translucent = [translucent boolValue];
	}
	
#endif
	return YES;
}

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UITabBar *)tabBar
{
	if (![SCView setAttributes:dict to:tabBar]) {
		return NO;
	}
	
	// items
	NSArray * items = [dict objectForKey:@"items"];
	if (items) {
		NSUInteger count = [items count];
		NSMutableArray * mArray = [[NSMutableArray alloc] initWithCapacity:count];
		
		NSEnumerator * enumerator = [items objectEnumerator];
		NSDictionary * item;
		SCTabBarItem * tbi;
		while (item = [enumerator nextObject]) {
			NSAssert([item isKindOfClass:[NSDictionary class]], @"item must be a dictionary: %@", item);
			tbi = [SCTabBarItem create:item autorelease:NO];
			NSAssert([tbi isKindOfClass:[UITabBarItem class]], @"tab bar item's definition error: %@", item);
			if (tbi) {
				SC_UIKIT_SET_ATTRIBUTES(tbi, SCTabBarItem, item);
				[mArray addObject:tbi];
				[tbi release];
			}
		}
		tabBar.items = mArray;
		
		[mArray release];
	}
	
	// selectedItem (assign)
	
	// tintColor
	NSDictionary * tintColor = [dict objectForKey:@"tintColor"];
	if (tintColor) {
		SCColor * color = [SCColor create:tintColor autorelease:NO];
		tabBar.tintColor = color;
		[color release];
	}
	
	// selectedImageTintColor
	NSDictionary * selectedImageTintColor = [dict objectForKey:@"selectedImageTintColor"];
	if (selectedImageTintColor) {
		SCColor * color = [SCColor create:selectedImageTintColor autorelease:NO];
		tabBar.selectedImageTintColor = color;
		[color release];
	}
	
	// backgroundImage
	NSDictionary * backgroundImage = [dict objectForKey:@"backgroundImage"];
	if (backgroundImage) {
		SCImage * image = [SCImage create:backgroundImage autorelease:NO];
		tabBar.backgroundImage = image;
		[image release];
	}
	
	// selectionIndicatorImage
	NSDictionary * selectionIndicatorImage = [dict objectForKey:@"selectionIndicatorImage"];
	if (selectionIndicatorImage) {
		SCImage * image = [SCImage create:selectionIndicatorImage autorelease:NO];
		tabBar.selectionIndicatorImage = image;
		[image release];
	}
	
	[self _setIOS6Attributes:dict to:tabBar];
	
	return YES;
}

@end
