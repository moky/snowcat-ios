//
//  SCNavigationController.h
//  SnowCat
//
//  Created by Moky on 14-3-17.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCViewController.h"

@interface SCNavigationController : UINavigationController<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UINavigationController *)navigationController;

@end
