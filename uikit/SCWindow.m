//
//  SCWindow.m
//  SnowCat
//
//  Created by Moky on 14-3-17.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCNodeFileParser.h"
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

+ (BOOL) launch:(NSString *)entrance withWindow:(UIWindow *)window
{
	SCNodeFileParser * parser = [SCNodeFileParser parser:entrance];
	NSDictionary * dict = [parser node];
	NSAssert([dict isKindOfClass:[NSDictionary class]], @"entrance error: %@", entrance);
	
	if ([dict objectForKey:@"window"]) {
		dict = [dict objectForKey:@"window"];
	}
	
	SCLog(@"**** %@ loaded, entering...", entrance);
	return [SCWindow apply:dict withWindow:window];
}

@end
