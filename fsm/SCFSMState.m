//
//  SCFSMState.m
//  SnowCat
//
//  Created by Moky on 14-12-13.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "fsm_state.h"

#import "SCFSMMachine.h"
#import "SCFSMTransition.h"
#import "SCFSMState.h"

extern FSMTransition * FSMTransitionIn(const SCFSMTransition * transition);

@interface SCFSMState ()

@property(nonatomic, readwrite) FSMState * innerState;

@property(nonatomic, retain) NSString * name;
@property(nonatomic, retain) NSMutableArray * transitions;

@end

@implementation SCFSMState

@synthesize innerState = _innerState;

@synthesize name = _name;
@synthesize transitions = _transitions;

- (void) dealloc
{
	[_name release];
	[_transitions release];
	
	if (_innerState) {
		fsm_state_destroy(_innerState);
	}
	
	[super dealloc];
}

+ (instancetype) allocWithZone:(struct _NSZone *)zone
{
	id object = [super allocWithZone:zone];
	FSMState * s = fsm_state_create(NULL);
	if (s) {
		s->object = object;
	}
	[object setInnerState:s];
	return object;
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		[_name release];
		_name = nil;
		
		[_transitions release];
		_transitions = [[NSMutableArray alloc] initWithCapacity:4];
	}
	return self;
}

- (instancetype) initWithName:(NSString *)name
{
	self = [self init];
	if (self) {
		const char * str = [name UTF8String];
		if (str) {
			fsm_state_set_name(_innerState, str);
		}
		
		self.name = name;
	}
	return self;
}

- (void) addTransition:(SCFSMTransition *)transition
{
	NSAssert([transition isKindOfClass:[SCFSMTransition class]], @"error transition: %@", transition);
	if (!transition) {
		return;
	}
	
	fsm_state_add_transition(_innerState, FSMTransitionIn(transition));
	[_transitions addObject:transition];
}

- (void) onEnter:(SCFSMMachine *)machine
{
	NSLog(@"[FSM] state name: %@, machine: %@", _name, machine);
}

- (void) onExit:(SCFSMMachine *)machine
{
	NSLog(@"[FSM] state name: %@, machine: %@", _name, machine);
}

- (void) onPause:(SCFSMMachine *)machine
{
	NSLog(@"[FSM] state name: %@, machine: %@", _name, machine);
}

- (void) onResume:(SCFSMMachine *)machine
{
	NSLog(@"[FSM] state name: %@, machine: %@", _name, machine);
}

@end

FSMState * FSMStateIn(const SCFSMState * state)
{
	return [state innerState];
}
