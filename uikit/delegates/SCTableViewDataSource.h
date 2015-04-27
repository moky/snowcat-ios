//
//  SCTableViewDataSource.h
//  SnowCat
//
//  Created by Moky on 14-3-18.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCTableViewDataHandler.h"

@protocol SCTableViewDataSource <UITableViewDataSource>

- (void) reloadData:(UITableView *)tableView;

@end

@interface SCTableViewDataSource : SCObject<SCTableViewDataSource>

@property(nonatomic, retain) SCTableViewDataHandler * handler;

@end
