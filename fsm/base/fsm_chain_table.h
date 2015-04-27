//
//  fsm_chain_table.h
//  FiniteStateMachine
//
//  Created by Moky on 14-12-13.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#ifndef __fsm_chain_table__
#define __fsm_chain_table__

#include "fsm_protocol.h"

void fsm_chain_destroy(FSMChainTabel * head);

void fsm_chain_add(FSMChainTabel ** head, void * element);
void * fsm_chain_get(const FSMChainTabel * head, unsigned int index);

#endif /* defined(__fsm_chain_table__) */
