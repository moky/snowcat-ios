//
//  SCCollectionReusableView.h
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCView.h"

@interface SCCollectionReusableView : UICollectionReusableView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UICollectionReusableView *)collectionReusableView;

@end
