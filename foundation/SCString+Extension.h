//
//  SCString+Extension.h
//  SnowCat
//
//  Created by Moky on 14-6-11.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Replacement)

// replace all '${key}' tags with key-values in 'dict'
- (NSString *) replaceWithDictionary:(NSDictionary *)dict;

// replace env vars '${...}', such as '${app}', '${docs}', '${caches}' or '${tmp}' ...
- (NSString *) fullFilePath;
- (NSString *) fullFilePath:(NSString *)baseDir;

@end
