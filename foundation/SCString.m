//
//  SCString.m
//  SnowCat
//
//  Created by Moky on 14-3-19.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>

#import "NSString+MD5Addition.h"
#import "SCLog.h"
#import "SCMath.h"
#import "SCClient.h"
#import "SCString+Extension.h"
#import "SCString.h"

#pragma mark Arithmetic Operations

CGFloat CGFloatFromString(NSString * string)
{
	return calculate([string cStringUsingEncoding:NSUTF8StringEncoding]);
}

#pragma mark -

@implementation SCString

@end

@implementation SCString (MD5)

+ (NSString *) MD5String:(NSString *)string
{
	return [string stringFromMD5];
}

@end

@implementation SCString (JsON)

+ (NSString *) stringBySerializingObject:(NSObject *)obj
{
	return [self stringBySerializingObject:obj autorelease:YES];
}

+ (NSString *) stringBySerializingObject:(NSObject *)obj autorelease:(BOOL)autorelease
{
	NSString * string = nil;
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSError * error = nil;
	NSJSONWritingOptions opt = 0;
	NSData * data = [NSJSONSerialization dataWithJSONObject:obj options:opt error:&error];
	if (error || !data) {
		SCLog(@"failed to encode json obj: %@", obj);
		[pool release];
		return nil;
	}
	
	string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	[pool release];
	return autorelease ? [string autorelease] : string;
}

+ (NSObject *) objectFromJsonString:(NSString *)jsonString
{
	return [self objectFromJsonString:jsonString autorelease:YES];
}

+ (NSObject *) objectFromJsonString:(NSString *)jsonString autorelease:(BOOL)autorelease
{
	NSObject * object = nil;
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSData * data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
	object = [self objectFromJsonData:data autorelease:NO]; // retain = 1
	
	[pool release];
	return autorelease ? [object autorelease] : object;
}

+ (NSObject *) objectFromJsonData:(NSData *)data
{
	return [self objectFromJsonData:data autorelease:YES];
}

+ (NSObject *) objectFromJsonData:(NSData *)data autorelease:(BOOL)autorelease
{
	NSObject * obj = nil;
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSError * error = nil;
	NSJSONReadingOptions opt = NSJSONReadingAllowFragments;
	obj = [NSJSONSerialization JSONObjectWithData:data options:opt error:&error];
	if (error || !obj) {
		//SCLog(@"failed to decode json data: %@", data);
		[pool release];
		return nil;
	}
	[obj retain]; // avoid auto release pool deleting this object
	
	[pool release];
	return autorelease ? [obj autorelease] : obj;
}

@end

@implementation SCString (Map)

+ (NSDictionary *) dictionaryFromMapString:(NSString *)string
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSArray * pairs = [string componentsSeparatedByString:@";"];
	NSAssert([pairs count] > 0, @"no key-value found");
	
	NSMutableDictionary * mDict = [[NSMutableDictionary alloc] initWithCapacity:[pairs count]];
	NSEnumerator * enumerator = [pairs objectEnumerator];
	NSString * pair;
	while (pair = [enumerator nextObject]) {
		NSRange range = [pair rangeOfString:@":"];
		if (range.location == NSNotFound) {
			continue;
		}
		
		// key
		NSString * key = [pair substringToIndex:range.location];
		key = [key trim];
		NSAssert([key length] > 0, @"key cannot be empty");
		
		// value
		NSString * value = [pair substringFromIndex:range.location + 1];
		value = [value trim];
		value = [value trim:@"'"];
		value = [value unescape];
		
		[mDict setObject:value forKey:key];
	}
	
	[pool release];
	return [mDict autorelease];
}

@end

@implementation SCString (Math)

+ (NSString *) caculateString:(NSString *)string
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSRange range;
	
	NSInteger pos1, pos2;
	unichar ch;
	NSString * substr;
	
	for (pos1 = [string length] - 1; pos1 >= 0; --pos1) {
		
		for (pos2 = pos1; pos2 >= 0; --pos2) {
			ch = [string characterAtIndex:pos2];
			if (ch != '{' && ch != '}' && ch != ',') {
				break;
			}
		}
		
		for (pos1 = pos2; pos1 >= 0; --pos1) {
			ch = [string characterAtIndex:pos1];
			if (ch == '{' || ch == '}' || ch == ',') {
				break;
			}
		}
		
		range.location = pos1 + 1;
		range.length = pos2 - pos1;
		substr = [string substringWithRange:range];
		substr = [substr trim];
		if ([substr length] > 0) {
			string = [NSString stringWithFormat:@"%@%.1f%@",
					  [string substringToIndex:pos1 + 1],
					  CGFloatFromString(substr),
					  [string substringFromIndex:pos2 + 1]];
		}
	}
	
	[string retain];
	[pool release];
	
	return [string autorelease];
}

@end
