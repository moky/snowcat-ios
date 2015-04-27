//
//  fsm_protocol.h
//  FiniteStateMachine
//
//  Created by Moky on 14-12-12.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#ifndef __fsm_protocol__
#define __fsm_protocol__

#define FSMBool  int

#define FSMTrue  1
#define FSMFalse 0

#define FSMNotFound 0xffffffff

#define FSM_MAX_NAME_LENGTH 32

struct FSMMachine;
struct FSMState;
struct FSMTransition;

typedef void    (*fsm_machine_enter_state)(const struct FSMMachine * m, const struct FSMState * s);
typedef void    (*fsm_machine_exit_state) (const struct FSMMachine * m, const struct FSMState * s);
typedef FSMBool (*fsm_transition_evaluate)(const struct FSMMachine * m, const struct FSMState * s, const struct FSMTransition * t);

//
// chain table
//
typedef struct FSMChainTable {
	void * element;
	struct FSMChainTable * next;
} FSMChainTabel;

//
// machine
//
typedef struct FSMMachine {
	// states
	FSMChainTabel * states;             // finite array for states
	unsigned int current;          // index of current state
	// functions
	fsm_machine_enter_state enter; // enter a state
	fsm_machine_exit_state  exit;  // exit a state
	
	void * object; // delegate for machine
} FSMMachine;

//
// state
//
typedef struct FSMState {
	char name[FSM_MAX_NAME_LENGTH]; // name of state
	FSMChainTabel * transitions;    // transitions of state
	
	void * object; // delegate for state
} FSMState;

//
// transition
//
typedef struct FSMTransition {
	char target[FSM_MAX_NAME_LENGTH]; // name of target state
	fsm_transition_evaluate evaluate; // evaluate function
	
	void * object; // delegate for transition
} FSMTransition;

#endif
