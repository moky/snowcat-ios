//
//  SCBaseStack.m
//  SnowCat
//
//  Created by Moky on 15-5-9.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <stdlib.h>
#import <string.h>

#import "SCBaseStack.h"

SCBaseStack * SCBaseStackCreate(unsigned long itemSize, unsigned long capacity)
{
	SCBaseStack * stack = (SCBaseStack *)malloc(sizeof(SCBaseStack));
	memset(stack, 0, sizeof(SCBaseStack));
	stack->capacity = capacity;
	stack->itemSize = itemSize;
	stack->items = (SCBaseType *)calloc(capacity, itemSize);
	return stack;
}

void SCBaseStackDestroy(SCBaseStack * stack)
{
	free(stack->items);
	stack->items = NULL;
	free(stack);
}

static inline void SCBaseStackExpand(SCBaseStack * stack)
{
	stack->capacity *= 2;
	stack->items = (SCBaseType *)realloc(stack->items, stack->capacity * stack->itemSize);
}

static inline void SCBaseStackAssign(const SCBaseStack * stack, SCBaseType * dest, const SCBaseType * src)
{
	if (stack->fnAssign) {
		stack->fnAssign(dest, src);
	} else if (stack->bkAssign) {
		stack->bkAssign(dest, src);
	} else {
		memcpy(dest, src, stack->itemSize);
	}
}

void SCBaseStackPush(SCBaseStack * stack, const SCBaseType * item)
{
	if (stack->count >= stack->capacity) {
		SCBaseStackExpand(stack);
	}
	SCBaseType * ptr = stack->items + stack->count * stack->itemSize;
	
	// append item to top
	SCBaseStackAssign(stack, ptr, item);
	stack->count += 1;
}

SCBaseType * SCBaseStackPop(SCBaseStack * stack)
{
	if (stack->count == 0) {
		return NULL;
	}
	
	// remove the top item
	stack->count -= 1;
	
	// return the top item
	return stack->items + stack->count * stack->itemSize;
}

SCBaseType * SCBaseStackTop(const SCBaseStack * stack)
{
	if (stack->count == 0) {
		return NULL;
	}
	
	// return the top item
	return stack->items + (stack->count - 1) * stack->itemSize;
}
