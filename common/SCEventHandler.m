//
//  SCEventHandler.m
//  SnowCat
//
//  Created by Moky on 14-3-23.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCUIKit.h"
#import "SCAction.h"
#import "SCEventHandler.h"

@interface SCEventHandler ()

@property(nonatomic, retain) NSDictionary * events;
@property(nonatomic, retain) NSDictionary * actions;

@end

@implementation SCEventHandler

@synthesize events = _events;
@synthesize actions = _actions;

- (void) dealloc
{
	[_events release];
	[_actions release];
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		self.events = nil;
		self.actions = nil;
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	NSDictionary * events = [dict objectForKey:@"events"];
	NSDictionary * actions = [dict objectForKey:@"actions"];
	
	NSAssert(events && [events isKindOfClass:[NSDictionary class]], @"'events' must be a dictionary: %@", events);
	NSAssert(!actions || [actions isKindOfClass:[NSDictionary class]], @"'actions' must be a dictionary if it exists: %@", actions);
	
	NSAssert([events count] > 0, @"no events, no handler: %@", dict);
	
	self = [self init];
	if (self) {
		self.events = events;
		self.actions = actions;
	}
	return self;
}

// create:
SC_IMPLEMENT_CREATE_FUNCTIONS()

#pragma mark SCEventDelegate

- (BOOL) _runAction:(NSDictionary *)dict withResponder:(id)responder
{
	NSAssert([dict isKindOfClass:[NSDictionary class]], @"action must be a dictionary: %@", dict);
	
	SCAction * action = [SCAction create:dict autorelease:NO];
	NSAssert([action isKindOfClass:[SCAction class]], @"action's definition error: %@", dict);
	BOOL flag = [action startWithResponder:responder];
	[action release];
	
	NSAssert(flag, @"invalid action: %@, responder: %@", dict, responder);
	return flag;
}

- (BOOL) doEvent:(NSString *)eventName withResponder:(id)responder
{
	NSArray * tasks = [_events objectForKey:eventName];
	if (!tasks) {
		return NO;
	}
	NSAssert([tasks isKindOfClass:[NSArray class]], @"tasks defined in event(%@) must be an array: %@", eventName, tasks);
	
	NSUInteger errorCount = 0;
	
	NSString * name;
	id target;
	id<SCEventDelegate> delegate;
	
	NSEnumerator * enumerator = [tasks objectEnumerator];
	NSDictionary * task;
	while (task = [enumerator nextObject]) {
		NSAssert([task isKindOfClass:[NSDictionary class]], @"task must be a dictionary: %@", task);
		
		// task name
		name = [task objectForKey:@"name"];
		// target responder
		target = [SCUIKit getTarget:[task objectForKey:@"target"] responder:responder];
		// delegate
		if ([target conformsToProtocol:@protocol(SCUIKit)]) {
			delegate = [SCEventHandler delegateForResponder:target];
		} else {
			SCLog(@"invalid target: %@, for responder: %@", [task objectForKey:@"target"], responder);
			delegate = self;
		}
		
		// do it
		if ([delegate doEvent:name withResponder:target]) {
			// another event
		} else if ([delegate doAction:name withResponder:target]) {
			// user-defined action
		} else if ([self _runAction:task withResponder:target]) {
			// final action
		} else {
			// error
			++errorCount;
		}
	}
	
	NSAssert(errorCount == 0, @"error count: %u", (unsigned int)errorCount);
	return errorCount == 0;
}

- (BOOL) doAction:(NSString *)actionName withResponder:(id)responder
{
	NSDictionary * action = [_actions objectForKey:actionName];
	if (!action) {
		// no such action
		return NO;
	}
	NSAssert([action isKindOfClass:[NSDictionary class]], @"action(%@) must be a dictionary: %@", actionName, action);
	
	// target responder
	// for simplify reason, plz don't set other target here,
	// it means we prefer that action just call self action
	responder = [SCUIKit getTarget:[action objectForKey:@"target"] responder:responder];
	
	// another user-defined action?
	actionName = [action objectForKey:@"name"];
	if ([self doAction:actionName withResponder:responder]) {
		return YES;
	}
	
	// final action
	return [self _runAction:action withResponder:responder];
}

@end

@implementation SCEventHandler (pool)

static NSMutableDictionary * s_event_handler_pool = nil;

+ (NSMutableDictionary *) _getEventHandlerPool
{
	@synchronized(self) {
		if (!s_event_handler_pool) {
			s_event_handler_pool = [[NSMutableDictionary alloc] initWithCapacity:32];
		}
	}
	return s_event_handler_pool;
}

+ (NSString *) _newKeyForResponder:(id)responder
{
	return [[NSString alloc] initWithFormat:@"%x", (int)responder];
}

+ (void) setDelegate:(id<SCEventDelegate>)delegate forResponder:(id)responder
{
	NSMutableDictionary * pool = [self _getEventHandlerPool];
	
	NSString * key = [self _newKeyForResponder:responder];
	if (delegate) {
		[pool setObject:delegate forKey:key];
	} else {
		[pool removeObjectForKey:key];
	}
	[key release];
}

+ (id<SCEventDelegate>) delegateForResponder:(id)responder
{
	NSMutableDictionary * pool = [self _getEventHandlerPool];
	
	NSString * key = [self _newKeyForResponder:responder];
	id<SCEventDelegate> delegate = [pool objectForKey:key];
	[key release];
	return delegate;
}

+ (void) removeDelegateForResponder:(id)responder
{
	NSMutableDictionary * pool = [self _getEventHandlerPool];
	
	NSString * key = [self _newKeyForResponder:responder];
	[pool removeObjectForKey:key];
	[key release];
}

@end

#pragma mark - Convenient interface

void SCDoEvent(NSString * event, id responder)
{
	id<SCEventDelegate> delegate = [SCEventHandler delegateForResponder:responder];
	if (delegate) {
		[delegate doEvent:event withResponder:responder];
	}
}
