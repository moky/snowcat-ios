//
//  SCViewController.m
//  SnowCat
//
//  Created by Moky on 14-3-17.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCClient.h"
#import "SCDevice.h"
#import "SCApplication.h"
#import "SCNib.h"
#import "SCGeometry.h"
#import "SCTabBarItem.h"
#import "SCTabBarController.h"
#import "SCBarButtonItem.h"
#import "SCNavigationItem.h"
#import "SCNavigationController.h"
#import "SCView.h"
#import "SCViewController.h"

//typedef NS_ENUM(NSInteger, UIModalTransitionStyle) {
//    UIModalTransitionStyleCoverVertical = 0,
//    UIModalTransitionStyleFlipHorizontal,
//    UIModalTransitionStyleCrossDissolve,
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_2
//    UIModalTransitionStylePartialCurl,
//#endif
//};
UIModalTransitionStyle UIModalTransitionStyleFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Vertical")
			return UIModalTransitionStyleCoverVertical;
		SC_SWITCH_CASE(string, @"Horizontal")
			return UIModalTransitionStyleFlipHorizontal;
		SC_SWITCH_CASE(string, @"Cross")
			return UIModalTransitionStyleCrossDissolve;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_2
		SC_SWITCH_CASE(string, @"Curl")
			return UIModalTransitionStylePartialCurl;
#endif
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

//typedef NS_ENUM(NSInteger, UIModalPresentationStyle) {
//    UIModalPresentationFullScreen = 0,
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_2
//    UIModalPresentationPageSheet,
//    UIModalPresentationFormSheet,
//    UIModalPresentationCurrentContext,
//#endif
//};
UIModalPresentationStyle UIModalPresentationStyleFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"FullScreen")
			return UIModalPresentationFullScreen;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_2
		SC_SWITCH_CASE(string, @"Page")
			return UIModalPresentationPageSheet;
		SC_SWITCH_CASE(string, @"Form")
			return UIModalPresentationFormSheet;
		SC_SWITCH_CASE(string, @"Current")
			return UIModalPresentationCurrentContext;
#endif
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

#ifdef __IPHONE_7_0

//typedef NS_OPTIONS(NSUInteger, UIRectEdge) {
//    UIRectEdgeNone   = 0,
//    UIRectEdgeTop    = 1 << 0,
//    UIRectEdgeLeft   = 1 << 1,
//    UIRectEdgeBottom = 1 << 2,
//    UIRectEdgeRight  = 1 << 3,
//    UIRectEdgeAll    = UIRectEdgeTop | UIRectEdgeLeft | UIRectEdgeBottom | UIRectEdgeRight
//} NS_ENUM_AVAILABLE_IOS(7_0);
UIRectEdge UIRectEdgeFromString(NSString * string)
{
	// all
	if ([string rangeOfString:@"All"].location != NSNotFound) {
		return UIRectEdgeAll;
	}
	
	// none
	if ([string rangeOfString:@"None"].location != NSNotFound) {
		return UIRectEdgeNone;
	}
	
	NSUInteger edge = 0;
	
	// top
	if ([string rangeOfString:@"Top"].location != NSNotFound) {
		edge |= UIRectEdgeTop;
	}
	// left
	if ([string rangeOfString:@"Left"].location != NSNotFound) {
		edge |= UIRectEdgeLeft;
	}
	// right
	if ([string rangeOfString:@"Right"].location != NSNotFound) {
		edge |= UIRectEdgeRight;
	}
	// bottom
	if ([string rangeOfString:@"Bottom"].location != NSNotFound) {
		edge |= UIRectEdgeBottom;
	}
	
	return edge;
}

#endif

@interface SCViewController () {
	
	NSUInteger _supportedInterfaceOrientations;
}

@end

@implementation SCViewController

@synthesize scTag = _scTag;

- (void) dealloc
{
	[SCResponder onDestroy:self.view];
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCViewController
{
	_scTag = 0;
	_supportedInterfaceOrientations = SC_UIKIT_DEFAULT_SUPPORTED_INTERFACE_ORIENTATIONS;
	
//#ifdef __IPHONE_7_0
//	
//	CGFloat systemVersion = SCSystemVersion();
//	if (systemVersion >= 7.0f) {
//		self.edgesForExtendedLayout = UIRectEdgeNone;
//	}
//	
//#endif
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCViewController];
	}
	return self;
}

