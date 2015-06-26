//
//  SCTabBarController.h
//  SnowCat
//
//  Created by Moky on 14-3-17.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "SCViewController.h"

@interface SCTabBarController : UITabBarController<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UITabBarController *)tabBarController;

@end
