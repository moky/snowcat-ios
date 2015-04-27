//
//  SCBarItem.h
//  SnowCat
//
//  Created by Moky on 14-3-17.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCUIKit.h"

@interface SCBarItem : UIBarItem<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIBarItem *)barItem;

@end
