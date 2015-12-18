//
//  SCActionSheet.h
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "SCView.h"

#if !TARGET_OS_TV

UIKIT_EXTERN UIActionSheetStyle UIActionSheetStyleFromString(NSString * string);

@interface SCActionSheet : UIActionSheet<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIActionSheet *)actionSheet;

@end

#endif

// Convenient interface

UIKIT_EXTERN void SCActionSheetWithDictionary(NSDictionary * dict, UIView * sourceView);
