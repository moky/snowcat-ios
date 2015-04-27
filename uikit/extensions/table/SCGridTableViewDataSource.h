//
//  SCGridTableViewDataSource.h
//  SnowCat
//
//  Created by Moky on 14-4-23.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCTableViewDataSource.h"

@class UIGridTableView;

@interface SCGridTableViewDataSource : SCTableViewDataSource

- (void) updateGrid:(UIGridTableView *)gridTableView;

@end
