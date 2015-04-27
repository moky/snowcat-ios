//
//  SCActionCallFunc.m
//  SnowCat
//
//  Created by Moky on 14-3-25.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCUIKit.h"
#import "SCActionCallFunc.h"

@implementation SCActionCallFunc

- (BOOL) runWithResponder:(UIResponder *)responder
{
	NSString * selector = [_dict objectForKey:@"selector"];
	NSAssert(selector, @"selector cannot be null: %@", _dict);
	
	SEL func = NSSelectorFromString(selector);
	if (![responder respondsToSelector:func]) {
		NSAssert(false, @"failed to call function '%@' of %@, action info: %@", selector, responder, _dict);
		return NO;
	}
	
	NSRange range = [selector rangeOfString:@":"];
	if (range.location == NSNotFound) {
		[responder performSelector:func]; // function with no arguments
		return YES;
	}
	
	NSObject * object = [_dict objectForKey:@"object"];
	
	NSRange range2 = [selector rangeOfString:@":" options:NSBackwardsSearch];
	if (range2.location != range.location) {
		NSObject * object1 = [_dict objectForKey:@"object1"];
		NSObject * object2 = [_dict objectForKey:@"object2"];
		if (!object1) {
			object1 = object;
		}
		[responder performSelector:func withObject:object1 withObject:object2]; // function with 2 arguments
		return YES;
	}
	
	[responder performSelector:func withObject:object]; // function with 1 argument
	return YES;
}

@end
