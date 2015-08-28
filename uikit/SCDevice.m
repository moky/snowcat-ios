//
//  SCDevice.m
//  SnowCat
//
//  Created by Moky on 14-7-11.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCClient.h"
#import "SCDevice.h"

@implementation UIDevice (SCExtend)

- (BOOL) rotateForSupportedInterfaceOrientationsOfViewController:(UIViewController *)viewController
{
	NSUInteger supportedInterfaceOrientations = [viewController supportedInterfaceOrientations];
	UIDeviceOrientation currentOrientation = [self orientation];
	if (supportedInterfaceOrientations & (1 << currentOrientation)) {
		// current orientation is supported by the view controller
		return NO;
	}
	
	UIInterfaceOrientation orientation = [viewController preferredInterfaceOrientationForPresentation];
	SCLog(@"force device orientation from %d to %d", (int)currentOrientation, (int)orientation);
	
	// try to present the preferred interface orientation
	if ([self respondsToSelector:@selector(setOrientation:)]) {
		[self performSelector:@selector(setOrientation:) withObject:(id)orientation];
	}
	
	return YES;
}

@end
