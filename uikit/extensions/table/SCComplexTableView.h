//
//  SCComplexTableView.h
//  SnowCat
//
//  Created by Moky on 14-12-30.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCTableView.h"

@interface UIComplexTableView : UITableView

@end

#pragma mark -

@interface SCComplexTableView : UIComplexTableView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIComplexTableView *)complexTableView;

@end
