//
//  SCGridTableView.h
//  SnowCat
//
//  Created by Moky on 14-4-23.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "SCUIKit.h"
#import "SCGridTableView+UIKit.h"

@interface SCGridTableView : UIGridTableView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIGridTableView *)gridTableView;

@end
