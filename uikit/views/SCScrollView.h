//
//  SCScrollView.h
//  SnowCat
//
//  Created by Moky on 14-3-17.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "SCView.h"

UIKIT_EXTERN UIScrollViewIndicatorStyle UIScrollViewIndicatorStyleFromString(NSString * string);

@interface SCScrollView : UIScrollView<SCUIKit, UIScrollViewDelegate>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIScrollView *)scrollView;

+ (void) adjustContentSizeOfScrollView:(UIScrollView *)scrollView;

@end
