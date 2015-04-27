//
//  SCAlertView.h
//  SnowCat
//
//  Created by Moky on 14-3-24.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCView.h"

UIKIT_EXTERN UIAlertViewStyle UIAlertViewStyleFromString(NSString * string);

@interface SCAlertView : UIAlertView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIAlertView *)alertView;

@end

// Convenient interface

UIKIT_EXTERN void SCAlert(NSString * title, NSString * message, NSString * ok);

UIKIT_EXTERN void SCAlertWithDictionary(NSDictionary * dict);
