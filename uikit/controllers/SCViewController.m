//
//  SCViewController.m
//  SnowCat
//
//  Created by Moky on 14-3-17.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCClient.h"
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
#if !TARGET_OS_TV
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Vertical")   // CoverVertical
			return UIModalTransitionStyleCoverVertical;
		SC_SWITCH_CASE(string, @"Horizontal") // FlipHorizontal
			return UIModalTransitionStyleFlipHorizontal;
		SC_SWITCH_CASE(string, @"Cross")      // CrossDissolve
			return UIModalTransitionStyleCrossDissolve;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_2
		SC_SWITCH_CASE(string, @"Curl")       // PartialCurl
			return UIModalTransitionStylePartialCurl;
#endif
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
#endif
	
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
#if !TARGET_OS_TV
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"FullScreen")
			return UIModalPresentationFullScreen;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_2
		SC_SWITCH_CASE(string, @"Page")    // PageSheet
			return UIModalPresentationPageSheet;
		SC_SWITCH_CASE(string, @"Form")    // FormSheet
			return UIModalPresentationFormSheet;
		SC_SWITCH_CASE(string, @"Context") // CurrentContext
			return UIModalPresentationCurrentContext;
#endif
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
#endif
	
	return [string integerValue];
}

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
#if !TARGET_OS_TV
	_supportedInterfaceOrientations = SC_UIKIT_DEFAULT_SUPPORTED_INTERFACE_ORIENTATIONS;
#endif
	
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
	
	NSBundle * bundle = [SCNib bundleFromDictionary:dict];
	self = [self initWithNibName:nibName bundle:bundle];
	
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
	SC_SET_ATTRIBUTES_AS_BOOL(viewController, dict, editing);
	
	return YES;
}

+ (BOOL) _setProtectedMethods:(NSDictionary *)dict to:(UIViewController *)viewController
{
	// childViewControllers
	NSArray * childViewControllers = [dict objectForKey:@"childViewControllers"];
	if (childViewControllers) {
		NSAssert([childViewControllers isKindOfClass:[NSArray class]], @"childViewControllers must be an array: %@", childViewControllers);
		NSDictionary * item;
		SCViewController * child;
		SC_FOR_EACH(item, childViewControllers) {
			NSAssert([item isKindOfClass:[NSDictionary class]], @"childViewControllers's item must be a dictionary: %@", item);
			SC_UIKIT_DIG_CREATION_INFO(item); // support ObjectFromFile
			child = [SCViewController create:item];
			NSAssert([child isKindOfClass:[UIViewController class]], @"childViewControllers item's definition error: %@", item);
			if (child) {
				// add to parent first
				[viewController addChildViewController:child];
				[viewController.view addSubview:child.view]; // add view
				// and then set attributes
				SC_UIKIT_SET_ATTRIBUTES(child, SCViewController, item);
			}
		}
	}
	
	return YES;
}

+ (BOOL) _setStateRestorationAttributes:(NSDictionary *)dict to:(UIViewController *)viewController
{
	// restorationIdentifier
	SC_SET_ATTRIBUTES_AS_STRING(viewController, dict, restorationIdentifier);
	
	// restorationClass
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
		SCTabBarItem * item = [SCTabBarItem create:tabBarItem];
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
	
#if !TARGET_OS_TV
	SC_SET_ATTRIBUTES_AS_BOOL(viewController, dict, hidesBottomBarWhenPushed);
#endif
	
	// navigationController
//	NSDictionary * navigationController = [dict objectForKey:@"navigationController"];
//	if (navigationController) {
//		SC_UIKIT_SET_ATTRIBUTES(viewController.navigationController, SCNavigationController, navigationController);
//	}
	
#if !TARGET_OS_TV
	// toolbarItems
	NSArray * toolbarItems = [dict objectForKey:@"toolbarItems"];
	if (toolbarItems) {
		NSUInteger count = [toolbarItems count];
		NSMutableArray * mArray = [[NSMutableArray alloc] initWithCapacity:count];
		
		NSAssert([toolbarItems isKindOfClass:[NSArray class]], @"toolbarItems must be an array: %@", toolbarItems);
		NSDictionary * item;
		NSMutableDictionary * md;
		SCBarButtonItem * bbi;
		SC_FOR_EACH(item, toolbarItems) {
			NSAssert([item isKindOfClass:[NSDictionary class]], @"toolbarItems's item must be a dictionary: %@", item);
			md = [item mutableCopy];
			[md setObject:viewController forKey:@"target"];
			[md setObject:@"clickToolbarItems:" forKey:@"action"];
			
			bbi = [SCBarButtonItem create:md];
			NSAssert([bbi isKindOfClass:[UIBarButtonItem class]], @"toolbarItems item's definition error: %@", md);
			SC_UIKIT_SET_ATTRIBUTES(bbi, SCBarButtonItem, md);
			SCArrayAddObject(mArray, bbi);
			
			[md release];
		}
		
		viewController.toolbarItems = mArray;
		[mArray release];
	}
#endif
	
	return YES;
}

+ (BOOL) _setPopoverControllerAttributes:(NSDictionary *)dict to:(UIViewController *)viewController
{
	// contentSizeForViewInPopover
	NSString * contentSizeForViewInPopover = [dict objectForKey:@"contentSizeForViewInPopover"];
	if (contentSizeForViewInPopover) {
		//viewController.contentSizeForViewInPopover = CGSizeFromStringWithNode(contentSizeForViewInPopover, viewController);
		viewController.preferredContentSize = CGSizeFromStringWithNode(contentSizeForViewInPopover, viewController);
	}
	
	// modalInPopover
	SC_SET_ATTRIBUTES_AS_BOOL(viewController, dict, modalInPopover);
	
	return YES;
}

+ (BOOL) _setIOS7Attributes:(NSDictionary *)dict to:(UIViewController *)viewController
{
#ifdef __IPHONE_7_0
	
	CGFloat systemVersion = SCSystemVersion();
	if (systemVersion < 7.0f) {
		return NO;
	}
	
#if !TARGET_OS_TV
	SC_SET_ATTRIBUTES_AS_BOOL      (viewController, dict, modalPresentationCapturesStatusBarAppearance);
#endif
	SC_SET_ATTRIBUTES_AS_UIRECTEDGE(viewController, dict, edgesForExtendedLayout);
	SC_SET_ATTRIBUTES_AS_BOOL      (viewController, dict, extendedLayoutIncludesOpaqueBars);
	SC_SET_ATTRIBUTES_AS_BOOL      (viewController, dict, automaticallyAdjustsScrollViewInsets);
	SC_SET_ATTRIBUTES_AS_CGSIZE    (viewController, dict, preferredContentSize);
	
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
	
	SC_SET_ATTRIBUTES_AS_LOCALIZED_STRING(viewController, dict, title);
	
	SC_SET_ATTRIBUTES_AS_BOOL(viewController, dict, definesPresentationContext);
	SC_SET_ATTRIBUTES_AS_BOOL(viewController, dict, providesPresentationContextTransitionStyle);
	
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
	
#if !TARGET_OS_TV
	
	// wantsFullScreenLayout
	id wantsFullScreenLayout = [dict objectForKey:@"wantsFullScreenLayout"];
	if (wantsFullScreenLayout) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		viewController.wantsFullScreenLayout = [wantsFullScreenLayout boolValue];
#pragma clang diagnostic pop
	}
	
#endif
	
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
