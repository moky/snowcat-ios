//
//  SCAction.m
//  SnowCat
//
//  Created by Moky on 14-3-24.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCAction.h"

@implementation SCAction

- (void) dealloc
{
	[_dict release];
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		[_dict release];
		_dict = nil;
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	self = [self init];
	if (self) {
		_dict = [dict retain];
	}
	return self;
}

// create:
SC_IMPLEMENT_CREATE_FUNCTION()
+ (id) create:(NSDictionary *)dict autorelease:(BOOL)autorelease
{
	NSAssert([dict isKindOfClass:[NSDictionary class]], @"action info must be a dictionary: %@", dict);
	
	// try as scobject
	SCAction * action = [SCObject create:dict autorelease:autorelease];
	if (action) {
		NSAssert([action isKindOfClass:[SCAction class]], @"invalid action: %@", dict);
		return action;
	}
	
	// try by action name
	NSString * name = [dict objectForKey:@"name"];
	NSAssert([name length] > 0, @"action name cannot be empty: %@", dict);
	name = [[NSString alloc] initWithFormat:@"SCAction%@", name];
	Class class = NSClassFromString(name);
	[name release];
	
	NSAssert(class, @"invalid class: SCAction%@", [dict objectForKey:@"name"]);
	
	// create action
	action = [[class alloc] initWithDictionary:dict];
	NSAssert([action isKindOfClass:[SCAction class]], @"invalid action: %@", dict);
	
	if (autorelease) {
		return [action autorelease];
	} else {
		return action;
	}
}

- (BOOL) runWithResponder:(id)responder
{
	NSAssert(false, @"override me! dict: %@", _dict);
	return NO;
}

- (BOOL) _runWithResponderAndDuration:(id)responder
{
	BOOL flag = NO;
	
	// duration
	id duration = [_dict objectForKey:@"duration"];
	if (duration) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:[duration doubleValue]];
		flag = [self runWithResponder:responder];
		[UIView commitAnimations];
	} else {
		flag = [self runWithResponder:responder];
	}
	
	return flag;
}

- (BOOL) startWithResponder:(id)responder
{
	NSAssert([_dict isKindOfClass:[NSDictionary class]], @"action's definition error: %@, responder: %@", _dict, responder);
	// delay
	id delay = [_dict objectForKey:@"delay"];
	if (delay) {
		NSTimeInterval ti = [delay doubleValue];
		SCLog(@"run action after delay: %f", ti);
		[self performSelector:@selector(_runWithResponderAndDuration:) withObject:responder afterDelay:ti];
		return YES;
	}
	
	// run immediately
	return [self _runWithResponderAndDuration:responder];
}

@end
