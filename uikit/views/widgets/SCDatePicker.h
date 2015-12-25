//
//  SCDatePicker.h
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "SCControl.h"

__TVOS_PROHIBITED
UIKIT_EXTERN UIDatePickerMode UIDatePickerModeFromString(NSString * string);

__TVOS_PROHIBITED
@interface SCDatePicker : UIDatePicker<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIDatePicker *)datePicker;

// Value Event Interfaces
- (void) onChange:(id)sender;

@end
