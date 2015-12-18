//
//  SCActionSheetDelegate.h
//  SnowCat
//
//  Created by Moky on 14-4-3.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "SCUIKit.h"

#if !TARGET_OS_TV

@protocol SCActionSheetDelegate <UIActionSheetDelegate>

@end

@interface SCActionSheetDelegate : SCObject<SCActionSheetDelegate>

@end

#endif
