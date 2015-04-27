//
//  SCControl.h
//  SnowCat
//
//  Created by Moky on 14-3-18.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCView.h"

//UIKIT_EXTERN UIControlEvents UIControlEventsFromString(NSString * string);
UIKIT_EXTERN UIControlContentVerticalAlignment UIControlContentVerticalAlignmentFromString(NSString * string);
UIKIT_EXTERN UIControlContentHorizontalAlignment UIControlContentHorizontalAlignmentFromString(NSString * string);
//UIKIT_EXTERN UIControlState UIControlStateFromString(NSString * string);

@interface SCControl : UIControl<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIControl *)control;

@end
