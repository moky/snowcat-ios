//
//  SCBundle.h
//  SnowCat
//
//  Created by Moky on 14-3-18.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCBundle : NSBundle

+ (id) create:(NSDictionary *)dict;
+ (id) create:(NSDictionary *)dict autorelease:(BOOL)autorelease;

@end
