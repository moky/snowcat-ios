//
//  SCBaseArray.m
//  SnowCat
//
//  Created by Moky on 15-5-8.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "SCBaseArray.h"

SCBaseArray * SCBaseArrayCreate(NSUInteger itemSize, NSUInteger capacity)
{
	SCBaseArray * array = (SCBaseArray *)malloc(sizeof(SCBaseArray));
	memset(array, 0, sizeof(SCBaseArray));
	array->maxCount = capacity;
	array->items = (SCBaseType *)calloc(capacity, itemSize);
	return array;
}

void SCBaseArrayExpand(SCBaseArray * array)
{
	array->maxCount *= 2;
	array->items = (SCBaseType *)realloc(array->items, array->maxCount);
}

void SCBaseArrayDestroy(SCBaseArray * array)
{
	free(array->items);
	array->items = NULL;
	free(array);
}

void SCBaseArrayAdd(SCBaseArray * array, const SCBaseType * item)
{
	NSAssert(array->count <= array->maxCount, @"error");
	NSAssert(array->assign != NULL, @"error");
	if (array->count >= array->maxCount) {
		SCBaseArrayExpand(array);
	}
	SCBaseType * ptr = array->items + array->itemSize * array->count;
	array->assign(ptr, item);
	array->count += 1;
}

void SCBaseArrayInsert(SCBaseArray * array, const SCBaseType * item, NSUInteger index)
{
	NSAssert(array->count <= array->maxCount, @"error");
	NSAssert(array->assign != NULL, @"error");
	NSAssert(index <= array->count, @"index: %u", (unsigned int)index);
	if (index >= array->count) {
		SCBaseArrayAdd(array, item);
		return;
	}
	if (array->count >= array->maxCount) {
		SCBaseArrayExpand(array);
	}
	
	// move the rest data backwords from index
	SCBaseType * src = array->items + index * array->itemSize;
	SCBaseType * dest = src + array->itemSize;
	NSUInteger len = (array->count - index) * array->itemSize;
	memmove(dest, src, len);
	
	// insert item
	array->assign(src, item);
	array->count += 1;
}

void SCBaseArrayRemove(SCBaseArray * array, NSUInteger index)
{
	NSAssert(array->count <= array->maxCount, @"error");
	NSAssert(index < array->count, @"error");
	
	// move the rest data forwards to index
	SCBaseType * dest = array->items + index * array->itemSize;
	SCBaseType * src = dest + array->itemSize;
	NSUInteger len = (array->count - index - 1) * array->itemSize;
	memmove(dest, src, len);
	
	array->count -= 1;
}

void SCBaseArraySort(SCBaseArray * array)
{
	NSAssert(array->count <= array->maxCount, @"error");
	//NSAssert(array->count > 1, @"error");
	NSAssert(array->compare != NULL, @"error");
	qsort(array->items, 0, array->count - 1, array->compare);
}
