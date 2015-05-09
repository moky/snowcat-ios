//
//  SCBaseType.h
//  SnowCat
//
//  Created by Moky on 15-5-8.
//  Copyright (c) 2015 Moky. All rights reserved.
//

typedef unsigned char SCBaseType;

typedef void (*SCBaseTypeAssignFunction)(void * ptr, const void * val);
typedef int (*SCBaseTypeCompareFunction)(const void * ptr1, const void * ptr2);

typedef void (^SCBaseTypeAssignBlock)(void * ptr, const void * val);
typedef int (^SCBaseTypeCompareBlock)(const void * ptr1, const void * ptr2);


// int
void SCIntAssign(void * ptr, const void * val);
int SCIntCompare(const void * ptr1, const void * ptr2);

// float
void SCFloatAssign(void * ptr, const void * val);
int SCFloatCompare(const void * ptr1, const void * ptr2);
