//
//  SCTabBar.m
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
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
		SC_SWITCH_CASE(string, @"Auto")   // Automatic
			return UITabBarItemPositioningAutomatic;
		SC_SWITCH_CASE(string, @"Fill")
			return UITabBarItemPositioningFill;
		SC_SWITCH_CASE(string, @"Center") // Centered
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

+ (BOOL) _setIOS7Attributes:(NSDictionary *)dict to:(UITabBar *)tabBar
{
#ifdef __IPHONE_7_0
	
	CGFloat systemVersion = SCSystemVersion();
	if (systemVersion < 7.0f) {
		return NO;
	}
	
	SC_SET_ATTRIBUTES_AS_UICOLOR(tabBar, dict, barTintColor);
	
	// itemPositioning
	NSString * itemPositioning = [dict objectForKey:@"itemPositioning"];
	if (itemPositioning) {
		tabBar.itemPositioning = UITabBarItemPositioningFromString(itemPositioning);
	}
	
	SC_SET_ATTRIBUTES_AS_FLOAT(tabBar, dict, itemWidth);
	SC_SET_ATTRIBUTES_AS_FLOAT(tabBar, dict, itemSpacing);
	
	// barStyle
	NSString * barStyle = [dict objectForKey:@"barStyle"];
	if (barStyle) {
		tabBar.barStyle = UIBarStyleFromString(barStyle);
	}
	
	SC_SET_ATTRIBUTES_AS_BOOL(tabBar, dict, translucent);
	
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
		
		NSDictionary * item;
		SCTabBarItem * tbi;
		SC_FOR_EACH(item, items) {
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
	
	// selectedImageTintColor
	NSDictionary * selectedImageTintColor = [dict objectForKey:@"selectedImageTintColor"];
	if (selectedImageTintColor) {
		SCColor * color = [SCColor create:selectedImageTintColor autorelease:NO];
		//tabBar.selectedImageTintColor = color;
		tabBar.tintColor = color;
		[color release];
	}
	
	SC_SET_ATTRIBUTES_AS_UICOLOR(tabBar, dict, tintColor);
	SC_SET_ATTRIBUTES_AS_UIIMAGE(tabBar, dict, backgroundImage);
	SC_SET_ATTRIBUTES_AS_UIIMAGE(tabBar, dict, selectionIndicatorImage);
	SC_SET_ATTRIBUTES_AS_UIIMAGE(tabBar, dict, shadowImage);
	
	[self _setIOS7Attributes:dict to:tabBar];
	
	return YES;
}

@end
