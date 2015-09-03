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

#define SCLog(...)                                        S9Log(__VA_ARGS__)

#define SC_IMPLEMENT_SINGLETON_FUNCTIONS(getInstance)     S9_IMPLEMENT_SINGLETON_FUNCTIONS(getInstance)

// switch
#define SC_SWITCH_BEGIN(var)                              S9_SWITCH_BEGIN(var)
#define SC_SWITCH_CASE(var, value)                        S9_SWITCH_CASE((var), (value))
#define SC_SWITCH_DEFAULT                                 S9_SWITCH_DEFAULT
#define SC_SWITCH_END                                     S9_SWITCH_END

// foreach
#define SC_FOR_EACH(item, array)                          S9_FOR_EACH((array), (item))
#define SC_FOR_EACH_REVERSE(item, array)                  S9_FOR_EACH_REVERSE((array), (item))
#define SC_FOR_EACH_SAFE(item, array)                     S9_FOR_EACH_SAFE((array), (item))
#define SC_FOR_EACH_REVERSE_SAFE(item, array)             S9_FOR_EACH_REVERSE_SAFE((array), (item))
#define SC_FOR_EACH_KEY_VALUE(key, value, dict)           S9_FOR_EACH_KEY_VALUE((dict), (key), (value))

// safe accessing
#define SCArrayObjectAtIndex(array, index)                S9ArrayObjectAtIndex((array), (index))
#define SCArrayAddObject(array, object)                   S9ArrayAddObject((array), (object))
#define SCArrayInsertObjectAtIndex(array, object, index)  S9ArrayInsertObjectAtIndex((array), (object), (index))
#define SCArrayRemoveObjectAtIndex(array, index)          S9ArrayRemoveObjectAtIndex((array), (index))
#define SCArrayReplaceObjectAtIndex(array, object, index) S9ArrayReplaceObjectAtIndex((array), (object), (index))
#define SCArrayRemoveObject(array, object)                S9ArrayRemoveObject((array), (object))
#define SCDictionarySetObjectForKey(dict, object, key)    S9DictionarySetObjectForKey((dict), (object), (key))


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
typedef ds_array SCBaseArray;

#define SCBaseArrayCreate(item_size, capacity) ds_array_create((item_size), (capacity))
#define SCBaseArrayDestroy(array)              ds_array_destroy(array)

#define SCBaseArrayItemAt(array, index)        ds_array_at((array), (index))

#define SCBaseArrayAdd(array, item)            ds_array_add((array), (item))
#define SCBaseArrayInsert(array, item, index)  ds_array_insert((array), (item), (index))
#define SCBaseArrayRemove(array, index)        ds_array_remove((array), (index))

#define SCBaseArraySort(array)                 ds_array_sort(array)
#define SCBaseArraySortInsert(array, item)     ds_array_sort_insert((array), (item))

#define SCBaseArrayCopy(array)                 ds_array_copy(array)

//
//  base stack
//
typedef ds_stack SCBaseStack;

#define SCBaseStackCreate(item_size, capacity) ds_stack_create((item_size), (capacity))
#define SCBaseStackDestroy(stack)              ds_stack_destroy(stack)

#define SCBaseStackPush(stack, item)           ds_stack_push((stack), (item))

#define SCBaseStackPop(stack)                  ds_stack_pop(stack)
#define SCBaseStackTop(stack)                  ds_stack_top(stack)

#define SCBaseStackCopy(stack)                 ds_stack_copy(stack)

//
//  base queue
//
typedef ds_queue SCBaseQueue;

#define SCBaseQueueCreate(item_size, capacity) ds_queue_create((item_size), (capacity))
#define SCBaseQueueDestroy(queue)              ds_queue_destroy(queue)

#define SCBaseQueueLength(queue)               ds_queue_length(queue)

#define SCBaseQueueEnqueue(queue, item)        ds_queue_enqueue((queue), (item))
#define SCBaseQueueDequeue(queue)              ds_queue_dequeue(queue)

#define SCBaseQueueCopy(queue)                 ds_queue_copy(queue)

//
//  base chain
//
typedef ds_chain_node  SCBaseChainNode;
typedef ds_chain_table SCBaseChainTable;

#define SCBaseChainCreate(data_size)           ds_chain_create(data_size)
#define SCBaseChainDestroy(chain)              ds_chain_destroy(chain)

#define SCBaseChainInsert(chain, data, node)   ds_chain_insert((chain), (data), (node))

#define SCBaseChainLength(chain)               ds_chain_length(chain)
#define SCBaseChainItemAt(chain, index)        ds_chain_at((chain), (index))
#define SCBaseChainFind(chain, data)           ds_chain_first((chain), (data))

#define SCBaseChainRemove(chain, node)         ds_chain_remove((chain), (node))

#define SCBaseChainSort(chain)                 ds_chain_sort(chain)
#define SCBaseChainSortInsert(chain, data)     ds_chain_sort_insert((chain), (data))
#define SCBaseChainReverse(chain)              ds_chain_reverse(chain)

#define SCBaseChainCopy(chain)                 ds_chain_copy(chain)

#endif
