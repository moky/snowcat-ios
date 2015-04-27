//
//  SCFileManager.m
//  SnowCat
//
//  Created by Moky on 14-12-24.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCFileManager.h"

@implementation SCFileManager

+ (NSDictionary *) attributesOfFile:(NSString *)path
{
	NSFileManager * fm = [[NSFileManager alloc] init];
	NSError * err = nil;
	NSDictionary * attr = [fm attributesOfItemAtPath:path error:&err];
	if (err) {
		SCLog(@"error: %@, attributes: %@, path: %@", err, attr, path);
		attr = nil;
	} else {
		[attr retain]; // retainCount++
	}
	[fm release];
	
	return [attr autorelease]; // retainCount--
}

+ (NSUInteger) sizeOfFile:(NSString *)path
{
	NSDictionary * attr = [self attributesOfFile:path];
	id size = [attr objectForKey:NSFileSize];
	SCLog(@"file: %@, size: %@", path, size);
	return [size unsignedIntegerValue];
}

+ (NSDate *) creationDateOfFile:(NSString *)path
{
	NSDictionary * attr = [self attributesOfFile:path];
	NSDate * date = [attr objectForKeyedSubscript:NSFileCreationDate];
	SCLog(@"file: %@, creation date: %@", path, date);
	return date;
}

+ (NSDate *) modificationDateOfFile:(NSString *)path
{
	NSDictionary * attr = [self attributesOfFile:path];
	NSDate * date = [attr objectForKeyedSubscript:NSFileModificationDate];
	SCLog(@"file: %@, modification date: %@", path, date);
	return date;
}

@end
