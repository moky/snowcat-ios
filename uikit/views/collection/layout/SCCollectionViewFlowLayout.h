//
//  SCCollectionViewFlowLayout.h
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCUIKit.h"

UIKIT_EXTERN UICollectionViewScrollDirection UICollectionViewScrollDirectionFromString(NSString * string);

@interface SCCollectionViewFlowLayout : UICollectionViewFlowLayout<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UICollectionViewFlowLayout *)collectionViewFlowLayout;

@end
