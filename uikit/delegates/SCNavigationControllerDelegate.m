//
//  SCNavigationControllerDelegate.m
//  SnowCat
//
//  Created by Moky on 14-12-25.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCNavigationControllerDelegate.h"

@implementation SCNavigationControllerDelegate

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	self = [self init];
	if (self) {
		// TODO: set attributes here
	}
	return self;
}

#pragma mark - UINavigationControllerDelegate

//@optional
//
//// Called when the navigation controller shows a new top view controller via a push, pop or setting of the view controller stack.
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
//
//- (NSUInteger)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController NS_AVAILABLE_IOS(7_0);
//- (UIInterfaceOrientation)navigationControllerPreferredInterfaceOrientationForPresentation:(UINavigationController *)navigationController NS_AVAILABLE_IOS(7_0);
//
//- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
//						  interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController NS_AVAILABLE_IOS(7_0);
//
//- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
//								   animationControllerForOperation:(UINavigationControllerOperation)operation
//												fromViewController:(UIViewController *)fromVC
//												  toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0);

@end
