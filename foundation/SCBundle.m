//
//  SCBundle.m
//  SnowCat
//
//  Created by Moky on 14-3-18.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCObject.h"
#import "SCBundle.h"

@implementation SCBundle

// create:
SC_IMPLEMENT_CREATE_FUNCTION()
+ (id) create:(NSDictionary *)dict autorelease:(BOOL)autorelease
{
	NSBundle * bundle = nil;
	
	NSString * name = nil;
	if ([dict isKindOfClass:[NSDictionary class]]) {
		name = [dict objectForKey:@"File"];
		if (!name) {
			name = [dict objectForKey:@"name"];
		}
	} else {
		name = (NSString *)dict;
	}
	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	if (!name || [name isEqualToString:@"mainBundle"]) {
		bundle = [[NSBundle mainBundle] retain];
	} else {
		if (![[NSFileManager defaultManager] fileExistsAtPath:name]) {
			name = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:name];
		}
		bundle = [[NSBundle alloc] initWithPath:name];
	}
	
	[pool release];
	
	if (autorelease) {
		return [bundle autorelease];
	} else {
		return bundle;
	}
}

@end
