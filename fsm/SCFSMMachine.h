//
//  SCFSMMachine.h
//  SnowCat
//
//  Created by Moky on 14-12-13.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCFSMMachine;
@class SCFSMState;

@protocol SCFSMDelegate <NSObject>

@required
- (void) machine:(SCFSMMachine *)machine enterState:(SCFSMState *)state;
- (void) machine:(SCFSMMachine *)machine exitState:(SCFSMState *)state;

@optional
- (void) machine:(SCFSMMachine *)machine pauseState:(SCFSMState *)state;
- (void) machine:(SCFSMMachine *)machine resumeState:(SCFSMState *)state;

@end

@interface SCFSMMachine : NSObject

@property(nonatomic, assign) id<SCFSMDelegate> delegate;

@property(nonatomic, retain) NSString * defaultStateName; // default is "default"
@property(nonatomic, readonly) SCFSMState * currentState;

- (void) addState:(SCFSMState *)state; // add state with transition(s)

- (void) start;  // start machine from default state
- (void) stop;   // stop machine and set current state to nil

- (void) pause;  // pause machine, current state not change
- (void) resume; // resume machine with current state

//@protected:
- (void) tick;

@end
