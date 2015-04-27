//
//  SCDevice.h
//  SnowCat
//
//  Created by Moky on 14-7-11.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (SCExtend)

// get hw.machine
- (NSString *) machine;

// rotate the current device for supported interface orientations
// return YES if rotated
- (BOOL) rotateForSupportedInterfaceOrientationsOfViewController:(UIViewController *)viewController;

// generates a hash from the MAC-address
- (NSString *) globalIdentifier;

@end
