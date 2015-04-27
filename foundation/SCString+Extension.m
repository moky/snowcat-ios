//
//  SCString+Extension.m
//  SnowCat
//
//  Created by Moky on 14-6-11.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCClient.h"
#import "SCString.h"
#import "SCString+Extension.h"

@implementation NSString (Math)

//- (double) doubleValue
//{
//	return CGFloatFromString(self);
//}

- (float) floatValue
{
	return CGFloatFromString(self);
}

//- (int) intValue
//{
//	return CGFloatFromString(self);
//}

- (NSInteger) integerValue
{
	return CGFloatFromString(self);
}

//- (long long) longLongValue
//{
//	return CGFloatFromString(self);
//}

@end

@implementation NSString (Replacement)

- (NSString *) trim
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *) trim:(NSString *)chars
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:chars]];
}

- (NSString *) escape
{
	return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *) unescape
{
	return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *) replaceWithDictionary:(NSDictionary *)dict
{
	if ([self rangeOfString:@"${"].location == NSNotFound) {
		// no templates found
		return self;
	}
	
	NSAutoreleasePool * pool = nil;
	
	NSString * string = [self retain]; // retainCount++
	NSString * newString = nil;
	
	NSEnumerator * keyEnumerator = [dict keyEnumerator];
	NSString * key;
	NSString * value;
	while (key = [keyEnumerator nextObject]) {
		value = [dict objectForKey:key];
		NSAssert([key isKindOfClass:[NSString class]], @"key must be a string: %@, dict: %@", key, dict);
		NSAssert([value isKindOfClass:[NSString class]], @"value must be a string: %@, key: %@, dict: %@", value, key, dict);
		
		pool = [[NSAutoreleasePool alloc] init];
		
		if (![value isKindOfClass:[NSString class]]) {
			value = [NSString stringWithFormat:@"%@", value];
		}
		key = [NSString stringWithFormat:@"${%@}", key];
		newString = [string stringByReplacingOccurrencesOfString:key withString:value];
		
		//
		// 1. to avoid the 'Memory Storm' (occupying too much memory at the same time)
		//    here we release the temporary objects (autoreleased) immediately
		//
		// 2. to avoid a potential crash (though it seems would not happen)
		//    while 'newString' and 'string' pointing to the same object
		//    here we should retain the new string before releasing the old one
		//
		[newString retain]; // retainCount++
		[string release]; // retainCount--
		string = newString;
		
		[pool release];
	}
	
	return [string autorelease]; // retainCount--
}

- (NSString *) simplifyPath
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSString * string = self;
	NSRange range1, range2;
	
	while ((range1 = [string rangeOfString:@"/../"]).location != NSNotFound) {
		if (range1.location < 1 || [string characterAtIndex:range1.location - 1] == '/') {
			SCLog(@"error: %@", string);
			break;
		}
		range2 = [string rangeOfString:@"/" options:NSBackwardsSearch range:NSMakeRange(0, range1.location)];
		if (range2.location == NSNotFound) {
			range2.location = -1;
		}
		NSString * str1 = [string substringWithRange:NSMakeRange(0, range2.location + 1)];
		NSString * str2 = [string substringFromIndex:range1.location + 4];
		string = [str1 stringByAppendingString:str2];
	}
	
	[string retain];
	[pool release];
	
	return [string autorelease];
}

