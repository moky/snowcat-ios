//
//  SCURL.m
//  SnowCat
//
//  Created by Moky on 14-3-24.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCString.h"
#import "SCString+Extension.h"
#import "SCString+DeviceSuffix.h"
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

@end
