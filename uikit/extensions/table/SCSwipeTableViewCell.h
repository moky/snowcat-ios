//
//  SCSwipeTableViewCell.h
//  SnowCat
//
//  Created by Moky on 14-6-20.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCUIKit.h"
#import "SCSwipeTableViewCell+UIKit.h"

@interface SCSwipeTableViewCell : UISwipeTableViewCell<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UISwipeTableViewCell *)swipeTableViewCell;

@end
