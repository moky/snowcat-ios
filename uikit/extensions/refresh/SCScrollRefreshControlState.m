//
//  SCScrollRefreshControlState.m
//  SnowCat
//
//  Created by Moky on 15-1-9.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCFSMBlockTransition.h"
#import "SCScrollRefreshControlState.h"

NSString * const kUIScrollRefreshControlStateNameDefault     = @"default";
NSString * const kUIScrollRefreshControlStateNameVisible     = @"visible";
NSString * const kUIScrollRefreshControlStateNameWillRefresh = @"will_refresh";
NSString * const kUIScrollRefreshControlStateNameRefreshing  = @"refreshing";

@implementation SCScrollRefreshControlState

@synthesize state = _state;

- (instancetype) initWithState:(UIScrollRefreshControlState)state
{
	NSString * name = nil;
	switch (state) {
		case UIScrollRefreshControlStateVisible:
			name = kUIScrollRefreshControlStateNameVisible;
			break;
			
		case UIScrollRefreshControlStateWillRefresh:
			name = kUIScrollRefreshControlStateNameWillRefresh;
			break;
			
		case UIScrollRefreshControlStateRefreshing:
			name = kUIScrollRefreshControlStateNameRefreshing;
			break;
			
		default:
			name = kUIScrollRefreshControlStateNameDefault;
			break;
	}
	
	self = [self initWithName:name];
	if (self) {
		_state = state;
	}
	return self;
}

@end

#pragma mark -

@implementation SCScrollRefreshControlStateMachine

@synthesize controlDimension = _controlDimension;
@synthesize controlOffset = _controlOffset;
@synthesize pulling = _pulling;
@synthesize dataLoaded = _dataLoaded;

- (instancetype) init
{
	self = [super init];
	if (self) {
		_controlDimension = 80.0f;
		_controlOffset = 0.0f;
		_pulling = NO;
		_dataLoaded = NO;
	}
	return self;
}

// after read, set it FALSE automactilly
- (BOOL) isDataLoaded
{
	if (_dataLoaded) {
		_dataLoaded = NO;
		return YES;
	} else {
		return NO;
	}
}

- (void) start
{
	self.defaultStateName = kUIScrollRefreshControlStateNameDefault;
	
	[self addState:[self _defaultState]];
	[self addState:[self _visibleState]];
	[self addState:[self _willRefreshState]];
	[self addState:[self _refreshingState]];
	
	[super start];
}

#pragma mark - States

- (SCFSMState *) _defaultState
{
	SCScrollRefreshControlState * state;
	state = [[SCScrollRefreshControlState alloc] initWithState:UIScrollRefreshControlStateDefault];
	
	// transitions
	SCFSMBlockTransition * trans;
	
	// 1. 'default' -> 'visible'
	trans = [SCFSMBlockTransition alloc];
	trans = [trans initWithTargetStateName:kUIScrollRefreshControlStateNameVisible
									 block:^BOOL(SCFSMMachine *machine, SCFSMTransition *transition) {
										 if (![(SCScrollRefreshControlStateMachine *)machine isPulling]) {
											 // if not pulling, don't change
											 return NO;
										 }
										 CGFloat offset = [(SCScrollRefreshControlStateMachine *)machine controlOffset];
										 // if offset is not zero, change
										 return offset > 0.0f;
									 }];
	[state addTransition:trans];
	[trans release];
	
	return [state autorelease];
}

- (SCFSMState *) _visibleState
{
	SCScrollRefreshControlState * state;
	state = [[SCScrollRefreshControlState alloc] initWithState:UIScrollRefreshControlStateVisible];
	
	// transitions
	SCFSMBlockTransition * trans;
	
	// 1. 'visible' -> 'default'
	trans = [SCFSMBlockTransition alloc];
	trans = [trans initWithTargetStateName:kUIScrollRefreshControlStateNameDefault
									 block:^BOOL(SCFSMMachine *machine, SCFSMTransition *transition) {
										 CGFloat offset = [(SCScrollRefreshControlStateMachine *)machine controlOffset];
										 // if offset is zero, change
										 return offset <= 0.0f;
									 }];
	[state addTransition:trans];
	[trans release];
	
	// 2. 'visible' -> 'will_refresh'
	trans = [SCFSMBlockTransition alloc];
	trans = [trans initWithTargetStateName:kUIScrollRefreshControlStateNameWillRefresh
									 block:^BOOL(SCFSMMachine *machine, SCFSMTransition *transition) {
										 if (![(SCScrollRefreshControlStateMachine *)machine isPulling]) {
											 // if not pulling, don't change
											 return NO;
										 }
										 CGFloat offset = [(SCScrollRefreshControlStateMachine *)machine controlOffset];
										 CGFloat dimension = [(SCScrollRefreshControlStateMachine *)machine controlDimension];
										 // if offset is larger than dimension, change
										 return offset > dimension;
									 }];
	[state addTransition:trans];
	[trans release];
	
	return [state autorelease];
}

- (SCFSMState *) _willRefreshState
{
	SCScrollRefreshControlState * state;
	state = [[SCScrollRefreshControlState alloc] initWithState:UIScrollRefreshControlStateWillRefresh];
	
	// transitions
	SCFSMBlockTransition * trans;
	
	// 1. 'will_refresh' -> 'refreshing'
	trans = [SCFSMBlockTransition alloc];
	trans = [trans initWithTargetStateName:kUIScrollRefreshControlStateNameRefreshing
									 block:^BOOL(SCFSMMachine *machine, SCFSMTransition *transition) {
										 if ([(SCScrollRefreshControlStateMachine *)machine isPulling]) {
											 // if pulling, don't change
											 return NO;
										 }
										 // set data not loaded before change
										 [(SCScrollRefreshControlStateMachine *)machine setDataLoaded:NO];
										 return YES;
									 }];
	[state addTransition:trans];
	[trans release];
	
	// 2. 'will_refresh' -> 'visible'
	trans = [SCFSMBlockTransition alloc];
	trans = [trans initWithTargetStateName:kUIScrollRefreshControlStateNameVisible
									 block:^BOOL(SCFSMMachine *machine, SCFSMTransition *transition) {
										 CGFloat offset = [(SCScrollRefreshControlStateMachine *)machine controlOffset];
										 CGFloat dimension = [(SCScrollRefreshControlStateMachine *)machine controlDimension];
										 // if offset is smaller than dimension, change
										 return offset < dimension;
									 }];
	[state addTransition:trans];
	[trans release];
	
	return [state autorelease];
}

- (SCFSMState *) _refreshingState
{
	SCScrollRefreshControlState * state;
	state = [[SCScrollRefreshControlState alloc] initWithState:UIScrollRefreshControlStateRefreshing];
	
	// transitions
	SCFSMBlockTransition * trans;
	
	// 1. 'refreshing' -> 'default'
	trans = [SCFSMBlockTransition alloc];
	trans = [trans initWithTargetStateName:kUIScrollRefreshControlStateNameDefault
									 block:^BOOL(SCFSMMachine *machine, SCFSMTransition *transition) {
										 // if data loaded, change
										 return [(SCScrollRefreshControlStateMachine *)machine isDataLoaded];
									 }];
	[state addTransition:trans];
	[trans release];
	
	return [state autorelease];
}

@end
