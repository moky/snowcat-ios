//
//  SCFSMMachine.m
//  SnowCat
//
//  Created by Moky on 14-12-13.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "fsm_machine.h"
#import "fsm_state.h"

#import "SCFSMState.h"
#import "SCFSMMachine.h"

extern FSMState * FSMStateIn(const SCFSMState * state);

static void SCFSMMachineEnterState(const struct FSMMachine * m, const struct FSMState * s)
{
	SCFSMMachine * machine = m->object;
	SCFSMState * state = s->object;
	[machine.delegate machine:machine enterState:state]; // call 'enterState:' of delegate
	[state onEnter:machine]; // call 'onEnter:' of state
}

static void SCFSMMachineExitState(const struct FSMMachine * m, const struct FSMState * s)
{
	SCFSMMachine * machine = m->object;
	SCFSMState * state = s->object;
	[machine.delegate machine:machine exitState:state]; // call 'exitState:' of delegate
	[state onExit:machine]; // call 'onExit:' of state
}

typedef NS_ENUM(NSUInteger, SCFSMStatus) {
	SCFSMMachineStatusStop,
	SCFSMMachineStatusRunning,
	SCFSMMachineStatusPaused,
};

@interface SCFSMMachine () {
	
	SCFSMStatus _status;
}

@property(nonatomic, readwrite) FSMMachine * innerMachine;
@property(nonatomic, retain) NSMutableArray * states;

@end

@implementation SCFSMMachine

@synthesize innerMachine = _innerMachine;

@synthesize defaultStateName = _defaultStateName;
@synthesize states = _states;

@synthesize delegate = _delegate;

- (void) dealloc
{
	[_defaultStateName release];
	[_states release];
	
	if (_innerMachine) {
		fsm_machine_destroy(_innerMachine);
	}
	
	[super dealloc];
}

+ (instancetype) allocWithZone:(struct _NSZone *)zone
{
	id object = [super allocWithZone:zone];
	FSMMachine * m = fsm_machine_create();
	if (m) {
		m->enter = SCFSMMachineEnterState;
		m->exit = SCFSMMachineExitState;
		m->object = object;
	}
	[object setInnerMachine:m];
	return object;
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		_status = SCFSMMachineStatusStop;
		
		self.defaultStateName = @"default";
		self.states = [NSMutableArray arrayWithCapacity:8];
		
		self.delegate = nil;
	}
	return self;
}

- (void) addState:(SCFSMState *)state
{
	NSAssert([state isKindOfClass:[SCFSMState class]], @"error state: %@", state);
	if (!state) {
		return;
	}
	
	fsm_machine_add_state(_innerMachine, FSMStateIn(state));
	[_states addObject:state];
}

- (void) changeState:(NSString *)name
{
	fsm_machine_change_state(_innerMachine, [name UTF8String]);
}

- (SCFSMState *) currentState
{
	const FSMState * s = fsm_machine_get_state(_innerMachine, _innerMachine->current);
	NSAssert(s, @"failed to get current state: %d", _innerMachine->current);
	SCFSMState * state = s->object;
	NSAssert([state isKindOfClass:[SCFSMState class]], @"memory error");
	return state;
}

#pragma mark -

- (void) tick
{
	@synchronized(self) {
		fsm_machine_tick(_innerMachine);
	}
}

- (void) start
{
	switch (_status) {
		case SCFSMMachineStatusStop: {
			[self changeState:_defaultStateName];
			_status = SCFSMMachineStatusRunning;
			break;
		}
			
		case SCFSMMachineStatusRunning: {
			// already running
			break;
		}
			
		case SCFSMMachineStatusPaused: {
			[self changeState:_defaultStateName];
			_status = SCFSMMachineStatusRunning;
			break;
		}
			
		default: {
			// unknown status
			break;
		}
	}
}

- (void) stop
{
	switch (_status) {
		case SCFSMMachineStatusStop: {
			// already stop
			break;
		}
			
		case SCFSMMachineStatusRunning: {
			_status = SCFSMMachineStatusStop;
			[self changeState:nil];
			break;
		}
			
		case SCFSMMachineStatusPaused: {
			_status = SCFSMMachineStatusStop;
			[self changeState:nil];
			break;
		}
			
		default: {
			// unknown status
			break;
		}
	}
}

- (void) pause
{
	switch (_status) {
		case SCFSMMachineStatusStop: {
			// error
			break;
		}
			
		case SCFSMMachineStatusRunning: {
			_status = SCFSMMachineStatusPaused;
			
			SCFSMState * state = [self currentState];
			if ([_delegate respondsToSelector:@selector(machine:pauseState:)]) {
				[_delegate machine:self pauseState:state];
			}
			[state onPause:self];
			break;
		}
			
		case SCFSMMachineStatusPaused: {
			// already paused
			break;
		}
			
		default: {
			// unknown status
			break;
		}
	}
}

- (void) resume
{
	switch (_status) {
		case SCFSMMachineStatusStop: {
			// error
			break;
		}
			
		case SCFSMMachineStatusRunning: {
			// not paused
			break;
		}
			
		case SCFSMMachineStatusPaused: {
			_status = SCFSMMachineStatusRunning;
			
			SCFSMState * state = [self currentState];
			if ([_delegate respondsToSelector:@selector(machine:resumeState:)]) {
				[_delegate machine:self resumeState:state];
			}
			[state onResume:self];
			break;
		}
			
		default: {
			// unknown status
			break;
		}
	}
}

@end
