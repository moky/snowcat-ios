//
//  SCSegmentedScrollView.h
//  SnowCat
//
//  Created by Moky on 15-4-9.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "SCUIKit.h"
#import "SCSegmentedScrollView+UIKit.h"

@interface SCSegmentedScrollView : UISegmentedScrollView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UISegmentedScrollView *)segmentedScrollView;

@end
