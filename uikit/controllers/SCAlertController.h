//
//  SCAlertController.h
//  SnowCat
//
//  Created by Moky on 15-1-14.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "SCViewController.h"

#ifdef __IPHONE_8_0

UIKIT_EXTERN UIAlertControllerStyle UIAlertControllerStyleFromString(NSString * string);

@interface SCAlertController : UIAlertController<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIAlertController *)alertController;

@end

UIKIT_EXTERN void SCAlertControllerShow(UIAlertController * alertController);

#endif // EOF '__IPHONE_8_0'
