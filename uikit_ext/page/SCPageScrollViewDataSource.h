//
//  SCPageScrollViewDataSource.h
//  SnowCat
//
//  Created by Moky on 14-7-6.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "SlanissueToolkit.h"

#import "SCUIKit.h"

@protocol SCPageScrollViewDataSource <UIPageScrollViewDataSource>

@end

@interface SCPageScrollViewDataSource : SCObject<SCPageScrollViewDataSource>

- (void) setData:(NSArray *)array;

@end
