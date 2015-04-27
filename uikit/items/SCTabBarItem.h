//
//  SCTabBarItem.h
//  SnowCat
//
//  Created by Moky on 14-3-17.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCBarItem.h"

UIKIT_EXTERN UITabBarSystemItem UITabBarSystemItemFromString(NSString * string);

@interface SCTabBarItem : UITabBarItem<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UITabBarItem *)tabBarItem;

@end
