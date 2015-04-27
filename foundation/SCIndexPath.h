//
//  SCIndexPath.h
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCIndexPath : NSIndexPath

+ (id) create:(NSDictionary *)dict;
+ (id) create:(NSDictionary *)dict autorelease:(BOOL)autorelease;

@end
