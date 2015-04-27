//
//  SCPickerView.h
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCView.h"

@interface SCPickerView : UIPickerView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIPickerView *)pickerView;

// Picker View Interfaces
- (void) onSelect:(id)sender;
- (void) didSelectRow:(NSInteger)rowIndex inComponent:(NSInteger)componentIndex;

@end
