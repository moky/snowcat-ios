//
//  SCFSMSequence.m
//  SnowCat
//
//  Created by Moky on 14-12-14.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCFSMSequence.h"

@interface SCFSMSequence ()

@property(nonatomic, retain) NSMutableArray * transitions;

@end

@implementation SCFSMSequence

@synthesize transitions = _transitions;

- (void) dealloc
{
	[_transitions release];
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		[_transitions release];
		_transitions = [[NSMutableArray alloc] initWithCapacity:4];
	}
	return self;
}

- (instancetype) initWithTargetStateName:(NSString *)name transitions:(SCFSMTransition *)first, ... NS_REQUIRES_NIL_TERMINATION
{
	self = [self initWithTargetStateName:name];
	if (self) {
		va_list args;
		va_start(args, first);
		SCFSMTransition * trans = first;
		while (trans) {
			NSAssert([trans isKindOfClass:[SCFSMTransition class]], @"error transition: %@", trans);
			if (trans) {
				[_transitions addObject:trans];
			}
			trans = va_arg(args, id);
		}
		va_end(args);
	}
	return self;
}

- (BOOL) evaluate:(SCFSMMachine *)machine
{
	NSEnumerator * enumerator = [_transitions objectEnumerator];
	SCFSMTransition * trans;
	while (trans = [enumerator nextObject]) {
		if (![trans evaluate:machine]) {
			return NO;
		}
	}
	return YES;
}

@end
