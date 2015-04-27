//
//  SCEventDispatcher.m
//  SnowCat
//
//  Created by Moky on 14-3-25.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCEventHandler.h"
#import "SCEventDispatcher.h"

@interface SCEventResponder : NSObject 

@property(nonatomic, assign) id responder; // don't retain the responder

@end

@implementation SCEventResponder

@synthesize responder;

@end

#pragma mark -

@interface SCEventDispatcher ()

@property(nonatomic, assign) NSNotificationCenter * defaultCenter;
@property(nonatomic, retain) NSMutableDictionary * responderPool;

@end

@implementation SCEventDispatcher

@synthesize defaultCenter = _defaultCenter;
@synthesize responderPool = _responderPool;

- (void) dealloc
{
	[_responderPool release];
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		self.defaultCenter = [NSNotificationCenter defaultCenter];
		self.responderPool = [NSMutableDictionary dictionaryWithCapacity:16];
	}
	return self;
}

// singleton implementations
SC_IMPLEMENT_SINGLETON_FUNCTIONS(getInstance)

- (void) addEventResponder:(id)responder withEventName:(NSString *)eventName
{
	NSAssert(responder, @"responder cannot be nil");
	NSAssert([eventName isKindOfClass:[NSString class]], @"event name error: %@", eventName);
	@synchronized(self) {
		NSMutableArray * mArray = [_responderPool objectForKey:eventName];
		if (!mArray) {
			// new event name, add observer first
			[_defaultCenter addObserver:self selector:@selector(receiveEventNotification:) name:eventName object:nil];
			// new array
			mArray = [[NSMutableArray alloc] initWithCapacity:1];
			[_responderPool setObject:mArray forKey:eventName];
			[mArray release];
		} else {
			// exists event name, just add responder
			NSEnumerator * enumerator = [mArray objectEnumerator];
			SCEventResponder * er;
			while (er = [enumerator nextObject]) {
				if (er.responder == responder) {
					SCLog(@"duplicated responder: %@, event: %@", responder, eventName);
					return;
				}
			}
		}
		// add responder
		SCEventResponder * er = [[SCEventResponder alloc] init];
		er.responder = responder;
		[mArray addObject:er];
		[er release];
	}
}

- (void) addEventResponder:(id)responder withEvents:(NSArray *)events
{
	NSAssert(responder, @"responder cannot be nil");
	NSAssert([events isKindOfClass:[NSArray class]], @"events error: %@", events);
	NSEnumerator * enumerator = [events objectEnumerator];
	NSString * name;
	while (name = [enumerator nextObject]) {
		NSAssert([name isKindOfClass:[NSString class]], @"event name error: %@", name);
		[self addEventResponder:responder withEventName:name];
	}
}

- (void) removeEventResponder:(id)responder
{
	NSAssert(responder, @"responder cannot be nil");
	@synchronized(self) {
		NSMutableArray * eventsToRemove = [[NSMutableArray alloc] initWithCapacity:4];
		
		NSEnumerator * keyEnumerator = [_responderPool keyEnumerator];
		NSString * eventName;
		NSMutableArray * mArray;
		while (eventName = [keyEnumerator nextObject]) {
			mArray = [_responderPool objectForKey:eventName];
			NSAssert([mArray isKindOfClass:[NSMutableArray class]], @"event responder list error: %@", mArray);
			NSMutableArray * respondersToRemove = [[NSMutableArray alloc] initWithCapacity:2];
			
			// get responders
			NSEnumerator * enumerator = [mArray objectEnumerator];
			SCEventResponder * er;
			while (er = [enumerator nextObject]) {
				if (er.responder == responder) {
					er.responder = nil;
					[respondersToRemove addObject:er];
				}
			}
			
			// remove responders
			enumerator = [respondersToRemove objectEnumerator];
			while (er = [enumerator nextObject]) {
				[mArray removeObject:er];
				if ([mArray count] == 0) {
					// the array is empty now, remove it
					[eventsToRemove addObject:eventName];
					// no responder left, remove observer now
					[_defaultCenter removeObserver:self name:eventName object:nil];
				}
			}
			
			[respondersToRemove release];
		}
		
		// remove empty events
		[_responderPool removeObjectsForKeys:eventsToRemove];
		[eventsToRemove release];
	}
}

- (void) receiveEventNotification:(NSNotification *)notification
{
	NSString * eventName = [notification name];
//	id sender = [notification object];
//	NSDictionary * userInfo = [notification userInfo];
	
	@synchronized(self) {
		NSMutableArray * mArray = [_responderPool objectForKey:eventName];
		NSEnumerator * enumerator = [mArray objectEnumerator];
		id<SCEventDelegate> delegate;
		SCEventResponder * er;
		while (er = [enumerator nextObject]) {
			delegate = [SCEventHandler delegateForResponder:er.responder];
			NSAssert(delegate, @"no delegate matches the responder: %@", er.responder);
			[delegate doEvent:eventName withResponder:er.responder];
		}
	}
}

@end
