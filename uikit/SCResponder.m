//
//  SCResponder.m
//  SnowCat
//
//  Created by Moky on 14-3-17.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCEventHandler.h"
#import "SCEventDispatcher.h"
#import "SCResponder.h"

@implementation SCResponder

@synthesize scTag = _scTag;

- (void) dealloc
{
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		_scTag = 0;
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	self = [self init];
	if (self) {
		[self buildHandlers:dict];
	}
	return self;
}

// buildHandlers:
SC_UIKIT_IMELEMENT_BUILD_HANDLERS_FUNCTION()

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIResponder *)responder
{
	if (!dict || !responder) {
		SCLog(@"cannot set attributes for responder: %@, dict: %@", responder, dict);
		return NO;
	}
	NSAssert([dict isKindOfClass:[NSDictionary class]], @"parameters error: %@", dict);
	NSAssert([responder isKindOfClass:[UIResponder class]], @"parameters error: %@", responder);
	
	NSString * tag = [dict objectForKey:@"tag"];
	if (tag) {
		if ([responder respondsToSelector:@selector(setScTag:)]) {
			[(id<SCUIKit>)responder setScTag:[tag integerValue]];
		}
	}
	
	// onSet
	id<SCEventDelegate> delegate = [self _getEventDelegate:dict forResponder:responder];
	if (delegate) {
		[delegate doEvent:@"onSet" withResponder:responder];
	}
	
	return YES;
}

+ (id<SCEventDelegate>) _getEventDelegate:(NSDictionary *)dict forResponder:(UIResponder *)responder
{
	id<SCEventDelegate> delegate = [SCEventHandler delegateForResponder:responder];
	if (delegate) {
		return delegate;
	}
	
	// eventHandler
	NSDictionary * eventHandler = [dict objectForKey:@"eventHandler"];
	if (eventHandler) {
		[eventHandler retain];
	} else {
		// get events
		NSDictionary * events = [dict objectForKey:@"events"];
		if (events) {
			NSMutableDictionary * md = [[NSMutableDictionary alloc] initWithCapacity:2];
			[md setObject:events forKey:@"events"];
			
			// get actions
			NSDictionary * actions = [dict objectForKey:@"actions"];
			if (actions) {
				[md setObject:actions forKey:@"actions"];
			}
			
			// get notifications
			NSDictionary * notifications = [dict objectForKey:@"notifications"];
			if (notifications) {
				[md setObject:notifications forKey:@"notifications"];
			}
			
			eventHandler = md;
		}
	}
	
	if (eventHandler) {
		delegate = [SCEventHandler create:eventHandler autorelease:NO];
		NSAssert([delegate conformsToProtocol:@protocol(SCEventDelegate)], @"eventHandler's definition error: %@", eventHandler);
		[SCEventHandler setDelegate:delegate forResponder:responder]; // set event delegate
		[delegate release];
		
		NSArray * notifications = [eventHandler objectForKey:@"notifications"];
		if (notifications) {
			[[SCEventDispatcher getInstance] addEventResponder:responder withEvents:notifications]; // add event observer
		}
	}
	
	[eventHandler release];
	
	return delegate;
}

// onCreate
+ (void) onCreate:(UIResponder *)responder withDictionary:(NSDictionary *)dict
{
	id<SCEventDelegate> delegate = [self _getEventDelegate:dict forResponder:responder];
	if (delegate) {
		[delegate doEvent:@"onCreate" withResponder:responder];
	}
}

// onDestroy
+ (void) onDestroy:(UIResponder *)responder
{
	id<SCEventDelegate> delegate = [SCEventHandler delegateForResponder:responder];
	if (delegate) {
		[delegate doEvent:@"onDestroy" withResponder:responder];
		[SCEventHandler removeDelegateForResponder:responder]; // remove event delegate
		
		[[SCEventDispatcher getInstance] removeEventResponder:responder]; // remove event observer
	}
}

@end
