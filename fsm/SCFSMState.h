//
//  SCFSMState.h
//  SnowCat
//
//  Created by Moky on 14-12-13.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCFSMMachine;
@class SCFSMTransition;

@interface SCFSMState : NSObject

@property(nonatomic, readonly) NSString * name;

- (instancetype) initWithName:(NSString *)name;

- (void) addTransition:(SCFSMTransition *)transition;

- (void) onEnter:(SCFSMMachine *)machine;
- (void) onExit:(SCFSMMachine *)machine;

- (void) onPause:(SCFSMMachine *)machine;
- (void) onResume:(SCFSMMachine *)machine;

@end
