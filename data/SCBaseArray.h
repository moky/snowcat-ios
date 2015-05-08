//
//  SCBaseArray.h
//  SnowCat
//
//  Created by Moky on 15-5-8.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "SCBaseType.h"

typedef struct {
	NSUInteger count;
	NSUInteger maxCount;
	
	NSUInteger itemSize;
	SCBaseType * items;
	
	// functions
	SCBaseTypeAssign  assign;
	SCBaseTypeCompare compare;
} SCBaseArray;


SCBaseArray * SCBaseArrayCreate(NSUInteger itemSize, NSUInteger capacity);
void SCBaseArrayDestroy(SCBaseArray * array);

void SCBaseArrayAdd(SCBaseArray * array, const SCBaseType * item);
void SCBaseArrayInsert(SCBaseArray * array, const SCBaseType * item, NSUInteger index);
void SCBaseArrayRemove(SCBaseArray * array, NSUInteger index);

void SCBaseArraySort(SCBaseArray * array);
