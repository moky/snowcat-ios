//
//  SCGroundView.h
//  SnowCat
//
//  Created by Moky on 15-1-27.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "SCUIKit.h"
#import "SCGroundView+UIKit.h"

@interface SCGroundView : UIGroundView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIGroundView *)groundView;

@end
