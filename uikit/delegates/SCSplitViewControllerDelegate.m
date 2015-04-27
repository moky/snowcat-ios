//
//  SCSplitViewControllerDelegate.m
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCSplitViewControllerDelegate.h"

@implementation SCSplitViewControllerDelegate

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

#pragma mark - UISplitViewControllerDelegate

//@optional
//
//// Called when a button should be added to a toolbar for a hidden view controller.
//// Implementing this method allows the hidden view controller to be presented via a swipe gesture if 'presentsWithGesture' is 'YES' (the default).
//- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc;
//
//// Called when the view is shown again in the split view, invalidating the button and popover controller.
//- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem;
//
//// Called when the view controller is shown in a popover so the delegate can take action like hiding other popovers.
//- (void)splitViewController:(UISplitViewController *)svc popoverController:(UIPopoverController *)pc willPresentViewController:(UIViewController *)aViewController;
//
//// Returns YES if a view controller should be hidden by the split view controller in a given orientation.
//// (This method is only called on the leftmost view controller and only discriminates portrait from landscape.)
//- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation NS_AVAILABLE_IOS(5_0);

@end
