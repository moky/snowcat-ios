//
//  SCTime.h
//  SnowCat
//
//  Created by Moky on 15-5-11.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef long long SCTimeValue;

@interface SCTime : NSObject

@property(nonatomic, readonly) time_t second;
@property(nonatomic, readonly) int nanosecond;

@end

@interface SCTime (Convenient)

+ (SCTimeValue) second;
+ (SCTimeValue) millisecond; // 0.001 second (10 ^ -3)
+ (SCTimeValue) microsecond; // 0.000001 second (10 ^ -6)
+ (SCTimeValue) nanosecond;  // 0.000000001 second (10 ^ -9)

@end
