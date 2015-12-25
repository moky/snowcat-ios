//
//  SCActionSheet.h
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "SCView.h"

__TVOS_PROHIBITED
UIKIT_EXTERN UIActionSheetStyle UIActionSheetStyleFromString(NSString * string);

__TVOS_PROHIBITED
@interface SCActionSheet : UIActionSheet<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIActionSheet *)actionSheet;

@end

// Convenient interface

UIKIT_EXTERN void SCActionSheetWithDictionary(NSDictionary * dict, UIView * sourceView);
