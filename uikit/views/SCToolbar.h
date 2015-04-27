//
//  SCToolbar.h
//  SnowCat
//
//  Created by Moky on 14-4-3.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCView.h"

@protocol SCToolbarItemDelegate <NSObject>

@optional

- (void) clickToolbarItems:(id)sender; // event: toolbarItems[x].onClick

@end

// selector names
#define SCToolbarItemDelegate_clickToolbarItems   @"clickToolbarItems:"

UIKIT_EXTERN UIToolbarPosition UIToolbarPositionFromString(NSString * string);

@interface SCToolbar : UIToolbar<SCUIKit, SCToolbarItemDelegate>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIToolbar *)toolbar;

@end
