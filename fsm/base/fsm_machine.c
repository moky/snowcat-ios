//
//  fsm_machine.c
//  FiniteStateMachine
//
//  Created by Moky on 14-12-12.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#include <stdlib.h>
#include <string.h>

#include "fsm_chain_table.h"
#include "fsm_state.h"
#include "fsm_machine.h"

FSMMachine * fsm_machine_create()
{
	FSMMachine * m = (FSMMachine *)malloc(sizeof(FSMMachine));
	memset(m, 0, sizeof(FSMMachine));
	m->current = FSMNotFound;
	return m;
}

void fsm_machine_destroy(FSMMachine * m)
{
	// 1. destroy the chain table for states
	fsm_chain_destroy(m->states);
//	m->states = NULL;
//	m->enter = NULL;
//	m->exit = NULL;
//	m->object = NULL;
	
	// 2. free the machine
	free(m);
}

void fsm_machine_add_state(FSMMachine * m, const FSMState * s)
{
	fsm_chain_add(&m->states, (void *)s);
}

const FSMState * fsm_machine_get_state(const FSMMachine * m, unsigned int index)
{
	const FSMState * s = NULL;
	const FSMChainTabel * chain = m->states;
	unsigned int i;
	for (i = 0; chain; ++i, chain = chain->next) {
		if (i == index) {
			s = chain->element;
			break;
		}
	}
	return s;
}

const FSMState * fsm_machine_get_state_by_name(const FSMMachine * m, const char * name, unsigned int * index)
{
	const FSMState * s = NULL;
	*index = FSMNotFound;
	if (name) {
		const FSMChainTabel * chain = m->states;
		unsigned int i;
		for (i = 0; chain; ++i, chain = chain->next) {
			s = chain->element;
			if (strcmp(s->name, name) == 0) {
				*index = i;
				break;
			}
			s = NULL;
		}
	}
	return s;
}

void fsm_machine_change_state(FSMMachine * m, const char * name)
{
	// get index for new state with name
	unsigned int index = FSMNotFound;
	const FSMState * s = fsm_machine_get_state_by_name(m, name, &index);
	
	if (index == m->current) {
		// state not change
		return;
	}
	
	const FSMState * o = fsm_chain_get(m->states, m->current);
	if (o && m->exit) m->exit(m, o); // exit the old state
	
	m->current = index;
	if (s && m->enter) m->enter(m, s); // enter the new state
}

void fsm_machine_tick(FSMMachine * m)
{
	const FSMState * s = fsm_chain_get(m->states, m->current);
	if (m && s) {
		fsm_state_tick(m, s);
	}
}
