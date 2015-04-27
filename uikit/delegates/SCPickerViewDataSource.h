//
//  SCPickerViewDataSource.h
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCPickerViewDataHandler.h"

@protocol SCPickerViewDataSource <UIPickerViewDataSource>

- (void) reloadData:(UIPickerView *)pickerView;

@end

@interface SCPickerViewDataSource : SCObject<SCPickerViewDataSource>

@property(nonatomic, retain) SCPickerViewDataHandler * handler;

@end
