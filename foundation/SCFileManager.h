//
//  SCFileManager.h
//  SnowCat
//
//  Created by Moky on 14-12-24.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCFileManager : NSObject

+ (NSUInteger) sizeOfFile:(NSString *)path;

+ (NSDate *) creationDateOfFile:(NSString *)path;

+ (NSDate *) modificationDateOfFile:(NSString *)path;

@end
