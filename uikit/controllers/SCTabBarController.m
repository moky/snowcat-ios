//
//  SCTabBarController.m
//  SnowCat
//
//  Created by Moky on 14-3-17.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCDevice.h"
#import "SCNib.h"
#import "SCTabBar.h"
#import "SCTabBarControllerDelegate.h"
#import "SCTabBarController.h"

@interface SCTabBarController ()

@property(nonatomic, retain) id<SCTabBarControllerDelegate> tabBarControllerDelegate;

@end

@implementation SCTabBarController

@synthesize scTag = _scTag;
@synthesize tabBarControllerDelegate = _tabBarControllerDelegate;

- (void) dealloc
{
	[_tabBarControllerDelegate release];
	
	[SCResponder onDestroy:self.view];
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCTabBarController
{
	_scTag = 0;
	self.tabBarControllerDelegate = nil;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCTabBarController];
	}
	return self;
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		[self _initializeSCTabBarController];
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	// initWithNibName:bundle:
	NSString * nibName = [SCNib nibNameFromDictionary:dict];
	
	NSBundle * bundle = [SCNib bundleFromDictionary:dict autorelease:NO];
	self = [self initWithNibName:nibName bundle:bundle];
	[bundle release];
	
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
		self.tabBarControllerDelegate = [SCTabBarControllerDelegate create:delegate];
		// self.delegate only assign but won't retain the action delegate,
		// so don't release it now
		self.delegate = _tabBarControllerDelegate;
	}
}

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UITabBarController *)tabBarController
{
	if (![SCViewController setAttributes:dict to:tabBarController]) {
		SCLog(@"failed to set attributes: %@", dict);
		return NO;
	}
	
	// viewControllers
	NSArray * viewControllers = [dict objectForKey:@"viewControllers"];
	if (viewControllers) {
		NSAssert([viewControllers isKindOfClass:[NSArray class]], @"viewControllers must be an array: %@", viewControllers);
		NSMutableArray * mArray = [[NSMutableArray alloc] initWithCapacity:[viewControllers count]];
		
		NSEnumerator * enumerator = [viewControllers objectEnumerator];
		NSDictionary * item;
		SCViewController * child;
		while (item = [enumerator nextObject]) {
			NSAssert([item isKindOfClass:[NSDictionary class]], @"viewControllers's item must be a dictionary: %@", item);
			SC_UIKIT_DIG_CREATION_INFO(item); // support ObjectFromFile
			child = [SCViewController create:item autorelease:NO];
			NSAssert([child isKindOfClass:[UIViewController class]], @"viewControllers item's definition error: %@", item);
			if (child) {
				SC_UIKIT_SET_ATTRIBUTES(child, SCViewController, item);
				[mArray addObject:child];
				[child release];
			}
		}
		
		tabBarController.viewControllers = mArray;
		[mArray release];
	}
	
	// selectedViewController
	
	// selectedIndex
	NSUInteger selectedIndex = [[dict objectForKey:@"selectedIndex"] integerValue];
	tabBarController.selectedIndex = selectedIndex;
	
	// moreNavigationController
	
	// customizableViewControllers
	
	// tabBar
	NSDictionary * tabBar = [dict objectForKey:@"tabBar"];
	if (tabBar) {
		SC_UIKIT_SET_ATTRIBUTES(tabBarController.tabBar, SCTabBar, tabBar);
	}
	
	return YES;
}

// view loading functions
SC_UIKIT_VIEW_CONTROLLER_IMPLEMENT_LOAD_VIEW_FUNCTIONS()

// Autorotate
SC_UIKIT_IMPLEMENT_AUTOROTATE_FUNCTIONS_WITH_CHILD(self.selectedViewController)

@end
