//
//  SCString+Extension.m
//  SnowCat
//
//  Created by Moky on 14-6-11.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
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

- (NSString *) replaceWithDictionary:(NSDictionary *)dict
{
	if ([self rangeOfString:@"${"].location == NSNotFound) {
		// no templates found
		return self;
	}
	
	NSAutoreleasePool * pool = nil;
	
	NSString * string = [self retain]; // retainCount++
	NSString * newString = nil;
	
	NSString * key;
	NSString * value;
	SC_FOR_EACH_KEY_VALUE(key, value, dict) {
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
