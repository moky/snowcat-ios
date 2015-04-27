//
//  SCTableViewHeaderFooterView.h
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCView.h"

@interface SCTableViewHeaderFooterView : UITableViewHeaderFooterView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UITableViewHeaderFooterView *)tableViewHeaderFooterView;

@end
