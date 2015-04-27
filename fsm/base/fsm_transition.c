//
//  fsm_transition.c
//  FiniteStateMachine
//
//  Created by Moky on 14-12-13.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#include <stdlib.h>
#include <string.h>

#include "fsm_transition.h"

FSMTransition * fsm_transition_create(const char * target)
{
	FSMTransition * t = (FSMTransition *)malloc(sizeof(FSMTransition));
	memset(t, 0, sizeof(FSMTransition));
	if (target) {
		fsm_transition_set_target(t, target);
	}
	return t;
}

void fsm_transition_destroy(FSMTransition * t)
{
//	t->evaluate = NULL;
//	t->object = NULL;
	
	free(t);
}

void fsm_transition_set_target(FSMTransition * t, const char * target)
{
	unsigned long len = strlen(target);
	if (len > 0) {
		if (len >= sizeof(t->target)) {
			len = sizeof(t->target) - 1;
		}
		strncpy(t->target, target, len);
	}
}
