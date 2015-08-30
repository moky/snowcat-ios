//
//  SCApplication.h
//  SnowCat
//
//  Created by Moky on 14-7-10.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "SlanissueToolkit.h"

UIKIT_EXTERN NSUInteger UIInterfaceOrientationMaskFromString(NSString * string);

#define SCApplicationBeginBackgroundTask(app) [(app) beginBackgroundTask]
#define SCApplicationEndBackgroundTask(app)   [(app) endBackgroundTask]
