//
//  SCPickerViewDelegate.h
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCPickerViewDataHandler.h"

@protocol SCPickerViewDelegate <UIPickerViewDelegate>

- (void) reloadData:(UIPickerView *)pickerView;

@end

@interface SCPickerViewDelegate : SCObject<SCPickerViewDelegate>

@property(nonatomic, retain) SCPickerViewDataHandler * handler;

@end
