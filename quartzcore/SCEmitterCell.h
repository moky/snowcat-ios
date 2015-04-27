//
//  SCEmitterCell.h
//  SnowCat
//
//  Created by Moky on 14-12-31.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

CA_EXTERN NSArray * SCEmitterCellsFromArray(NSArray * array);

@interface SCEmitterCell : CAEmitterCell<SCObject>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(CAEmitterCell *)emitterCell;

@end
