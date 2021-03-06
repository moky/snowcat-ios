//
//  SCPageScrollView.h
//  SnowCat
//
//  Created by Moky on 14-3-29.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "SCPageScrollViewDataSource.h"

UIKIT_EXTERN UIPageScrollViewDirection UIPageScrollViewDirectionFromString(NSString * string);

@interface SCPageScrollView : UIPageScrollView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIPageScrollView *)pageScrollView;

@end
