//
//  SCApplication.m
//  SnowCat
//
//  Created by Moky on 14-7-10.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
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
