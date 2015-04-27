//
//  SCButton.h
//  SnowCat
//
//  Created by Moky on 14-3-18.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCControl.h"

UIKIT_EXTERN UIButtonType UIButtonTypeFromString(NSString * string);

@interface SCButton : UIButton<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIButton *)button;

// Button Interfaces
- (void) onClick:(id)sender;

@end
