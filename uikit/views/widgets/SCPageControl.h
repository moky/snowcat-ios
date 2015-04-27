//
//  SCPageControl.h
//  SnowCat
//
//  Created by Moky on 14-3-29.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCControl.h"

@interface SCPageControl : UIPageControl<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIPageControl *)pageControl;

// Value Event Interfaces
- (void) onChange:(id)sender;

@end
