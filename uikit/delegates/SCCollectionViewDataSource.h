//
//  SCCollectionViewDataSource.h
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCTableViewDataHandler.h"

@protocol SCCollectionViewDataSource <UICollectionViewDataSource>

- (void) reloadData:(UICollectionView *)collectionView;

@end

@interface SCCollectionViewDataSource : SCObject<SCCollectionViewDataSource>

@property(nonatomic, retain) SCTableViewDataHandler * handler;

@end
