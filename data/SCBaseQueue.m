//
//  SCBaseQueue.m
//  SnowCat
//
//  Created by Moky on 15-5-9.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <stdlib.h>
#import <string.h>

#import "SCBaseQueue.h"

SCBaseQueue * SCBaseQueueCreate(unsigned long itemSize, unsigned long capacity)
{
	SCBaseQueue * queue = (SCBaseQueue *)malloc(sizeof(SCBaseQueue));
	memset(queue, 0, sizeof(SCBaseQueue));
	queue->capacity = capacity;
	queue->itemSize = itemSize;
	queue->items = (SCBaseType *)calloc(capacity, itemSize);
	return queue;
}

void SCBaseQueueDestroy(SCBaseQueue * queue)
{
	free(queue->items);
	queue->items = NULL;
	free(queue);
}

static inline void SCBaseQueueExpand(SCBaseQueue * queue)
{
	unsigned long middle = queue->capacity;
	queue->capacity *= 2;
	queue->items = (SCBaseType *)realloc(queue->items, queue->capacity * queue->itemSize);
	
	// move part 2 of items
	if (queue->tail < queue ->head) {
		// cycled queue
		if (queue->tail == 0) {
			// part 2 is empty, move tail pointer
			queue->tail = middle;
		} else {
			// copy the part 2 to new zone(connected to part 1)
			SCBaseType * src = queue->items;
			SCBaseType * dest = queue->items + middle * queue->itemSize;
			memcpy(dest, src, queue->tail * queue->itemSize);
			// move tail pointer
			queue->tail += middle;
		}
	}
}

static inline void SCBaseQueueAssign(const SCBaseQueue * queue, SCBaseType * dest, const SCBaseType * src)
{
	if (queue->fnAssign) {
		queue->fnAssign(dest, src);
	} else if (queue->bkAssign) {
		queue->bkAssign(dest, src);
	} else {
		memcpy(dest, src, queue->itemSize);
	}
}

// get data count
unsigned long SCBaseQueueLength(const SCBaseQueue * queue)
{
	if (queue->tail < queue->head) {
		return queue->capacity - queue->head + queue->tail;
	} else {
		return queue->tail - queue->head;
	}
}

// append item to tail of queue
void SCBaseQueueEnqueue(SCBaseQueue * queue, const SCBaseType * item)
{
	unsigned long count = SCBaseQueueLength(queue);
	if (queue->capacity - count <= 1) {
		// only ONE space left, expand the queue
		SCBaseQueueExpand(queue);
	}
	SCBaseType * ptr = queue->items + queue->tail * queue->itemSize;
	
	// append item to tail
	SCBaseQueueAssign(queue, ptr, item);
	queue->tail += 1;
	
	// circularly
	if (queue->tail >= queue->capacity) {
		queue->tail = 0;
	}
}

// return head item and remove it
SCBaseType * SCBaseQueueDequeue(SCBaseQueue * queue)
{
	if (queue->head == queue->tail) {
		return NULL;
	}
	SCBaseType * ptr = queue->items + queue->head * queue->itemSize;
	
	// remove the head item
	queue->head += 1;
	
	// circularly
	if (queue->head >= queue->capacity) {
		queue->head = 0;
	}
	
	return ptr;
}
