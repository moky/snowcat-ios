//
//  SCPickerViewDelegate.h
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "SCPickerViewDataHandler.h"

__TVOS_PROHIBITED
@protocol SCPickerViewDelegate <UIPickerViewDelegate>

- (void) reloadData:(UIPickerView *)pickerView;

@end

__TVOS_PROHIBITED
@interface SCPickerViewDelegate : SCObject<SCPickerViewDelegate>

@property(nonatomic, retain) SCPickerViewDataHandler * handler;

@end
