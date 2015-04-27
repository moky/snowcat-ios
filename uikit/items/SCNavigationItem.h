//
//  SCNavigationItem.h
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCUIKit.h"

@protocol SCNavigationItemDelegate <NSObject>

@optional

- (void) clickBackBarButtonItem:(id)sender;   // event: backBarButtonItem.onClick

- (void) clickLeftBarButtonItems:(id)sender;  // event: leftBarButtonItems[x].onClick
- (void) clickRightBarButtonItems:(id)sender; // event: rightBarButtonItems[x].onClick

- (void) clickLeftBarButtonItem:(id)sender;   // event: leftBarButtonItem.onClick
- (void) clickRightBarButtonItem:(id)sender;  // event: rightBarButtonItem.onClick

@end

// selector names
#define SCNavigationItemDelegate_clickBackBarButtonItem   @"clickBackBarButtonItem:"
#define SCNavigationItemDelegate_clickLeftBarButtonItems  @"clickLeftBarButtonItems:"
#define SCNavigationItemDelegate_clickRightBarButtonItems @"clickRightBarButtonItems:"
#define SCNavigationItemDelegate_clickLeftBarButtonItem   @"clickLeftBarButtonItem:"
#define SCNavigationItemDelegate_clickRightBarButtonItem  @"clickRightBarButtonItem:"

@interface SCNavigationItem : UINavigationItem<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UINavigationItem *)navigationItem;

@end
