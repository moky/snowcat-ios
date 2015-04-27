//
//  SCURL.m
//  SnowCat
//
//  Created by Moky on 14-3-24.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCString.h"
#import "SCString+Extension.h"
#import "SCURL.h"

@implementation SCURL

- (instancetype) initWithString:(NSString *)urlString isDirectory:(BOOL)isDir
{
	if ([urlString rangeOfString:@"://"].location != NSNotFound) {
		// url string
		self = [self initWithString:urlString];
	} else {
		NSString * path = [urlString fullFilePath];
		path = [path appendDeviceSuffix]; // support multi device
		self = [self initFileURLWithPath:path isDirectory:isDir];
	}
	return self;
}

// the method 'initWithString:' will call 'initWithString:relativeToURL:'
// so we do the replacing in this method for more supporting
- (instancetype) initWithString:(NSString *)URLString relativeToURL:(NSURL *)baseURL
{
	URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	self = [super initWithString:URLString relativeToURL:baseURL];
	return self;
}

+ (NSDictionary *) parametersFromURL:(NSURL *)URL
{
	NSString * queryString = URL.query;
	NSArray * array = [queryString componentsSeparatedByString:@"&"];
	NSUInteger count = [array count];
	if (count == 0) {
		return nil;
	}
	
	NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithCapacity:count];
	NSEnumerator * enumerator = [array objectEnumerator];
	NSString * item;
	
	NSRange range;
	NSString * key;
	NSString * value;
	
	while (item = [enumerator nextObject]) {
		range = [item rangeOfString:@"="];
		if (range.location == NSNotFound) {
			SCLog(@"invalid item: %@", item);
			continue;
		}
		key = [item substringToIndex:range.location];
		value = [item substringFromIndex:range.location + range.length];
		
		value = [value stringByReplacingOccurrencesOfString:@"+" withString:@" "];
		value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSAssert([key isKindOfClass:[NSString class]], @"error key: %@", key);
		NSAssert([value isKindOfClass:[NSString class]], @"error value: %@", value);
		
		[parameters setObject:value forKey:key];
	}
	
	return parameters;
}

@end
