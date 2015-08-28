//
//  SCDevice.h
//  SnowCat
//
//  Created by Moky on 14-7-11.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (SCExtend)

// rotate the current device for supported interface orientations
// return YES if rotated
- (BOOL) rotateForSupportedInterfaceOrientationsOfViewController:(UIViewController *)viewController;

@end
