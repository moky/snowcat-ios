//
//  SCDictionary.h
//  SnowCat
//
//  Created by Moky on 14-3-19.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCDictionary : NSObject

+ (NSDictionary *) dictionaryWithContentsOfFile:(NSString *)path;
+ (NSDictionary *) dictionaryWithContentsOfFile:(NSString *)path autorelease:(BOOL)autorelease;

+ (NSDictionary *) dictionaryWithContentsOfURL:(NSURL *)url;
+ (NSDictionary *) dictionaryWithContentsOfURL:(NSURL *)url autorelease:(BOOL)autorelease;

@end

@interface SCDictionary (Replacement)

// 1. copy all key-values in 'dict' to a new dictionary
// 2. replace attributes in the new dictionary with key-values in 'attributes'
+ (NSMutableDictionary *) mergeDictionary:(NSDictionary *)dict withAttributes:(NSDictionary *)attributes;

// 1. flat the 'dict' into a jason string
// 2. replace all '${key}' tags in the jason string with key-values in 'data'
// 3. build a new dictionary with the jason string
// 4. return the new dictionary; if the operations above failed, return the origin 'dict'
+ (NSDictionary *) replaceDictionary:(NSDictionary *)dict withData:(NSDictionary *)data;

@end

@interface SCDictionary (JsON)

+ (NSDictionary *) dictionaryWithContentsOfJsonURL:(NSURL *)url;
+ (NSDictionary *) dictionaryWithContentsOfJsonURL:(NSURL *)url autorelease:(BOOL)autorelease;

@end

@interface SCDictionary (PlistBinaryFile)

+ (NSDictionary *) dictionaryWithContentsOfMofURL:(NSURL *)url;
+ (NSDictionary *) dictionaryWithContentsOfMofURL:(NSURL *)url autorelease:(BOOL)autorelease;

@end