- (NSString *) appendDeviceSuffix
{
	SCClient * client = [SCClient getInstance];
	BOOL ipad = [client.deviceModel rangeOfString:@"iPad"].location != NSNotFound;
	BOOL retina = client.screenScale > 1.5f;
	BOOL iphone5 = !ipad && retina && client.screenSize.height == 568.0f;
	
	NSFileManager * fm = [NSFileManager defaultManager];
	BOOL isDirectory = NO;
	
	NSString * ext = [self pathExtension];
	NSString * filename = [self stringByDeletingPathExtension];
	
	if (ipad) {
		NSString * path = [filename stringByAppendingString:SC_PATH_SUFFIX_IPAD];
		if (retina) {
			// Retina iPad
			NSString * path2 = [path stringByAppendingString:SC_PATH_SUFFIX_RETINA];
			path2 = [path2 stringByAppendingPathExtension:ext];
			if ([fm fileExistsAtPath:path2 isDirectory:&isDirectory]) {
				return path2; // ~ipad@2x
			}
		}
		// iPad
		path = [path stringByAppendingPathExtension:ext];
		if ([fm fileExistsAtPath:path isDirectory:&isDirectory]) {
			return path; // ~ipad
		}
	} else if (iphone5) {
		NSString * path = [filename stringByAppendingString:SC_PATH_SUFFIX_568H];
//		if (retina) {
			// Retina iPhone5/iPod5
			NSString * path2 = [path stringByAppendingString:SC_PATH_SUFFIX_RETINA];
			path2 = [path2 stringByAppendingPathExtension:ext];
			if ([fm fileExistsAtPath:path2 isDirectory:&isDirectory]) {
				return path2; // -568h@2x
			}
//		}
//		// iPhone5/iPod5
//		path = [path stringByAppendingPathExtension:ext];
//		if ([fm fileExistsAtPath:path isDirectory:&isDirectory]) {
//			return path; // -568h
//		}
	} else {
		NSString * path = [filename stringByAppendingString:SC_PATH_SUFFIX_IPHONE];
		if (retina) {
			// Retina iPhone/iPod
			NSString * path2 = [path stringByAppendingString:SC_PATH_SUFFIX_RETINA];
			path2 = [path2 stringByAppendingPathExtension:ext];
			if ([fm fileExistsAtPath:path2 isDirectory:&isDirectory]) {
				return path2; // ~iphone@2x
			}
		}
		// iPhone/iPod
		path = [path stringByAppendingPathExtension:ext];
		if ([fm fileExistsAtPath:path isDirectory:&isDirectory]) {
			return path; // ~iphone
		}
	}
	
	if (retina) {
		// Retina
		NSString * path2 = [filename stringByAppendingString:SC_PATH_SUFFIX_RETINA];
		path2 = [path2 stringByAppendingPathExtension:ext];
		if ([fm fileExistsAtPath:path2 isDirectory:&isDirectory]) {
			return path2; // @2x
		}
	}
	
	// original
	return self;
}

- (NSString *) fullFilePath
{
	return [self fullFilePath:SCApplicationDirectory()];
}

- (NSString *) fullFilePath:(NSString *)baseDir
{
	NSAssert([baseDir length] > 0, @"base dir cannot be empty");
	NSString * string = self;
	if ([string length] < 6 || [string characterAtIndex:0] != '$') {
		// no replacement found
		if ([string rangeOfString:@"://"].location != NSNotFound) {
			// url string
			return string;
		} else if ([string isAbsolutePath]) {
			// absolute file path
			string = [string simplifyPath];
			return string;
		} else {
			// file in main bundle
			string = [baseDir stringByAppendingPathComponent:string];
			string = [string simplifyPath];
			return string;
		}
	}
	
	NSString * dir = nil;
	NSUInteger offset = 0;
	
	do {
		// main bundle
		if ([string hasPrefix:@"${mainBundle}"]) {
			dir = SCApplicationDirectory();
			offset = 13;
			break;
		}
		if ([string hasPrefix:@"${main}"]) {
			dir = SCApplicationDirectory();
			offset = 7;
			break;
		}
		if ([string hasPrefix:@"${app}"]) {
			dir = SCApplicationDirectory();
			offset = 6;
			break;
		}
		
		// document directory
		if ([string hasPrefix:@"${documentDirectory}"]) {
			dir = SCDocumentDirectory();
			offset = 20;
			break;
		}
		if ([string hasPrefix:@"${document}"]) {
			dir = SCDocumentDirectory();
			offset = 11;
			break;
		}
		if ([string hasPrefix:@"${docs}"]) {
			dir = SCDocumentDirectory();
			offset = 7;
			break;
		}
		
		// caches directory
		if ([string hasPrefix:@"${cachesDirectory}"]) {
			dir = SCCachesDirectory();
			offset = 18;
			break;
		}
		if ([string hasPrefix:@"${caches}"]) {
			dir = SCCachesDirectory();
			offset = 9;
			break;
		}
		
		// temporary directory
		if ([string hasPrefix:@"${temporaryDirectory}"]) {
			dir = SCTemporaryDirectory();
			offset = 21;
			break;
		}
		if ([string hasPrefix:@"${tmp}"]) {
			dir = SCTemporaryDirectory();
			offset = 6;
			break;
		}
		
		NSAssert(false, @"failed to parse filename: %@", string);
		return string;
	} while (false);
	
	string = [string substringFromIndex:offset];
	string = [dir stringByAppendingPathComponent:string];
	string = [string simplifyPath];
	return string;
}

@end
