//
//  SCDictionary.m
//  SnowCat
//
//  Created by Moky on 14-3-19.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCMOFReader.h"
#import "SCMemoryCache.h"
#import "SCURL.h"
#import "SCString.h"
#import "SCString+Extension.h"
#import "SCDictionary.h"

@implementation SCDictionary

+ (NSDictionary *) dictionaryWithContentsOfFile:(NSString *)path
{
	return [self dictionaryWithContentsOfFile:path autorelease:YES];
}

+ (NSDictionary *) dictionaryWithContentsOfURL:(NSURL *)url
{
	return [self dictionaryWithContentsOfURL:url autorelease:YES];
}

+ (NSDictionary *) dictionaryWithContentsOfFile:(NSString *)path autorelease:(BOOL)autorelease
{
	NSAssert([path length] > 0, @"path cannot be empty");
	NSDictionary * dict = nil;
	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSString * file;
	NSURL * url;
	
	NSString * ext = [[path pathExtension] lowercaseString];
	if ([ext isEqualToString:@"mof"]) {
		// 1.1. try '*.mof' first
		url = [[SCURL alloc] initWithString:path isDirectory:NO];
		dict = [self dictionaryWithContentsOfURL:url autorelease:NO];
		[url release];
		
		if (!dict) {
			// 1.2. if nothing loaded, try '*.plist'
			file = [[path stringByDeletingPathExtension] stringByAppendingPathExtension:@"plist"];
			url = [[SCURL alloc] initWithString:file isDirectory:NO];
			dict = [self dictionaryWithContentsOfURL:url autorelease:NO];
			[url release];
		}
	} else {
		// 2.1. try '*.plist/js/json'
		url = [[SCURL alloc] initWithString:path isDirectory:NO];
		dict = [self dictionaryWithContentsOfURL:url autorelease:NO];
		[url release];
		
		if (!dict) {
			// 2.2. if nothing loaded, try '*.mof'
			file = [[path stringByDeletingPathExtension] stringByAppendingPathExtension:@"mof"];
			url = [[SCURL alloc] initWithString:file isDirectory:NO];
			dict = [self dictionaryWithContentsOfURL:url autorelease:NO];
			[url release];
		}
	}
	
	[pool release];
	
	return autorelease ? [dict autorelease] : dict;
}

+ (NSDictionary *) dictionaryWithContentsOfURL:(NSURL *)url autorelease:(BOOL)autorelease
{
	SCMemoryCache * cache = [SCMemoryCache getInstance];
	
	NSDictionary * dict = [cache objectForKey:url];
	
	if (dict) {
		//SCLog(@"get file from cache: %@", [url lastPathComponent]);
		[dict retain]; // reference ++
	} else {
		NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
		
		NSString * ext = [[url pathExtension] lowercaseString];
		if ([ext isEqualToString:@"plist"]) {
			dict = [[NSDictionary alloc] initWithContentsOfURL:url]; // reference == 1
		} else if ([ext isEqualToString:@"js"] || [ext isEqualToString:@"json"]) {
			dict = [self dictionaryWithContentsOfJsonURL:url autorelease:NO]; // reference == 2 but autorelease once
		} else if ([ext isEqualToString:@"mof"]) {
			dict = [self dictionaryWithContentsOfMofURL:url autorelease:NO]; // ...
		} else {
			NSAssert(false, @"unrecognized file type: %@", url);
		}
		SCLog(@"**** I/O **** URL: %@", url);
		
		if (dict) {
			[cache setObject:dict forKey:url];
		}
		
		[pool release];
	}
	
	if (dict && autorelease) {
		return [dict autorelease];
	} else {
		return dict;
	}
}

@end

@implementation SCDictionary (Replacement)

+ (NSMutableDictionary *) mergeDictionary:(NSDictionary *)dict withAttributes:(NSDictionary *)attributes
{
	NSAssert([dict isKindOfClass:[NSDictionary class]], @"parameters error: %@, %@", dict, attributes);
	NSAssert([attributes isKindOfClass:[NSDictionary class]], @"parameters error: %@, %@", dict, attributes);
	if (!dict) {
		return attributes ? [[attributes mutableCopy] autorelease] : nil;
	} else if (!attributes) {
		return [[dict mutableCopy] autorelease];
	}
	
	NSMutableDictionary * mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
	[mDict addEntriesFromDictionary:attributes];
	return mDict;
}

+ (NSDictionary *) replaceDictionary:(NSDictionary *)dict withData:(NSDictionary *)data
{
	NSAssert([dict isKindOfClass:[NSDictionary class]], @"parameters error: %@, %@", dict, data);
	NSAssert(!data || [data isKindOfClass:[NSDictionary class]], @"parameters error: %@, %@", dict, data);
	if (!dict) {
		return nil;
	} else if (!data) {
		return dict;
	}
	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	// 1. convert the dictionary to a string
	NSString * stringJSON = [SCString stringBySerializingObject:dict];
	NSAssert(stringJSON, @"invalid dict: %@", dict);
	
	// 2. replace as string
	stringJSON = [stringJSON replaceWithDictionary:data];
	
	// fix a bug while the JSON string includes '\n' charactors
	NSRange range = [stringJSON rangeOfString:@"\n"];
	if (range.location != NSNotFound) {
		SCLog(@"fix invalid format string: %@", stringJSON);
		stringJSON = [stringJSON stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
		stringJSON = [stringJSON stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
	}
	
	// 3. convert the string to a dictionary
	dict = (NSDictionary *)[SCString objectFromJsonString:stringJSON]; // references = 1, autorelease
	NSAssert([dict isKindOfClass:[NSDictionary class]], @"replace failed, string: %@", stringJSON);
	
	[dict retain]; // references = 2, autorelease
	[pool release];
	
	return [dict autorelease]; // references = 1, autorelease
}

@end

@implementation SCDictionary (JsON)

+ (NSDictionary *) dictionaryWithContentsOfJsonURL:(NSURL *)url
{
	return [self dictionaryWithContentsOfJsonURL:url autorelease:YES];
}

+ (NSDictionary *) dictionaryWithContentsOfJsonURL:(NSURL *)url autorelease:(BOOL)autorelease
{
	NSDictionary * dict = nil;
	
	NSData * data = [[NSData alloc] initWithContentsOfURL:url];
	if (data) {
		NSObject * object = [SCString objectFromJsonData:data autorelease:autorelease];
		if ([object isKindOfClass:[NSDictionary class]]) {
			dict = (NSDictionary *)object;
		} else if (!autorelease && object) {
			// release the error object
			[object release];
		}
		[data release];
	}
	
	return dict;
}

@end

@implementation SCDictionary (PlistBinaryFile)

+ (NSDictionary *) dictionaryWithContentsOfMofURL:(NSURL *)url
{
	return [self dictionaryWithContentsOfMofURL:url autorelease:YES];
}

+ (NSDictionary *) dictionaryWithContentsOfMofURL:(NSURL *)url autorelease:(BOOL)autorelease
{
	NSString * file = [url path];
	SCLog(@"loading MOF file: %@", file);
	SCMOFReader * mof = [[SCMOFReader alloc] initWithFile:file];
	NSObject * root = [mof root];
	NSDictionary * dict = [root isKindOfClass:[NSDictionary class]] ? [(NSDictionary *)root retain] : nil;
	[mof release];
	return autorelease ? [dict autorelease] : dict;
}

@end
