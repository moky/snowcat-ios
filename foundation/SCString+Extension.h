//
//  SCString+Extension.h
//  SnowCat
//
//  Created by Moky on 14-6-11.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Replacement)

- (NSString *) trim;
- (NSString *) trim:(NSString *)chars;

// encode/decode string for URL parameters
- (NSString *) escape;
- (NSString *) unescape;

// replace all '${key}' tags with key-values in 'dict'
- (NSString *) replaceWithDictionary:(NSDictionary *)dict;

// "/path/to/../something" => "/path/something"
- (NSString *) simplifyPath;

// append suffix like "@2x", "~ipad", "~iphone", "-568h@2x", ...
- (NSString *) appendDeviceSuffix;

// replace env vars '${...}', such as '${app}', '${docs}', '${caches}' or '${tmp}' ...
- (NSString *) fullFilePath;
- (NSString *) fullFilePath:(NSString *)baseDir;

@end
