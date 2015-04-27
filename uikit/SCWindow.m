//
//  SCWindow.m
//  SnowCat
//
//  Created by Moky on 14-3-17.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCWindow.h"
#import "SCViewController.h"

@implementation SCWindow

+ (BOOL) apply:(NSDictionary *)dict withWindow:(UIWindow *)window
{
	NSDictionary * rootViewController = [dict objectForKey:@"rootViewController"];
	NSAssert([rootViewController isKindOfClass:[NSDictionary class]], @"cannot find root view controller: %@", dict);
	
	SCViewController * viewController = [SCViewController create:rootViewController autorelease:NO];
	NSAssert([viewController isKindOfClass:[UIViewController class]], @"rootViewController's definition error: %@", rootViewController);
	
	window.rootViewController = viewController;
	
	SC_UIKIT_SET_ATTRIBUTES(viewController, SCViewController, rootViewController);
	[viewController release];
	
	return YES;
}

@end
