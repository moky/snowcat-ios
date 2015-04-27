//
//  SCString.h
//  SnowCat
//
//  Created by Moky on 14-3-19.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

FOUNDATION_EXPORT CGFloat CGFloatFromString(NSString * string);

@interface SCString : NSObject @end

@interface SCString (MD5)

+ (NSString *) MD5String:(NSString *)string;

@end

@interface SCString (JsON)

+ (NSString *) stringBySerializingObject:(NSObject *)obj;
+ (NSString *) stringBySerializingObject:(NSObject *)obj autorelease:(BOOL)autorelease;

+ (NSObject *) objectFromJsonString:(NSString *)jsonString;
+ (NSObject *) objectFromJsonString:(NSString *)jsonString autorelease:(BOOL)autorelease;

+ (NSObject *) objectFromJsonData:(NSData *)data;
+ (NSObject *) objectFromJsonData:(NSData *)data autorelease:(BOOL)autorelease;

@end

@interface SCString (Map) // key-value (css) format string

+ (NSDictionary *) dictionaryFromMapString:(NSString *)string;

@end

@interface SCString (Math)

// "{{1+2, 3-4}, {5*6, 7/8}}" => "{{3,-1},{30,0.875}}"
+ (NSString *) caculateString:(NSString *)string;

@end
