//
//  SCWaterfallView.h
//  SnowCat
//
//  Created by Moky on 15-5-8.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "SCUIKit.h"
#import "SCWaterfallView+UIKit.h"

@interface SCWaterfallView : UIWaterfallView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIWaterfallView *)waterfallView;

@end
