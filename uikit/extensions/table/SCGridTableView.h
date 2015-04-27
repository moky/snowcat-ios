//
//  SCGridTableView.h
//  SnowCat
//
//  Created by Moky on 14-4-23.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCTableView.h"

@interface UIGridTableView : UITableView

@property(nonatomic, readwrite) CGFloat columnWidth; // will return the cell's width if unset

@end

#pragma mark -

@interface SCGridTableView : UIGridTableView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIGridTableView *)gridTableView;

@end
