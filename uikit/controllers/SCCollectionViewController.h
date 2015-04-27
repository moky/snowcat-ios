//
//  SCCollectionViewController.h
//  SnowCat
//
//  Created by Moky on 14-4-9.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCViewController.h"

@interface SCCollectionViewController : UICollectionViewController<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UICollectionViewController *)collectionViewController;

@end
