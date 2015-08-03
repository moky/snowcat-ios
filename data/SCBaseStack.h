//
//  SCBaseStack.h
//  SnowCat
//
//  Created by Moky on 15-5-9.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "SCBaseType.h"

typedef struct _SCBaseStack {
	unsigned long capacity; // max length of items
	unsigned long itemSize;
	SCBaseType * items;
	
	unsigned long count;
	
	// assign
	SCBaseTypeAssignFunction  fnAssign;
	SCBaseTypeAssignBlock     bkAssign;
} SCBaseStack;


SCBaseStack * SCBaseStackCreate(unsigned long itemSize, unsigned long capacity);
void SCBaseStackDestroy(SCBaseStack * stack);

void SCBaseStackPush(SCBaseStack * stack, const SCBaseType * item); // push item to top of stack

SCBaseType * SCBaseStackPop(SCBaseStack * stack); // return top item and remove it
SCBaseType * SCBaseStackTop(const SCBaseStack * stack); // return top item
