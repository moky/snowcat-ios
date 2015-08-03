//
//  fsm_protocol.h
//  FiniteStateMachine
//
//  Created by Moky on 14-12-12.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#ifndef __fsm_protocol__
#define __fsm_protocol__

#define FSMBool  int

#define FSMTrue  1
#define FSMFalse 0

#define FSMNotFound 0xffffffff

#define FSM_MAX_NAME_LENGTH 32

struct _FSMMachine;
struct _FSMState;
struct _FSMTransition;

typedef void    (*fsm_machine_enter_state)(const struct _FSMMachine * m, const struct _FSMState * s);
typedef void    (*fsm_machine_exit_state) (const struct _FSMMachine * m, const struct _FSMState * s);
typedef FSMBool (*fsm_transition_evaluate)(const struct _FSMMachine * m, const struct _FSMState * s, const struct _FSMTransition * t);

//
// chain table
//
typedef struct _FSMChainTable {
	void * element;
	struct _FSMChainTable * next;
} FSMChainTable;

//
// machine
//
typedef struct _FSMMachine {
	// states
	FSMChainTable * states;             // finite array for states
	unsigned int current;          // index of current state
	// functions
	fsm_machine_enter_state enter; // enter a state
	fsm_machine_exit_state  exit;  // exit a state
	
	void * object; // delegate for machine
} FSMMachine;

//
// state
//
typedef struct _FSMState {
	char name[FSM_MAX_NAME_LENGTH]; // name of state
	FSMChainTable * transitions;    // transitions of state
	
	void * object; // delegate for state
} FSMState;

//
// transition
//
typedef struct _FSMTransition {
	char target[FSM_MAX_NAME_LENGTH]; // name of target state
	fsm_transition_evaluate evaluate; // evaluate function
	
	void * object; // delegate for transition
} FSMTransition;

#endif
