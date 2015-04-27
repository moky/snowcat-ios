//
//  SCPageViewController.m
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCDevice.h"
#import "SCApplication.h"
#import "SCNib.h"
#import "SCPageViewControllerDataSource.h"
#import "SCPageViewControllerDelegate.h"
#import "SCPageViewController.h"

//typedef NS_ENUM(NSInteger, UIPageViewControllerNavigationOrientation) {
//    UIPageViewControllerNavigationOrientationHorizontal = 0,
//    UIPageViewControllerNavigationOrientationVertical = 1
//};
UIPageViewControllerNavigationOrientation UIPageViewControllerNavigationOrientationFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Vertical")
			return UIPageViewControllerNavigationOrientationVertical;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return UIPageViewControllerNavigationOrientationHorizontal;
}

//typedef NS_ENUM(NSInteger, UIPageViewControllerSpineLocation) {
//    UIPageViewControllerSpineLocationNone = 0, // Returned if 'spineLocation' is queried when 'transitionStyle' is not 'UIPageViewControllerTransitionStylePageCurl'.
//    UIPageViewControllerSpineLocationMin = 1,  // Requires one view controller.
//    UIPageViewControllerSpineLocationMid = 2,  // Requires two view controllers.
//    UIPageViewControllerSpineLocationMax = 3   // Requires one view controller.
//};   // Only pertains to 'UIPageViewControllerTransitionStylePageCurl'.
UIPageViewControllerSpineLocation UIPageViewControllerSpineLocationFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"None")
			return UIPageViewControllerSpineLocationNone;
		SC_SWITCH_CASE(string, @"Min")
			return UIPageViewControllerSpineLocationMin;
		SC_SWITCH_CASE(string, @"Mid")
			return UIPageViewControllerSpineLocationMid;
		SC_SWITCH_CASE(string, @"Max")
			return UIPageViewControllerSpineLocationMax;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

//typedef NS_ENUM(NSInteger, UIPageViewControllerNavigationDirection) {
//    UIPageViewControllerNavigationDirectionForward,
//    UIPageViewControllerNavigationDirectionReverse
//};  // For 'UIPageViewControllerNavigationOrientationHorizontal', 'forward' is right-to-left, like pages in a book. For 'UIPageViewControllerNavigationOrientationVertical', bottom-to-top, like pages in a wall calendar.
UIPageViewControllerNavigationDirection UIPageViewControllerNavigationDirectionFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Forward")
			return UIPageViewControllerNavigationDirectionForward;
		SC_SWITCH_CASE(string, @"Reverse")
			return UIPageViewControllerNavigationDirectionReverse;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

//typedef NS_ENUM(NSInteger, UIPageViewControllerTransitionStyle) {
//    UIPageViewControllerTransitionStylePageCurl = 0, // Navigate between views via a page curl transition.
//    UIPageViewControllerTransitionStyleScroll = 1 // Navigate between views by scrolling.
//};
UIPageViewControllerTransitionStyle UIPageViewControllerTransitionStyleFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Page")
			return UIPageViewControllerTransitionStylePageCurl;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return UIPageViewControllerTransitionStyleScroll;
}

@interface SCPageViewController () {
	
	NSUInteger _supportedInterfaceOrientations;
}

@property(nonatomic, retain) id<SCPageViewControllerDataSource> pageViewControllerDataSource;
@property(nonatomic, retain) id<SCPageViewControllerDelegate> pageViewControllerDelegate;

@end

@implementation SCPageViewController

@synthesize scTag = _scTag;
@synthesize pageViewControllerDataSource = _pageViewControllerDataSource;
@synthesize pageViewControllerDelegate = _pageViewControllerDelegate;

- (void) dealloc
{
	[_pageViewControllerDataSource release];
	[_pageViewControllerDelegate release];
	
	[SCResponder onDestroy:self.view];
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCPageViewController
{
	_scTag = 0;
	_supportedInterfaceOrientations = SC_UIKIT_DEFAULT_SUPPORTED_INTERFACE_ORIENTATIONS;
	self.pageViewControllerDataSource = nil;
	self.pageViewControllerDelegate = nil;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCPageViewController];
	}
	return self;
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		[self _initializeSCPageViewController];
	}
	return self;
}

