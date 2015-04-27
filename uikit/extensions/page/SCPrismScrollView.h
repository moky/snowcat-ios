//
//  SCPrismScrollView.h
//  SnowCat
//
//  Created by Moky on 14-4-17.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCPageScrollView.h"

@interface UIPrismScrollView : UIPageScrollView

@end

#pragma mark -

@interface SCPrismScrollView : UIPrismScrollView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIPrismScrollView *)prismScrollView;

@end
