//
//  SCCollectionViewLayout.h
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCUIKit.h"

UIKIT_EXTERN UICollectionElementCategory UICollectionElementCategoryFromString(NSString * string);
UIKIT_EXTERN UICollectionUpdateAction UICollectionUpdateActionFromString(NSString * string);

@interface SCCollectionViewLayout : UICollectionViewLayout<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UICollectionViewLayout *)collectionViewLayout;

@end
