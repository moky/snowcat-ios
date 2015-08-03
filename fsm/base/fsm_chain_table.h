//
//  fsm_chain_table.h
//  FiniteStateMachine
//
//  Created by Moky on 14-12-13.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#ifndef __fsm_chain_table__
#define __fsm_chain_table__

#include "fsm_protocol.h"

void fsm_chain_destroy(FSMChainTable * head);

void fsm_chain_add(FSMChainTable ** head, void * element);
void * fsm_chain_get(const FSMChainTable * head, unsigned int index);

#endif /* defined(__fsm_chain_table__) */
