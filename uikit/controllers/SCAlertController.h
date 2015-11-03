//
//  SCAlertController.h
//  SnowCat
//
//  Created by Moky on 15-1-14.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "SCViewController.h"

UIKIT_EXTERN UIAlertControllerStyle UIAlertControllerStyleFromString(NSString * string) NS_AVAILABLE_IOS(8_0);

NS_CLASS_AVAILABLE_IOS(8_0) @interface SCAlertController : UIAlertController<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIAlertController *)alertController;

@end

UIKIT_EXTERN void SCAlertControllerShow(UIAlertController * alertController) NS_AVAILABLE_IOS(8_0);
