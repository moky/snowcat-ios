//
//  SCFiniteStateMachine.h
//  SnowCat
//
//  Created by Moky on 15-1-21.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

/**
 *
 *  Description:
 *
 *      Finite State Machine, which has finitely several states in it, only one
 *  of them will be set as the current state in the same time.
 *
 *      When the machine started up, we should build up all states and their own
 *  transitions for changing from self to another, adding all states with their
 *  transitions one by one into the machine. After that, the machine will run
 *  into the default state automatically.
 *
 *      In each time period, the function "-tick" of machine will be call, this
 *  function will enumerate all transtions of the current state, try to evaluate
 *  each of them, while one transtion's function "-evaluate:" return YES, then
 *  the machine will change to the new state by the transtion's target name.
 *
 *      When the machine stopped, it will run out from the current state, and
 *  here we should remove all states.
 *
 *
 *      If current state changed, the delegate's function "-machine:exitState:"
 *  will be call with the old state, after that, "-machine:enterState:" will be
 *  call with the new state. This mechanism can let you do something in the two
 *  opportune moments.
 *
 *
 *  Dependences:
 *
 *      <Foundation.framework>
 *
 */

#import "SCFSMProtocol.h"
#import "SCFSMSequence.h"
#import "SCFSMPropertyMachine.h"
#import "SCFSMPropertyTransition.h"

NSString * fsmVersion(void);
