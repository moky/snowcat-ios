//
//  SCComplexTableView.h
//  SnowCat
//
//  Created by Moky on 14-12-30.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "SCUIKit.h"
#import "SCComplexTableView+UIKit.h"

@interface SCComplexTableView : UIComplexTableView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIComplexTableView *)complexTableView;

@end