/*
 The designated initializer.
 */
- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		[self _initializeSCViewController];
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
SC_UIKIT_IMELEMENT_BUILD_HANDLERS_FUNCTION()

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_VIEW_CONTROLLER_IMPLEMENT_SET_ATTRIBUTES_WITH_ORIENTATIONS(_supportedInterfaceOrientations, @"supportedInterfaceOrientations")

+ (BOOL) _setEditingAttributes:(NSDictionary *)dict to:(UIViewController *)viewController
{
	// editing
	id editing = [dict objectForKey:@"editing"];
	if (editing) {
		viewController.editing = [editing boolValue];
	}
	
	return YES;
}

+ (BOOL) _setProtectedMethods:(NSDictionary *)dict to:(UIViewController *)viewController
{
	// childViewControllers
	NSArray * childViewControllers = [dict objectForKey:@"childViewControllers"];
	if (childViewControllers) {
		NSAssert([childViewControllers isKindOfClass:[NSArray class]], @"childViewControllers must be an array: %@", childViewControllers);
		NSEnumerator * enumerator = [childViewControllers objectEnumerator];
		NSDictionary * item;
		SCViewController * child;
		while (item = [enumerator nextObject]) {
			NSAssert([item isKindOfClass:[NSDictionary class]], @"childViewControllers's item must be a dictionary: %@", item);
			SC_UIKIT_DIG_CREATION_INFO(item); // support ObjectFromFile
			child = [SCViewController create:item autorelease:NO];
			NSAssert([child isKindOfClass:[UIViewController class]], @"childViewControllers item's definition error: %@", item);
			if (child) {
				// add to parent first
				[viewController addChildViewController:child];
				[viewController.view addSubview:child.view]; // add view
				// and then set attributes
				SC_UIKIT_SET_ATTRIBUTES(child, SCViewController, item);
				[child release];
			}
		}
	}
	
	return YES;
}

+ (BOOL) _setStateRestorationAttributes:(NSDictionary *)dict to:(UIViewController *)viewController
{
	// restorationIdentifier
	NSString * restorationIdentifier = [dict objectForKey:@"restorationIdentifier"];
	if (restorationIdentifier) {
		viewController.restorationIdentifier = restorationIdentifier;
	}
	
	NSString * restorationClass = [dict objectForKey:@"restorationClass"];
	if (restorationClass) {
		Class class = NSClassFromString(restorationClass);
		NSAssert([class conformsToProtocol:@protocol(UIViewControllerRestoration)], @"restorationClass error: %@", dict);
		viewController.restorationClass = class;
	}
	
	return YES;
}

+ (BOOL) _setTabBarControllerAttributes:(NSDictionary *)dict to:(UIViewController *)viewController
{
	// tabBarItem
	NSDictionary * tabBarItem = [dict objectForKey:@"tabBarItem"];
	if (tabBarItem) {
		SCTabBarItem * item = [SCTabBarItem create:tabBarItem autorelease:NO];
		NSAssert([item isKindOfClass:[UITabBarItem class]], @"tabBarItem's definition error: %@", tabBarItem);
		if (viewController.title && !item.title) {
			// tabBarItem.title is null, use viewController.title instead
			item.title = viewController.title;
		} else if (!viewController.title && item.title) {
			// viewController.title is null, use tabBarItem.title instead
			viewController.title = item.title;
		}
		viewController.tabBarItem = item;
		SC_UIKIT_SET_ATTRIBUTES(item, SCTabBarItem, tabBarItem);
		[item release];
	}
	
	// tabBarController
	NSDictionary * tabBarController = [dict objectForKey:@"tabBarController"];
	if (tabBarController) {
		SC_UIKIT_SET_ATTRIBUTES(viewController.tabBarController, SCTabBarController, tabBarController);
	}
	
	return YES;
}

