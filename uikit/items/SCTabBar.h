//
//  SCTabBar.h
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCView.h"

UIKIT_EXTERN UITabBarItemPositioning UITabBarItemPositioningFromString(NSString * string);

@interface SCTabBar : UITabBar<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UITabBar *)tabBar;

@end
