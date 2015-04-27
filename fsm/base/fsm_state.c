//
//  fsm_state.c
//  FiniteStateMachine
//
//  Created by Moky on 14-12-13.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#include <stdlib.h>
#include <string.h>

#include "fsm_chain_table.h"
#include "fsm_machine.h"
#include "fsm_transition.h"
#include "fsm_state.h"

FSMState * fsm_state_create(const char * name)
{
	FSMState * s = (FSMState *)malloc(sizeof(FSMState));
	memset(s, 0, sizeof(FSMState));
	if (name) {
		fsm_state_set_name(s, name);
	}
	return s;
}

void fsm_state_destroy(FSMState * s)
{
	// 1. destroy the chain table for transitions
	fsm_chain_destroy(s->transitions);
//	s->transitions = NULL;
//	s->object = NULL;
	
	// 2. free the state
	free(s);
}

void fsm_state_set_name(FSMState * s, const char * name)
{
	unsigned long len = strlen(name);
	if (len > 0) {
		if (len >= sizeof(s->name)) {
			len = sizeof(s->name) - 1;
		}
		strncpy(s->name, name, len);
	}
}

void fsm_state_add_transition(FSMState * s, const FSMTransition * t)
{
	fsm_chain_add(&s->transitions, (void *)t);
}

void fsm_state_tick(FSMMachine * m, const FSMState * s)
{
	FSMChainTabel * chain = s->transitions;
	FSMTransition * t;
	fsm_transition_evaluate fn;
	while (chain) {
		t = chain->element;
		fn = t->evaluate;
		if (fn && fn(m, s, t) != FSMFalse) {
			fsm_machine_change_state(m, t->target);
			break;
		}
		chain = chain->next;
	}
}
