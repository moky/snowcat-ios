//
//  SCDevice.m
//  SnowCat
//
//  Created by Moky on 14-7-11.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#include <sys/sysctl.h>

/**
 *  Identifier Addition for UIDevice:
 *      https://github.com/gekitz/UIDevice-with-UniqueIdentifier-for-iOS-5
 */
// 'libs/IdentifierAddition'
#import "UIDevice+IdentifierAddition.h"

#import "SCLog.h"
#import "SCClient.h"
#import "SCDevice.h"

@implementation UIDevice (SCExtend)

- (NSString *) machine
{
	size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char * machine = malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString * hardware = [[NSString alloc] initWithCString:machine encoding:NSUTF8StringEncoding];
	free(machine);
	return [hardware autorelease];
}

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

static NSString * s_uniqueGlobalDeviceIdentifier = nil;

- (NSString *) globalIdentifier
{
	if (!s_uniqueGlobalDeviceIdentifier) {
		if ([self respondsToSelector:@selector(uniqueGlobalDeviceIdentifier)]) {
			s_uniqueGlobalDeviceIdentifier = [self uniqueGlobalDeviceIdentifier];
			[s_uniqueGlobalDeviceIdentifier retain];
		} else {
			s_uniqueGlobalDeviceIdentifier = @"0123456789abcdef0123456789abcdef";
		}
	}
	return s_uniqueGlobalDeviceIdentifier;
}

@end
