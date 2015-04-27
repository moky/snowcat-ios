//
//  SCActionSheet.h
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCView.h"

UIKIT_EXTERN UIActionSheetStyle UIActionSheetStyleFromString(NSString * string);

@interface SCActionSheet : UIActionSheet<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIActionSheet *)actionSheet;

@end

// Convenient interface

UIKIT_EXTERN void SCActionSheetWithDictionary(NSDictionary * dict, UIView * sourceView);
UIKIT_EXTERN void SCActionSheetShow(UIActionSheet * actionSheet);
