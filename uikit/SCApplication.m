//
//  SCApplication.m
//  SnowCat
//
//  Created by Moky on 14-7-10.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCApplication.h"

//typedef NS_OPTIONS(NSUInteger, UIInterfaceOrientationMask) {
//    UIInterfaceOrientationMaskPortrait = (1 << UIInterfaceOrientationPortrait),
//    UIInterfaceOrientationMaskLandscapeLeft = (1 << UIInterfaceOrientationLandscapeLeft),
//    UIInterfaceOrientationMaskLandscapeRight = (1 << UIInterfaceOrientationLandscapeRight),
//    UIInterfaceOrientationMaskPortraitUpsideDown = (1 << UIInterfaceOrientationPortraitUpsideDown),
//    UIInterfaceOrientationMaskLandscape = (UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight),
//    UIInterfaceOrientationMaskAll = (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortraitUpsideDown),
//    UIInterfaceOrientationMaskAllButUpsideDown = (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight),
//};
NSUInteger UIInterfaceOrientationMaskFromString(NSString * string)
{
	// all but upside down
	if ([string rangeOfString:@"AllButUpsideDown"].location != NSNotFound) {
		return UIInterfaceOrientationMaskAllButUpsideDown;
	}
	
	// all
	if ([string rangeOfString:@"All"].location != NSNotFound) {
		return UIInterfaceOrientationMaskAll;
	}
	
	UIInterfaceOrientationMask mask = 0;
	
	// portrait
	if ([string rangeOfString:@"Portrait"].location != NSNotFound) {
		mask |= UIInterfaceOrientationMaskPortrait;
	}
	// landscape left
	if ([string rangeOfString:@"Left"].location != NSNotFound) {
		mask |= UIInterfaceOrientationMaskLandscapeLeft;
	}
	// landscape right
	if ([string rangeOfString:@"Right"].location != NSNotFound) {
		mask |= UIInterfaceOrientationMaskLandscapeRight;
	}
	// portrait upside down
	if ([string rangeOfString:@"UpsideDown"].location != NSNotFound) {
		mask |= UIInterfaceOrientationMaskPortraitUpsideDown;
	}
	
	// lanscape
	if (mask == 0 && [string rangeOfString:@"Landscape"].location != NSNotFound) {
		mask = UIInterfaceOrientationMaskLandscape;
	}
	
	if (mask == 0) {
		mask = UIInterfaceOrientationMaskPortrait; // default value
	}
	
	return mask;
}

#pragma mark - Background Task

static UIBackgroundTaskIdentifier _bgTask = NSUIntegerMax;

static void replace_background_task(UIApplication * app, UIBackgroundTaskIdentifier newTaskId)
{
	if (_bgTask != NSUIntegerMax && _bgTask != UIBackgroundTaskInvalid) {
		[app endBackgroundTask:_bgTask];
	}
	_bgTask = newTaskId;
}

UIBackgroundTaskIdentifier SCApplicationBeginBackgroundTask(UIApplication * application)
{
	__block UIApplication * app = application ? application : [UIApplication sharedApplication];
	if (app.applicationState != UIApplicationStateBackground) {
		// not in background state yet
		return UIBackgroundTaskInvalid;
	}
	
	UIBackgroundTaskIdentifier newTask = [app beginBackgroundTaskWithExpirationHandler:^{
		// when expired, kill the current background task and set it invalid
		replace_background_task(app, UIBackgroundTaskInvalid);
	}];
	
	// switch background task with new id
	replace_background_task(app, newTask);
	return _bgTask;
}

void SCApplicationEndBackgroundTask(UIApplication * application)
{
	UIApplication * app = application ? application : [UIApplication sharedApplication];
	// kill the current background task and set it invalid
	replace_background_task(app, UIBackgroundTaskInvalid);
}
