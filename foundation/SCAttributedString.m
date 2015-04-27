//
//  SCAttributedString.m
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCAttributedString.h"

@implementation SCAttributedString

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	// init?
	if (self) {
		//
	}
	return self;
}

// create:
SC_IMPLEMENT_CREATE_FUNCTION()
+ (id) create:(NSDictionary *)dict autorelease:(BOOL)autorelease
{
	NSString * string = nil;
	NSDictionary * attributes = nil;
	
	if ([dict isKindOfClass:[NSString class]]) {
		string = (NSString *)dict;
	} else if ([dict isKindOfClass:[NSDictionary class]]) {
		string = [dict objectForKey:@"string"];
		attributes = [dict objectForKey:@"attributes"];
	}
	NSAssert([string isKindOfClass:[NSString class]], @"error: %@", dict);
	
	string = SCLocalizedString(string, nil);
	
	NSAttributedString * as = nil;
	if (attributes) {
		as = [[NSAttributedString alloc] initWithString:string attributes:attributes];
	} else {
		as = [[NSAttributedString alloc] initWithString:string];
	}
	
	if (autorelease) {
		return [as autorelease];
	} else {
		return as;
	}
}

@end
