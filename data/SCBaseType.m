//
//  SCBaseType.m
//  SnowCat
//
//  Created by Moky on 15-5-8.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "SCBaseType.h"

// int
void SCIntAssign(void * ptr, const void * val)
{
	int * p = (int *)ptr;
	int * v = (int *)val;
	*p = *v;
}

int SCIntCompare(const void * ptr1, const void * ptr2)
{
	int * p1 = (int *)ptr1;
	int * p2 = (int *)ptr2;
	if (*p1 > *p2) {
		return NSOrderedDescending;
	} else if (*p1 < *p2) {
		return NSOrderedAscending;
	} else {
		return NSOrderedSame;
	}
}

// float
void SCFloatAssign(void * ptr, const void * val)
{
	float * p = (float *)ptr;
	float * v = (float *)val;
	*p = *v;
}

int SCFloatCompare(const void * ptr1, const void * ptr2)
{
	float * p1 = (float *)ptr1;
	float * p2 = (float *)ptr2;
	if (*p1 > *p2) {
		return NSOrderedDescending;
	} else if (*p1 < *p2) {
		return NSOrderedAscending;
	} else {
		return NSOrderedSame;
	}
}
