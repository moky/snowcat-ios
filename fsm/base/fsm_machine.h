//
//  fsm_machine.h
//  FiniteStateMachine
//
//  Created by Moky on 14-12-12.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#ifndef __fsm_machine__
#define __fsm_machine__

#include "fsm_protocol.h"

FSMMachine * fsm_machine_create();
void fsm_machine_destroy(FSMMachine * m);

void fsm_machine_add_state(FSMMachine * m, const FSMState * s);

const FSMState * fsm_machine_get_state(const FSMMachine * m, unsigned int index);
const FSMState * fsm_machine_get_state_by_name(const FSMMachine * m, const char * name, unsigned int * index);

void fsm_machine_change_state(FSMMachine * m, const char * name);

void fsm_machine_tick(FSMMachine * m);

#endif /* defined(__fsm_machine__) */
