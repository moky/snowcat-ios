//
//  SCNib.m
//  SnowCat
//
//  Created by Moky on 14-4-25.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCString.h"
#import "SCString+Extension.h"
#import "SCNodeFileParser.h"
#import "SCResponder.h"
#import "SCBundle.h"
#import "SCNib.h"

@implementation SCNib

+ (NSDictionary *) _bundleFromDictionary:(NSDictionary *)dict
{
	NSDictionary * nibBundle = [dict objectForKey:@"nibBundle"];
	return nibBundle ? nibBundle : [dict objectForKey:@"bundle"];
}

+ (NSBundle *) bundleFromDictionary:(NSDictionary *)dict
{
	return [self bundleFromDictionary:dict autorelease:YES];
}

+ (NSBundle *) bundleFromDictionary:(NSDictionary *)dict autorelease:(BOOL)autorelease
{
	dict = [self _bundleFromDictionary:dict];
	return dict ? [SCBundle create:dict autorelease:autorelease] : nil;
}

+ (NSString *) nibNameFromDictionary:(NSDictionary *)dict
{
	NSString * nibName = [dict objectForKey:@"nibName"];
	if (nibName) {
		return nibName;
	}
	NSDictionary * bundle = [self _bundleFromDictionary:dict];
	return bundle ? [bundle objectForKey:@"name"] : nil;
}

@end

@implementation SCNib (Awaking)

+ (void) viewDidLoad:(UIView *)view withNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
	if (!nibName) {
		return;
	}
	NSArray * array = [view subviews];
	if ([array count] == 0) {
		return;
	}
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	if (!bundle) {
		bundle = [NSBundle mainBundle];
	}
	NSString * path = [bundle resourcePath];
	path = [[path stringByAppendingPathComponent:nibName] stringByDeletingLastPathComponent]; // ...
	
	NSEnumerator * enumerator = [array objectEnumerator];
	id child;
	NSString * nodeFile;
	
	SCNodeFileParser * nfp;
	NSDictionary * dict;
	
	while (child = [enumerator nextObject]) {
		if ([child respondsToSelector:@selector(nodeFile)] &&
			[child respondsToSelector:@selector(buildHandlers:)]) {
			nodeFile = [child nodeFile];
			if ([nodeFile length] > 0 &&
				[nodeFile characterAtIndex:0] != '$' && /* build by 'awakeFromNib' */
				[nodeFile characterAtIndex:0] != '/' /* error */) {
				nodeFile = [path stringByAppendingPathComponent:nodeFile];
				nfp = [SCNodeFileParser parser:nodeFile];
				dict = [nfp node];
				NSAssert([dict isKindOfClass:[NSDictionary class]], @"node file data error: %@", nodeFile);
				[child buildHandlers:dict];
			}
		}
		[self viewDidLoad:child withNibName:nibName bundle:bundle];
	}
	
	[pool release];
}

+ (void) awakeFromNib:(id<SCUIKit>)view withNodeFile:(NSString *)nodeFile
{
	if (!nodeFile) {
		return;
	}
	NSAssert([view respondsToSelector:@selector(buildHandlers:)], @"cannot build handlers for this view: %@", view);
	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	nodeFile = [nodeFile fullFilePath];
	if (nodeFile) {
		SCNodeFileParser * nfp = [SCNodeFileParser parser:nodeFile];
		NSDictionary * dict = [nfp node];
		NSAssert([dict isKindOfClass:[NSDictionary class]], @"node file data error: %@", nodeFile);
		[view buildHandlers:dict];
	}
	
	[pool release];
}

@end
