//
//  fsm_chain_table.c
//  FiniteStateMachine
//
//  Created by Moky on 14-12-13.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#include <stdlib.h>
#include <string.h>

#include "fsm_chain_table.h"

void fsm_chain_destroy(FSMChainTable * head)
{
	// 1. destroy the chain table
	FSMChainTable * chain = head;
	FSMChainTable * next;
	while (chain) {
		// 1.1. destroy element (state)
		// ignore the element, because its owner will destroy it.
		chain->element = NULL;
		// 1.2. free current node
		next = chain->next;
		free(chain);
		// 1.3. move to next
		chain = next;
	}
}

void fsm_chain_add(FSMChainTable ** head, void * element)
{
	// create a chain node
	FSMChainTable * chain = (FSMChainTable *)malloc(sizeof(FSMChainTable));
	memset(chain, 0, sizeof(FSMChainTable));
	chain->element = element;
	
	// get tail of the chain table
	FSMChainTable ** tail = head;
	while (*tail) {
		tail = &(*tail)->next;
	}
	*tail = chain;
}

void * fsm_chain_get(const FSMChainTable * head, unsigned int index)
{
	if (index == FSMNotFound) {
		return NULL;
	}
	const FSMChainTable * chain = head;
	for (; chain && index > 0; --index) {
		chain = chain->next;
	}
	return chain ? chain->element : NULL;
}
