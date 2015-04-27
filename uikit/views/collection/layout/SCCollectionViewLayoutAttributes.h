//
//  SCCollectionViewLayoutAttributes.h
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCUIKit.h"

@interface SCCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UICollectionViewLayoutAttributes *)collectionViewLayoutAttributes;

@end
