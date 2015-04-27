//
//  SCCollectionView.h
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCScrollView.h"

UIKIT_EXTERN UICollectionViewScrollPosition UICollectionViewScrollPositionFromString(NSString * string);

@interface SCCollectionView : UICollectionView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UICollectionView *)collectionView;

@end
