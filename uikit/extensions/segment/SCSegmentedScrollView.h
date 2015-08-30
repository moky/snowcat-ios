//
//  SCSegmentedScrollView.h
//  SnowCat
//
//  Created by Moky on 15-4-9.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "SCUIKit.h"

UIKIT_EXTERN UISegmentedScrollViewControlPosition UISegmentedScrollViewControlPositionFromString(NSString * string);

@interface SCSegmentedScrollView : UISegmentedScrollView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UISegmentedScrollView *)segmentedScrollView;

@end