+ (BOOL) _setNavigationControllerAttributes:(NSDictionary *)dict to:(UIViewController *)viewController
{
	// navigationItem
	NSDictionary * navigationItem = [dict objectForKey:@"navigationItem"];
	if (navigationItem) {
		NSMutableDictionary * md = [navigationItem mutableCopy];
		[md setObject:viewController forKey:@"target"];
		SC_UIKIT_SET_ATTRIBUTES(viewController.navigationItem, SCNavigationItem, md);
		[md release];
	}
	
	// hidesBottomBarWhenPushed
	id hidesBottomBarWhenPushed = [dict objectForKey:@"hidesBottomBarWhenPushed"];
	if (hidesBottomBarWhenPushed) {
		viewController.hidesBottomBarWhenPushed = [hidesBottomBarWhenPushed boolValue];
	}
	
	// navigationController
//	NSDictionary * navigationController = [dict objectForKey:@"navigationController"];
//	if (navigationController) {
//		SC_UIKIT_SET_ATTRIBUTES(viewController.navigationController, SCNavigationController, navigationController);
//	}
	
	// toolbarItems
	NSArray * toolbarItems = [dict objectForKey:@"toolbarItems"];
	if (toolbarItems) {
		NSUInteger count = [toolbarItems count];
		NSMutableArray * mArray = [[NSMutableArray alloc] initWithCapacity:count];
		
		NSAssert([toolbarItems isKindOfClass:[NSArray class]], @"toolbarItems must be an array: %@", toolbarItems);
		NSEnumerator * enumerator = [toolbarItems objectEnumerator];
		NSDictionary * item;
		NSMutableDictionary * md;
		SCBarButtonItem * bbi;
		while (item = [enumerator nextObject]) {
			NSAssert([item isKindOfClass:[NSDictionary class]], @"toolbarItems's item must be a dictionary: %@", item);
			md = [item mutableCopy];
			[md setObject:viewController forKey:@"target"];
			[md setObject:@"clickToolbarItems:" forKey:@"action"];
			
			bbi = [SCBarButtonItem create:md autorelease:NO];
			NSAssert([bbi isKindOfClass:[UIBarButtonItem class]], @"toolbarItems item's definition error: %@", md);
			if (bbi) {
				SC_UIKIT_SET_ATTRIBUTES(bbi, SCBarButtonItem, md);
				[mArray addObject:bbi];
				[bbi release];
			}
			
			[md release];
		}
		
		viewController.toolbarItems = mArray;
		[mArray release];
	}
	
	return YES;
}

+ (BOOL) _setPopoverControllerAttributes:(NSDictionary *)dict to:(UIViewController *)viewController
{
	// contentSizeForViewInPopover
	NSString * contentSizeForViewInPopover = [dict objectForKey:@"contentSizeForViewInPopover"];
	if (contentSizeForViewInPopover) {
		viewController.contentSizeForViewInPopover = CGSizeFromStringWithNode(contentSizeForViewInPopover, viewController);
	}
	
	// modalInPopover
	id modalInPopover = [dict objectForKey:@"modalInPopover"];
	if (modalInPopover) {
		viewController.modalInPopover = [modalInPopover boolValue];
	}
	
	return YES;
}

