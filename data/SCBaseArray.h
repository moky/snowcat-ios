//
//  SCBaseArray.h
//  SnowCat
//
//  Created by Moky on 15-5-8.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "SCBaseType.h"

typedef struct {
	unsigned long count;
	unsigned long maxCount;
	
	unsigned long itemSize;
	SCBaseType * items;
	
	// functions
	SCBaseTypeAssignFunction  fnAssign;
	SCBaseTypeCompareFunction fnCompare;
	// blocks
	SCBaseTypeAssignBlock  bkAssign;
	SCBaseTypeCompareBlock bkCompare;
} SCBaseArray;


SCBaseArray * SCBaseArrayCreate(unsigned long itemSize, unsigned long capacity);
void SCBaseArrayDestroy(SCBaseArray * array);

SCBaseType * SCBaseArrayItemAt(const SCBaseArray * array, unsigned long index);

void SCBaseArrayAdd(SCBaseArray * array, const SCBaseType * item);
void SCBaseArrayInsert(SCBaseArray * array, const SCBaseType * item, unsigned long index);
void SCBaseArrayRemove(SCBaseArray * array, unsigned long index);

void SCBaseArraySort(SCBaseArray * array);
void SCBaseArraySortInsert(SCBaseArray * array, const SCBaseType * item);
