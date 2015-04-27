//
//  SCBarButtonItem.h
//  SnowCat
//
//  Created by Moky on 14-3-26.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCBarItem.h"

UIKIT_EXTERN UIBarMetrics UIBarMetricsFromString(NSString * string);
UIKIT_EXTERN UIBarButtonItemStyle UIBarButtonItemStyleFromString(NSString * string);
UIKIT_EXTERN UIBarButtonSystemItem UIBarButtonSystemItemFromString(NSString * string);

@interface SCBarButtonItem : UIBarButtonItem<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIBarButtonItem *)barButtonItem;

@end
