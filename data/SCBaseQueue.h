//
//  SCBaseQueue.h
//  SnowCat
//
//  Created by Moky on 15-5-9.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "SCBaseType.h"

//
//  Notice:
//      For improving performance, the data maybe saved circularly,
//  so please don't access it as an array.
//
typedef struct {
	unsigned long capacity; // max length of items
	unsigned long itemSize;
	SCBaseType * items;
	
	unsigned long head, tail; // offsets for head/tail pointer
	
	// assign
	SCBaseTypeAssignFunction  fnAssign;
	SCBaseTypeAssignBlock     bkAssign;
} SCBaseQueue;


SCBaseQueue * SCBaseQueueCreate(unsigned long itemSize, unsigned long capacity);
void SCBaseQueueDestroy(SCBaseQueue * queue);

unsigned long SCBaseQueueLength(const SCBaseQueue * queue); // get data count

void SCBaseQueueEnqueue(SCBaseQueue * queue, const SCBaseType * item); // append item to tail of queue
SCBaseType * SCBaseQueueDequeue(SCBaseQueue * queue); // return head item and remove it
