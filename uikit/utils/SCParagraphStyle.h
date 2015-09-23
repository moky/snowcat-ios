//
//  SCParagraphStyle.h
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "SCUIKit.h"

#ifdef __IPHONE_6_0

UIKIT_EXTERN NSLineBreakMode NSLineBreakModeFromString(NSString * string);

NS_CLASS_AVAILABLE_IOS(6_0) @interface SCParagraphStyle : NSMutableParagraphStyle<SCObject>

@end

#endif
