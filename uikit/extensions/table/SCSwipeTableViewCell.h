//
//  SCSwipeTableViewCell.h
//  SnowCat
//
//  Created by Moky on 14-6-20.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCTableViewCell.h"

@interface UISwipeTableViewCell : UITableViewCell

@property(nonatomic, readwrite) CGFloat indentationLeft; // default is 0.0, means no indent
@property(nonatomic, readwrite) CGFloat indentationRight; // default is 0.0, means no indent

@end

#pragma mark -

@interface SCSwipeTableViewCell : UISwipeTableViewCell<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UISwipeTableViewCell *)swipeTableViewCell;

@end
