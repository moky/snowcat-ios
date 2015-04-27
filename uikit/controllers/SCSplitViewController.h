//
//  SCSplitViewController.h
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCViewController.h"

@interface SCSplitViewController : UISplitViewController<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UISplitViewController *)splitViewController;

@end
