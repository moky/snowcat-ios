//
//  SCTableViewDelegate.h
//  SnowCat
//
//  Created by Moky on 14-3-18.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCTableViewDataHandler.h"

@protocol SCTableViewDelegate <UITableViewDelegate>

- (void) reloadData:(UITableView *)tableView;

@end

@interface SCTableViewDelegate : SCObject<SCTableViewDelegate>

@property(nonatomic, retain) SCTableViewDataHandler * handler;

@end
