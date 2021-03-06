//
//  SCPickerViewDataSource.h
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "SCPickerViewDataHandler.h"

__TVOS_PROHIBITED
@protocol SCPickerViewDataSource <UIPickerViewDataSource>

- (void) reloadData:(UIPickerView *)pickerView;

@end

__TVOS_PROHIBITED
@interface SCPickerViewDataSource : SCObject<SCPickerViewDataSource>

@property(nonatomic, retain) SCPickerViewDataHandler * handler;

@end
