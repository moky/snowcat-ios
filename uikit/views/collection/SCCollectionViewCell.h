//
//  SCCollectionViewCell.h
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCCollectionReusableView.h"

@interface SCCollectionViewCell : UICollectionViewCell<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UICollectionViewCell *)collectionViewCell;

@end
