//
//  SCObject.m
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCNodeFileParser.h"
#import "SCObject.h"

@implementation SCObject

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	self = [self init];
	if (self) {
	}
	return self;
}

// create:
SC_IMPLEMENT_CREATE_FUNCTION()
+ (id) create:(NSDictionary *)dict autorelease:(BOOL)autorelease
{
	NSAssert([dict isKindOfClass:[NSDictionary class]], @"parameters error: %@", dict);
	
	NSString * className = [dict objectForKey:@"Class"];
	if (!className) {
		return nil;
	}
	
	// get class
	Class class = NSClassFromString(className);
	if (!class) {
		className = [[NSString alloc] initWithFormat:@"SC%@", className];
		class = NSClassFromString(className);
		[className release];
	}
	NSAssert(class, @"invalid class: %@", [dict objectForKey:@"Class"]);
	
	// create object
	id<SCObject> object = [class alloc];
	if ([object conformsToProtocol:@protocol(SCObject)]) {
		object = [object initWithDictionary:dict];
	} else if ([object isKindOfClass:[NSObject class]]) {
		object = [(id)object init];
	}
	
	if (object && autorelease) {
		return [object autorelease];
	} else {
		return object;
	}
}

@end
