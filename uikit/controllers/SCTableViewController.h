//
//  SCTableViewController.h
//  SnowCat
//
//  Created by Moky on 14-3-18.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCViewController.h"

@interface SCTableViewController : UITableViewController<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UITableViewController *)tableViewController;

@end
