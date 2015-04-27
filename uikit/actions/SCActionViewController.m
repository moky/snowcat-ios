//
//  SCActionViewController.m
//  SnowCat
//
//  Created by Moky on 14-3-25.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCTransition.h"
#import "SCViewController.h"
#import "SCActionView.h"
#import "SCActionViewController.h"

@implementation SCActionViewController

- (BOOL) _setAttributes:(NSDictionary *)dict withViewController:(UIViewController *)viewController
{
	return SC_UIKIT_SET_ATTRIBUTES(viewController, SCViewController, dict);
}

- (BOOL) _addChildViewController:(NSDictionary *)dict withViewController:(UIViewController *)viewController
{
	SC_UIKIT_DIG_CREATION_INFO(dict); // support ObjectFromFile
	SCViewController * child = [SCViewController create:dict autorelease:NO];
	NSAssert([child isKindOfClass:[UIViewController class]], @"child view controller's definition error: %@", dict);
	if ([viewController isKindOfClass:[UINavigationController class]]) {
		UINavigationController * nc = (UINavigationController *)viewController;
		[nc pushViewController:child animated:NO];
	} else {
		[viewController addChildViewController:child];
		[viewController.view addSubview:child.view]; // transitionFromViewController ...
		// f*cking the child view controller's frame for iOS 7.
		CGRect frame = child.view.frame;
		CGRect bounds = viewController.view.bounds;
		if (frame.size.width == bounds.size.height && frame.size.height == bounds.size.width) {
			child.view.frame = bounds;
		}
	}
	SC_UIKIT_SET_ATTRIBUTES(child, SCViewController, dict);
	[child release];
	return YES;
}

- (BOOL) _removeFromParentViewController:(UIViewController *)viewController
{
	NSAssert(viewController.view.superview, @"super view not found");
	NSAssert(viewController.parentViewController, @"parent view controller not found");
	[viewController.view removeFromSuperview];
	[viewController removeFromParentViewController];
	return YES;
}

- (BOOL) _presentViewController:(NSDictionary *)dict animated:(BOOL)flag withViewController:(UIViewController *)viewController
{
	SC_UIKIT_DIG_CREATION_INFO(dict); // support ObjectFromFile
	SCViewController * child = [SCViewController create:dict autorelease:NO];
	NSAssert([child isKindOfClass:[UIViewController class]], @"view controller's definition error: %@", dict);
	[viewController presentViewController:child animated:flag completion:NULL];
	SC_UIKIT_SET_ATTRIBUTES(child, SCViewController, dict);
	[child release];
	return YES;
}

- (BOOL) _dismissViewControllerAnimated:(BOOL)flag withViewController:(UIViewController *)viewController
{
	[viewController dismissViewControllerAnimated:flag completion:NULL];
	return YES;
}

- (BOOL) _presentModalViewController:(NSDictionary *)dict animated:(BOOL)flag withViewController:(UIViewController *)viewController
{
	SC_UIKIT_DIG_CREATION_INFO(dict); // support ObjectFromFile
	SCViewController * child = [SCViewController create:dict autorelease:NO];
	NSAssert([child isKindOfClass:[UIViewController class]], @"view controller's definition error: %@", dict);
	[viewController presentModalViewController:child animated:flag];
	SC_UIKIT_SET_ATTRIBUTES(child, SCViewController, dict);
	[child release];
	return YES;
}

- (BOOL) _dismissModalViewControllerAnimated:(BOOL)flag withViewController:(UIViewController *)viewController
{
	[viewController dismissModalViewControllerAnimated:flag];
	return YES;
}

- (BOOL) _transitionWithView:(UIView *)view
{
	// transition
	NSDictionary * transition = [_dict objectForKey:@"transition"];
	if (transition) {
		SCTransition * trans = [SCTransition create:transition autorelease:NO];
		NSAssert([trans isKindOfClass:[SCTransition class]], @"transition's definition error: %@", transition);
		[trans setAttributes:transition];
		[trans runWithView:view];
		[trans release];
		return YES;
	}
	return NO;
}

