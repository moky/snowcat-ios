//
//  SCApplication.h
//  SnowCat
//
//  Created by Moky on 14-7-10.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSUInteger UIInterfaceOrientationMaskFromString(NSString * string);

UIKIT_EXTERN UIBackgroundTaskIdentifier SCApplicationBeginBackgroundTask(UIApplication * application);
UIKIT_EXTERN void SCApplicationEndBackgroundTask(UIApplication * application);
