//
//  SCFSMTransition.m
//  SnowCat
//
//  Created by Moky on 14-12-13.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "fsm_transition.h"

#import "SCFSMMachine.h"
//#import "SCFSMState.h"
#import "SCFSMTransition.h"

static FSMBool SCFSMTransitionEvaluate(const struct FSMMachine * m, const struct FSMState * s, const struct FSMTransition * t)
{
	SCFSMMachine * machine = m->object;
	//SCFSMState * state = s->object;
	SCFSMTransition * transition = t->object;
	
	return [transition evaluate:machine] ? FSMTrue : FSMFalse;
}

@interface SCFSMTransition ()

@property(nonatomic, readwrite) FSMTransition * innerTransition;

@property(nonatomic, retain) NSString * targetStateName;

@end

@implementation SCFSMTransition

@synthesize innerTransition = _innerTransition;

@synthesize targetStateName = _targetStateName;

- (void) dealloc
{
	[_targetStateName release];
	
	if (_innerTransition) {
		fsm_transition_destroy(_innerTransition);
	}
	
	[super dealloc];
}

+ (instancetype) allocWithZone:(struct _NSZone *)zone
{
	id object = [super allocWithZone:zone];
	FSMTransition * t = fsm_transition_create(NULL);
	if (t) {
		t->evaluate = SCFSMTransitionEvaluate;
		t->object = object;
	}
	[object setInnerTransition:t];
	return object;
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		[_targetStateName release];
		_targetStateName = nil;
	}
	return self;
}

- (instancetype) initWithTargetStateName:(NSString *)name
{
	self = [self init];
	if (self) {
		const char * str = [name UTF8String];
		if (str) {
			fsm_transition_set_target(_innerTransition, str);
		}
		
		self.targetStateName = name;
	}
	return self;
}

- (BOOL) evaluate:(SCFSMMachine *)machine
{
	NSAssert(false, @"override me!");
	return YES;
}

@end

FSMTransition * FSMTransitionIn(const SCFSMTransition * transition)
{
	return [transition innerTransition];
}