- (BOOL) runWithResponder:(id)responder
{
	NSAssert([responder isKindOfClass:[UIViewController class]], @"definition error: %@, responder: %@", _dict, responder);
	
	UIViewController * viewController = (UIViewController *)responder;
	
	NSString * selector = [_dict objectForKey:@"selector"];
	
	BOOL flag = NO;
	
	//----------------------------------------------------------- set attributes
	if ([selector isEqualToString:@"setAttributes:"])
	{
		NSDictionary * attributes = [_dict objectForKey:@"attributes"];
		NSAssert([attributes isKindOfClass:[NSDictionary class]], @"attributes's definition error: %@", _dict);
		flag = [self _setAttributes:attributes
				 withViewController:viewController];
		[self _transitionWithView:viewController.view];
	}
	//------------------------------------------------ add child view controller
	else if ([selector isEqualToString:@"addChildViewController:"])
	{
		NSDictionary * child = [_dict objectForKey:@"viewController"];
		NSAssert([child isKindOfClass:[NSDictionary class]], @"child view controller's definition error: %@", _dict);
		flag = [self _addChildViewController:child
						  withViewController:viewController];
		[self _transitionWithView:viewController.view];
	}
	//--------------------------------------- remove from parent view controller
	else if ([selector isEqualToString:@"removeFromParentViewController"])
	{
		[self _transitionWithView:viewController.view.superview];
		flag = [self _removeFromParentViewController:viewController];
	}
	//-------------------------------------------------- present view controller
	else if ([selector isEqualToString:@"presentViewController:"])
	{
		NSDictionary * child = [_dict objectForKey:@"viewController"];
		NSAssert([child isKindOfClass:[NSDictionary class]], @"child view controller's definition error: %@", _dict);
		flag = [self _presentViewController:child
								   animated:YES
						 withViewController:viewController];
	}
	else if ([selector isEqualToString:@"presentViewController:animated:"]) // default animation or user-defined transition
	{
		BOOL animated = [[_dict objectForKey:@"animated"] boolValue];
		NSDictionary * child = [_dict objectForKey:@"viewController"];
		NSAssert([child isKindOfClass:[NSDictionary class]], @"child view controller's definition error: %@", _dict);
		flag = [self _presentViewController:child
								   animated:animated
						 withViewController:viewController];
		if (!animated) {
			[self _transitionWithView:viewController.view];
		}
	}
	//-------------------------------------------------- dismiss view controller
	else if ([selector isEqualToString:@"dismissViewController"])
	{
		flag = [self _dismissViewControllerAnimated:YES
								 withViewController:viewController];
	}
	else if ([selector isEqualToString:@"dismissViewControllerAnimated:"]) // default animation or user-defined transition
	{
		BOOL animated = [[_dict objectForKey:@"animated"] boolValue];
		flag = [self _dismissViewControllerAnimated:animated
								 withViewController:viewController];
		if (!animated) {
			[self _transitionWithView:viewController.view];
		}
	}
	//-------------------------------------------------- present view controller
	else if ([selector isEqualToString:@"presentModalViewController:"])
	{
		NSDictionary * child = [_dict objectForKey:@"viewController"];
		NSAssert([child isKindOfClass:[NSDictionary class]], @"child view controller's definition error: %@", _dict);
		flag = [self _presentModalViewController:child
										animated:YES
							  withViewController:viewController];
	}
	else if ([selector isEqualToString:@"presentModalViewController:animated:"]) // default animation or user-defined transition
	{
		BOOL animated = [[_dict objectForKey:@"animated"] boolValue];
		NSDictionary * child = [_dict objectForKey:@"viewController"];
		NSAssert([child isKindOfClass:[NSDictionary class]], @"child view controller's definition error: %@", _dict);
		flag = [self _presentModalViewController:child
										animated:animated
							  withViewController:viewController];
		if (!animated) {
			[self _transitionWithView:viewController.view];
		}
	}
	//-------------------------------------------------- dismiss view controller
	else if ([selector isEqualToString:@"dismissModalViewController"])
	{
		flag = [self _dismissModalViewControllerAnimated:YES
									  withViewController:viewController];
	}
	else if ([selector isEqualToString:@"dismissModalViewControllerAnimated:"]) // default animation or user-defined transition
	{
		BOOL animated = [[_dict objectForKey:@"animated"] boolValue];
		flag = [self _dismissModalViewControllerAnimated:animated
									  withViewController:viewController];
		if (!animated) {
			[self _transitionWithView:viewController.view];
		}
	}
	
	NSAssert(flag, @"invalid action: %@, responder: %@", _dict, responder);
	return flag;
}
@end
