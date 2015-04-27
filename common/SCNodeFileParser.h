//
//  SCNodeFileParser.h
//  SnowCat
//
//  Created by Moky on 12-9-28.
//  Copyright 2012 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SC_NODE_FILE_RESOURCE_PATH_KEY    @"resourcePath"

@interface SCNodeFileParser : NSObject

@property(nonatomic, retain) NSDictionary * vars; // replacement

+ (instancetype) parser:(NSString *)path; // load data and parse

- (instancetype) initWithFile:(NSString *)path; // just load data from file, not parsed yet

- (BOOL) parse;

- (id) node; // get the node by key name 'Node' or 'SFNode'(sprite forest node)

@end
