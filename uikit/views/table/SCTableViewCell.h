//
//  SCTableViewCell.h
//  SnowCat
//
//  Created by Moky on 14-3-18.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCView.h"

UIKIT_EXTERN UITableViewCellStyle UITableViewCellStyleFromString(NSString * string);
UIKIT_EXTERN UITableViewCellSeparatorStyle UITableViewCellSeparatorStyleFromString(NSString * string);
UIKIT_EXTERN UITableViewCellSelectionStyle UITableViewCellSelectionStyleFromString(NSString * string);
UIKIT_EXTERN UITableViewCellEditingStyle UITableViewCellEditingStyleFromString(NSString * string);
UIKIT_EXTERN UITableViewCellAccessoryType UITableViewCellAccessoryTypeFromString(NSString * string);
UIKIT_EXTERN UITableViewCellStateMask UITableViewCellStateMaskFromString(NSString * string);

@protocol UITableViewCell <NSObject>

@optional
- (void) onReuse:(id)sender;

@end

@interface SCTableViewCell : UITableViewCell<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UITableViewCell *)tableViewCell;

+ (void) resetCell:(UITableViewCell *)cell withTableView:(UITableView *)tableView;

@end
