//
//  SCURL.h
//  SnowCat
//
//  Created by Moky on 14-3-24.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCURL : NSURL

// auto detect URL, or full file path, or filename in mainBundle
- (instancetype) initWithString:(NSString *)urlString isDirectory:(BOOL)isDir;

+ (NSDictionary *) parametersFromURL:(NSURL *)URL;

@end
