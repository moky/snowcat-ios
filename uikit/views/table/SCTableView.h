//
//  SCTableView.h
//  SnowCat
//
//  Created by Moky on 14-3-18.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCScrollView.h"

UIKIT_EXTERN UITableViewStyle UITableViewStyleFromString(NSString * string);
UIKIT_EXTERN UITableViewScrollPosition UITableViewScrollPositionFromString(NSString * string);
UIKIT_EXTERN UITableViewRowAnimation UITableViewRowAnimationFromString(NSString * string);

@interface SCTableView : UITableView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UITableView *)tableView;

@end
