//
//  fsm_transition.h
//  FiniteStateMachine
//
//  Created by Moky on 14-12-13.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#ifndef __fsm_transition__
#define __fsm_transition__

#include "fsm_protocol.h"

FSMTransition * fsm_transition_create(const char * target);
void fsm_transition_destroy(FSMTransition * t);

void fsm_transition_set_target(FSMTransition * t, const char * target);

#endif /* defined(__fsm_transition__) */
