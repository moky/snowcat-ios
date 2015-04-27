//
//  SCPageViewControllerDataSource.m
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCViewController.h"
#import "SCPageViewControllerDataSource.h"

@interface SCPageViewControllerDataSource ()

@property(nonatomic, retain) NSMutableArray * viewControllers;

@end

@implementation SCPageViewControllerDataSource

@synthesize viewControllers = _viewControllers;

- (void) dealloc
{
	[_viewControllers release];
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		self.viewControllers = nil;
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	self = [self init];
	if (self) {
		NSArray * viewControllers = [dict objectForKey:@"viewControllers"];
		NSAssert([viewControllers count] > 1, @"viewControllers must be an array and count more than 1: %@", dict);
		NSMutableArray * mArray = [viewControllers mutableCopy];
		self.viewControllers = mArray;
		[mArray release];
	}
	return self;
}

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

- (UIViewController *) _buildViewController:(NSDictionary *)dict atIndex:(NSUInteger)index
{
	SCViewController * vc = [SCViewController create:dict];
	NSAssert([vc isKindOfClass:[UIViewController class]], @"view controller's definition error: %@", dict);
	if (vc) {
		[dict retain];
		[_viewControllers replaceObjectAtIndex:index withObject:vc];
		SC_UIKIT_SET_ATTRIBUTES(vc, SCViewController, dict);
		[dict release];
	}
	return vc;
}

- (UIViewController *) _viewControllerAtIndex:(NSUInteger)index
{
	UIViewController * vc = [_viewControllers objectAtIndex:index];
	if ([vc isKindOfClass:[UIViewController class]]) {
		return vc;
	}
	NSAssert([vc isKindOfClass:[NSDictionary class]], @"view controller's definition must be a dictionary: %@", vc);
	return [self _buildViewController:(NSDictionary *)vc atIndex:index];
}

#pragma mark - UIPageViewControllerDataSource

//@required

// In terms of navigation direction. For example, for 'UIPageViewControllerNavigationOrientationHorizontal', view controllers coming 'before' would be to the left of the argument view controller, those coming 'after' would be to the right.
// Return 'nil' to indicate that no more progress can be made in the given direction.
// For gesture-initiated transitions, the page view controller obtains view controllers via these methods, so use of setViewControllers:direction:animated:completion: is not required.
- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
	NSInteger index = viewController ? [_viewControllers indexOfObject:viewController] : [_viewControllers count];
	if (index == NSNotFound || --index < 0) {
		return nil;
	}
	return [self _viewControllerAtIndex:index];
}

- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
	NSUInteger index = viewController ? [_viewControllers indexOfObject:viewController] : -1;
	if (index == NSNotFound || ++index >= [_viewControllers count]) {
		return nil;
	}
	return [self _viewControllerAtIndex:index];
}

//@optional

// A page indicator will be visible if both methods are implemented, transition style is 'UIPageViewControllerTransitionStyleScroll', and navigation orientation is 'UIPageViewControllerNavigationOrientationHorizontal'.
// Both methods are called in response to a 'setViewControllers:...' call, but the presentation index is updated automatically in the case of gesture-driven navigation.
- (NSInteger) presentationCountForPageViewController:(UIPageViewController *)pageViewController NS_AVAILABLE_IOS(6_0) // The number of items reflected in the page indicator.
{
	return [pageViewController.viewControllers count];
}

//- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController NS_AVAILABLE_IOS(6_0); // The selected item reflected in the page indicator.

@end
