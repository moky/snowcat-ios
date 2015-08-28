//
//  scSlanissueToolkit.h
//  SnowCat
//
//  Created by Moky on 15-8-28.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#ifndef SnowCat_scSlanissueToolkit_h
#define SnowCat_scSlanissueToolkit_h

#import "SlanissueToolkit.h"

#define SCLog                            S9Log

#define SC_IMPLEMENT_SINGLETON_FUNCTIONS S9_IMPLEMENT_SINGLETON_FUNCTIONS

#define SC_SWITCH_BEGIN                  S9_SWITCH_BEGIN
#define SC_SWITCH_CASE                   S9_SWITCH_CASE
#define SC_SWITCH_DEFAULT                S9_SWITCH_DEFAULT
#define SC_SWITCH_END                    S9_SWITCH_END

#define SC_FOR_EACH                      S9_FOR_EACH
#define SC_FOR_EACH_REVERSE              S9_FOR_EACH_REVERSE
#define SC_FOR_EACH_SAFE                 S9_FOR_EACH_SAFE
#define SC_FOR_EACH_REVERSE_SAFE         S9_FOR_EACH_REVERSE_SAFE
#define SC_FOR_EACH_KEY_VALUE            S9_FOR_EACH_KEY_VALUE


#define SCArrayObjectAtIndex             S9ArrayObjectAtIndex
#define SCArrayAddObject                 S9ArrayAddObject
#define SCArrayInsertObjectAtIndex       S9ArrayInsertObjectAtIndex
#define SCArrayRemoveObjectAtIndex       S9ArrayRemoveObjectAtIndex
#define SCArrayReplaceObjectAtIndex      S9ArrayReplaceObjectAtIndex
#define SCArrayRemoveObject              S9ArrayRemoveObject


//
//  Memory Cache
//
#define SCMemoryCache                    S9MemoryCache

//
//  Memory Object File
//
#define SCMOFData                        MOFObject
#define SCMOFReader                      MOFReader
#define SCMOFTransformer                 MOFTransformer


//
//  base type
//
typedef ds_type          SCBaseType;

typedef ds_assign_func   SCBaseTypeAssignFunction;
typedef ds_erase_func    SCBaseTypeEraseFunction;
typedef ds_compare_func  SCBaseTypeCompareFunction;

typedef ds_assign_block  SCBaseTypeAssignBlock;
typedef ds_erase_block   SCBaseTypeEraseBlock;
typedef ds_compare_block SCBaseTypeCompareBlock;

//
//  base array
//
typedef ds_array              SCBaseArray;

#define SCBaseArrayCreate     ds_array_create
#define SCBaseArrayDestroy    ds_array_destroy

#define SCBaseArrayItemAt     ds_array_at

#define SCBaseArrayAdd        ds_array_add
#define SCBaseArrayInsert     ds_array_insert
#define SCBaseArrayRemove     ds_array_remove

#define SCBaseArraySort       ds_array_sort
#define SCBaseArraySortInsert ds_array_sort_insert

#define SCBaseArrayCopy       ds_array_copy

//
//  base stack
//
typedef ds_stack              SCBaseStack;

#define SCBaseStackCreate     ds_stack_create
#define SCBaseStackDestroy    ds_stack_destroy

#define SCBaseStackPush       ds_stack_push

#define SCBaseStackPop        ds_stack_pop
#define SCBaseStackTop        ds_stack_top

#define SCBaseStackCopy       ds_stack_copy

//
//  base queue
//
typedef ds_queue              SCBaseQueue;

#define SCBaseQueueCreate     ds_queue_create
#define SCBaseQueueDestroy    ds_queue_destroy

#define SCBaseQueueLength     ds_queue_length

#define SCBaseQueueEnqueue    ds_queue_enqueue
#define SCBaseQueueDequeue    ds_queue_dequeue

#define SCBaseQueueCopy       ds_queue_copy

//
//  base chain
//
typedef ds_chain_node         SCBaseChainNode;
typedef ds_chain_table        SCBaseChainTable;

#define SCBaseChainCreate     ds_chain_create
#define SCBaseChainDestroy    ds_chain_destroy

#define SCBaseChainInsert     ds_chain_insert

#define SCBaseChainLength     ds_chain_length
#define SCBaseChainItemAt     ds_chain_at
#define SCBaseChainFind       ds_chain_first

#define SCBaseChainRemove     ds_chain_remove

#define SCBaseChainSort       ds_chain_sort
#define SCBaseChainSortInsert ds_chain_sort_insert
#define SCBaseChainReverse    ds_chain_reverse

#define SCBaseChainCopy       ds_chain_copy

#endif
