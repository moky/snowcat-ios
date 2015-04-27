//
//  SCCollectionViewDelegate.h
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCTableViewDataHandler.h"

@protocol SCCollectionViewDelegate <UICollectionViewDelegate>

@end

@interface SCCollectionViewDelegate : SCObject<SCCollectionViewDelegate>

@property(nonatomic, retain) SCTableViewDataHandler * handler;

@end
