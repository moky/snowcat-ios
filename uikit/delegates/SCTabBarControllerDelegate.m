//
//  SCTabBarControllerDelegate.m
//  SnowCat
//
//  Created by Moky on 14-12-25.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCTabBarControllerDelegate.h"

@implementation SCTabBarControllerDelegate

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

#pragma mark - UITabBarControllerDelegate

//@optional
//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0);
//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
//
//- (void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray *)viewControllers NS_AVAILABLE_IOS(3_0);
//- (void)tabBarController:(UITabBarController *)tabBarController willEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed NS_AVAILABLE_IOS(3_0);
//- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed;
//
//- (NSUInteger)tabBarControllerSupportedInterfaceOrientations:(UITabBarController *)tabBarController NS_AVAILABLE_IOS(7_0);
//- (UIInterfaceOrientation)tabBarControllerPreferredInterfaceOrientationForPresentation:(UITabBarController *)tabBarController NS_AVAILABLE_IOS(7_0);
//
//- (id <UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController
//					  interactionControllerForAnimationController: (id <UIViewControllerAnimatedTransitioning>)animationController NS_AVAILABLE_IOS(7_0);
//
//- (id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
//			animationControllerForTransitionFromViewController:(UIViewController *)fromVC
//											  toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0);

@end
