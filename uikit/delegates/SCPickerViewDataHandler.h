//
//  SCPickerViewDataHandler.h
//  SnowCat
//
//  Created by Moky on 14-11-22.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "SCUIKit.h"

__TVOS_PROHIBITED
@protocol SCPickerViewDataHandler <NSObject>

- (void) reloadData:(UIPickerView *)pickerView;

// components
- (NSArray *) components;
- (NSUInteger) numberOfComponents;
- (NSDictionary *) componentAtIndex:(NSInteger)componentIndex;

// rows
- (NSArray *) rowsInComponent:(NSInteger)componentIndex;
- (NSUInteger) numberOfRowsInComponent:(NSInteger)componentIndex;
- (NSDictionary *) rowAtIndex:(NSInteger)rowIndex componentIndex:(NSInteger)componentIndex;

@end

__TVOS_PROHIBITED
@interface SCPickerViewDataHandler : SCObject<SCPickerViewDataHandler>

@end
