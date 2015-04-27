//
//  SCTextField.h
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCControl.h"

UIKIT_EXTERN UITextBorderStyle UITextBorderStyleFromString(NSString * string);
UIKIT_EXTERN UITextFieldViewMode UITextFieldViewModeFromString(NSString * string);

@interface SCTextField : UITextField<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UITextField *)textField;

@end
