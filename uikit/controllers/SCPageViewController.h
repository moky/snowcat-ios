//
//  SCPageViewController.h
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCViewController.h"

UIKIT_EXTERN UIPageViewControllerNavigationOrientation UIPageViewControllerNavigationOrientationFromString(NSString * string);
UIKIT_EXTERN UIPageViewControllerSpineLocation UIPageViewControllerSpineLocationFromString(NSString * string);
UIKIT_EXTERN UIPageViewControllerNavigationDirection UIPageViewControllerNavigationDirectionFromString(NSString * string);
UIKIT_EXTERN UIPageViewControllerTransitionStyle UIPageViewControllerTransitionStyleFromString(NSString * string);

@interface SCPageViewController : UIPageViewController<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIPageViewController *)pageViewController;

@end