- (instancetype) initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation options:(NSDictionary *)options
{
	self = [super initWithTransitionStyle:style navigationOrientation:navigationOrientation options:options];
	if (self) {
		[self _initializeSCPageViewController];
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	// initWithNibName:bundle:
	NSString * nibName = [SCNib nibNameFromDictionary:dict];
	
	// initWithTransitionStyle::navigationOrientation:options:
	NSString * style = [dict objectForKey:@"style"];
	NSString * orientation = [dict objectForKey:@"orientation"];
	NSDictionary * options = [dict objectForKey:@"options"];
	if (options) {
		options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMid]
											  forKey:UIPageViewControllerOptionSpineLocationKey];
	}
	
	if (nibName) {
		NSBundle * bundle = [SCNib bundleFromDictionary:dict autorelease:NO];
		self = [self initWithNibName:nibName bundle:bundle];
		[bundle release];
	} else {
		UIPageViewControllerTransitionStyle s = UIPageViewControllerTransitionStyleFromString(style);
		UIPageViewControllerNavigationOrientation o = UIPageViewControllerNavigationOrientationFromString(orientation);
		if (s != UIPageViewControllerTransitionStylePageCurl) {
			options = nil; // only PageCurl can support double page view
		}
		self = [self initWithTransitionStyle:s navigationOrientation:o options:options];
	}
	
	if (self) {
		[self buildHandlers:dict];
	}
	return self;
}

// buildHandlers:
- (void) buildHandlers:(NSDictionary *)dict
{
	[SCResponder onCreate:self withDictionary:dict];
	
	NSDictionary * dataSource = [dict objectForKey:@"dataSource"];
	if (dataSource) {
		self.pageViewControllerDataSource = [SCPageViewControllerDataSource create:dataSource];
		// self.dataSource only assign but won't retain the data delegate,
		// so don't release it now
		self.dataSource = _pageViewControllerDataSource;
	}
	
	NSDictionary * delegate = [dict objectForKey:@"delegate"];
	if (delegate) {
		self.pageViewControllerDelegate = [SCPageViewControllerDelegate create:delegate];
		// self.delegate only assign but won't retain the action delegate,
		// so don't release it now
		self.delegate = _pageViewControllerDelegate;
	}
}

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_VIEW_CONTROLLER_IMPLEMENT_SET_ATTRIBUTES_WITH_ORIENTATIONS(_supportedInterfaceOrientations, @"supportedInterfaceOrientations")

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIPageViewController *)pageViewController
{
	if (![SCViewController setAttributes:dict to:pageViewController]) {
		return NO;
	}
	
	// viewControllers
	id <UIPageViewControllerDataSource> dataSource = pageViewController.dataSource;
	if (dataSource) {
		UIViewController * vc = [dataSource pageViewController:pageViewController viewControllerAfterViewController:nil];
		UIViewController * vc2 = pageViewController.doubleSided ? [dataSource pageViewController:pageViewController viewControllerAfterViewController:vc] : nil;
		NSAssert([vc isKindOfClass:[UIViewController class]], @"view controller 1's definition error: %@", vc);
		NSAssert(!vc2 || [vc2 isKindOfClass:[UIViewController class]], @"view controller 2's definition error: %@", vc2);
		
		NSString * direction = [dict objectForKey:@"direction"];
		NSArray * array = [[NSArray alloc] initWithObjects:vc, vc2, nil];
		[pageViewController setViewControllers:array
									 direction:UIPageViewControllerNavigationDirectionFromString(direction)
									  animated:NO
									completion:nil];
		[array release];
	}
	
	return YES;
}

// view loading functions
SC_UIKIT_VIEW_CONTROLLER_IMPLEMENT_LOAD_VIEW_FUNCTIONS()

// Autorotate
SC_UIKIT_IMPLEMENT_AUTOROTATE_FUNCTIONS_WITH_PROPERTY(_supportedInterfaceOrientations)

@end
