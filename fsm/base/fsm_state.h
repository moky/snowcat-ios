//
//  fsm_state.h
//  FiniteStateMachine
//
//  Created by Moky on 14-12-13.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#ifndef __fsm_state__
#define __fsm_state__

#include "fsm_protocol.h"

FSMState * fsm_state_create(const char * name);
void fsm_state_destroy(FSMState * s);

void fsm_state_set_name(FSMState * s, const char * name);
void fsm_state_add_transition(FSMState * s, const FSMTransition * t);

void fsm_state_tick(FSMMachine * m, const FSMState * s);

#endif /* defined(__fsm_state__) */