+ (BOOL) _setIOS7Attributes:(NSDictionary *)dict to:(UIViewController *)viewController
{
#ifdef __IPHONE_7_0
	
	CGFloat systemVersion = SCSystemVersion();
	if (systemVersion < 7.0f) {
		return NO;
	}
	
	// modalPresentationCapturesStatusBarAppearance
	id modalPresentationCapturesStatusBarAppearance = [dict objectForKey:@"modalPresentationCapturesStatusBarAppearance"];
	if (modalPresentationCapturesStatusBarAppearance) {
		viewController.modalPresentationCapturesStatusBarAppearance = [modalPresentationCapturesStatusBarAppearance boolValue];
	}
	
	// edgesForExtendedLayout
	NSString * edgesForExtendedLayout = [dict objectForKey:@"edgesForExtendedLayout"];
	if (edgesForExtendedLayout) {
		viewController.edgesForExtendedLayout = UIRectEdgeFromString(edgesForExtendedLayout);
	}
	
	// extendedLayoutIncludesOpaqueBars
	id extendedLayoutIncludesOpaqueBars = [dict objectForKey:@"extendedLayoutIncludesOpaqueBars"];
	if (extendedLayoutIncludesOpaqueBars) {
		viewController.extendedLayoutIncludesOpaqueBars = [extendedLayoutIncludesOpaqueBars boolValue];
	}
	
	// automaticallyAdjustsScrollViewInsets
	id automaticallyAdjustsScrollViewInsets = [dict objectForKey:@"automaticallyAdjustsScrollViewInsets"];
	if (automaticallyAdjustsScrollViewInsets) {
		viewController.automaticallyAdjustsScrollViewInsets = [automaticallyAdjustsScrollViewInsets boolValue];
	}
	
	// preferredContentSize
	NSString * preferredContentSize = [dict objectForKey:@"preferredContentSize"];
	if (preferredContentSize) {
		viewController.preferredContentSize = CGSizeFromStringWithNode(preferredContentSize, viewController);
	}
	
#endif
	return YES;
}

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIViewController *)viewController
{
	if (![SCResponder setAttributes:dict to:viewController]) {
		return NO;
	}
	
	// view
	NSDictionary * viewDict = [dict objectForKey:@"view"];
	if (viewDict) {
		SC_UIKIT_SET_ATTRIBUTES(viewController.view, SCView, viewDict);
	}
	
	// title
	NSString * title = [dict objectForKey:@"title"];
	if (title) {
		title = SCLocalizedString(title, nil);
		viewController.title = title;
	}
	
	// definesPresentationContext
	id definesPresentationContext = [dict objectForKey:@"definesPresentationContext"];
	if (definesPresentationContext) {
		viewController.definesPresentationContext = [definesPresentationContext boolValue];
	}
	
	// providesPresentationContextTransitionStyle
	id providesPresentationContextTransitionStyle = [dict objectForKey:@"providesPresentationContextTransitionStyle"];
	if (providesPresentationContextTransitionStyle) {
		viewController.providesPresentationContextTransitionStyle = [providesPresentationContextTransitionStyle boolValue];
	}
	
	// modalTransitionStyle
	NSString * modalTransitionStyle = [dict objectForKey:@"modalTransitionStyle"];
	if (modalTransitionStyle) {
		viewController.modalTransitionStyle = UIModalTransitionStyleFromString(modalTransitionStyle);
	}
	
	// modalPresentationStyle
	NSString * modalPresentationStyle = [dict objectForKey:@"modalPresentationStyle"];
	if (modalPresentationStyle) {
		viewController.modalPresentationStyle = UIModalPresentationStyleFromString(modalPresentationStyle);
	}
	
	// wantsFullScreenLayout
	id wantsFullScreenLayout = [dict objectForKey:@"wantsFullScreenLayout"];
	if (wantsFullScreenLayout) {
		viewController.wantsFullScreenLayout = [wantsFullScreenLayout boolValue];
	}
	
	// UIViewControllerEditing
	[self _setEditingAttributes:dict to:viewController];
	
	// UIContainerViewControllerProtectedMethods
	[self _setProtectedMethods:dict to:viewController];
	
	// UIStateRestoration
	[self _setStateRestorationAttributes:dict to:viewController];
	
	// (UITabBarController)
	[self _setTabBarControllerAttributes:dict to:viewController];
	
	// (UINavigationController)
	[self _setNavigationControllerAttributes:dict to:viewController];
	
	// (UIPopoverController)
	[self _setPopoverControllerAttributes:dict to:viewController];
	
#ifdef __IPHONE_7_0
	// (iOS 7.0)
	[self _setIOS7Attributes:dict to:viewController];
#endif
	
	// patch
	CGRect frame = viewController.view.frame;
	if (frame.origin.x == 0 && frame.origin.y > 0) {
		CGRect bounds = viewController.view.superview.bounds;
		if (CGSizeEqualToSize(frame.size, bounds.size)) {
			SCClient * client = [SCClient getInstance];
			if (frame.origin.y == client.statusBarHeight) {
				// kill the gap between the top status bar and the view controller
				frame.origin.y = 0;
				viewController.view.frame = frame;
			}
		}
	}
	
	return YES;
}

// view loading functions
SC_UIKIT_VIEW_CONTROLLER_IMPLEMENT_LOAD_VIEW_FUNCTIONS()

// Autorotate
SC_UIKIT_IMPLEMENT_AUTOROTATE_FUNCTIONS_WITH_CHILD_AND_PROPERTY(_supportedInterfaceOrientations)

@end
