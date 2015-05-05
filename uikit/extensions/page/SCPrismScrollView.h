//
//  SCPrismScrollView.h
//  SnowCat
//
//  Created by Moky on 14-4-17.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCUIKit.h"
#import "SCPrismScrollView+UIKit.h"

@interface SCPrismScrollView : UIPrismScrollView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIPrismScrollView *)prismScrollView;

@end
