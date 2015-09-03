//
//  SCSwipeTableViewCell.h
//  SnowCat
//
//  Created by Moky on 14-6-20.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "SlanissueToolkit.h"

#import "SCUIKit.h"

@interface SCSwipeTableViewCell : UISwipeTableViewCell<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UISwipeTableViewCell *)swipeTableViewCell;

@end
