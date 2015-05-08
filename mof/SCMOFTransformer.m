//
//  SCMOFTransformer.m
//  SnowCat
//
//  Created by Moky on 14-12-10.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#include "mof_data.h"

#import "SCMOFTransformer.h"

static unsigned long _indexForString(NSString * string, NSMutableArray * mStringsArray)
{
	unsigned long index = 0;
	
	NSEnumerator * enumerator = [mStringsArray objectEnumerator];
	NSString * str;
	while (str = [enumerator nextObject]) {
		if ([str isEqualToString:string]) {
			break;
		}
		++index;
	}
	
	if (index >= [mStringsArray count]) {
		NSLog(@"[MOF] add new string '%@' to array, index: %ld", string, index);
		[mStringsArray addObject:string];
	}
	
	return index;
}

static unsigned long _processObject(NSObject * object,
									MOFDataItem * pItemBuffer,
									unsigned long iPlaceLeft,
									NSMutableArray * mStringsArray); // pre-defined

static unsigned long _processArray(NSArray * array,
								   MOFDataItem * pItemBuffer,
								   unsigned long iPlaceLeft,
								   NSMutableArray * mStringsArray)
{
	if (iPlaceLeft == 0) {
		NSLog(@"[MOF] not enough space");
		return 0;
	}
	
	pItemBuffer->type = MOFDataItemTypeArray;
	pItemBuffer->count = [array count];
	
	// first child, starts from next item
	MOFDataItem * pChild;
	unsigned long iCount = 1;
	
	NSEnumerator * enumerator = [array objectEnumerator];
	NSObject * object;
	while (object = [enumerator nextObject]) {
		pChild = pItemBuffer + iCount;
		iCount += _processObject(object, pChild, iPlaceLeft - iCount, mStringsArray);
	}
	
	return iCount;
}

static unsigned long _processDictionary(NSDictionary * dict,
										MOFDataItem * pItemBuffer,
										unsigned long iPlaceLeft,
										NSMutableArray * mStringsArray)
{
	if (iPlaceLeft == 0) {
		NSLog(@"[MOF] not enough space");
		return 0;
	}
	
	pItemBuffer->type = MOFDataItemTypeDictionary;
	pItemBuffer->count = [dict count];
	
	// first child, starts from next item
	MOFDataItem * pKey;
	MOFDataItem * pObject;
	unsigned long iCount = 1;
	
	NSEnumerator * enumerator = [dict keyEnumerator];
	NSString * key;
	NSObject * object;
	while (key = [enumerator nextObject]) {
		// key
		pKey = pItemBuffer + iCount;
		unsigned long keyId = _indexForString(key, mStringsArray);
		pKey->type = MOFDataItemTypeKey;
		pKey->keyId = keyId;
		// value
		++iCount;
		pObject = pItemBuffer + iCount;
		object = [dict objectForKey:key];
		iCount += _processObject(object, pObject, iPlaceLeft - iCount, mStringsArray);
	}
	
	return iCount;
}

static unsigned long _processString(NSString * string,
									MOFDataItem * pItemBuffer,
									unsigned long iPlaceLeft,
									NSMutableArray * mStringsArray)
{
	if (iPlaceLeft == 0) {
		NSLog(@"[MOF] not enough space");
		return 0;
	}
	
	pItemBuffer->type = MOFDataItemTypeString;
	pItemBuffer->stringId = _indexForString(string, mStringsArray);
	
	return 1;
}

static unsigned long _processNumber(NSNumber * number,
									MOFDataItem * pItemBuffer,
									unsigned long iPlaceLeft)
{
	if (iPlaceLeft == 0) {
		NSLog(@"[MOF] not enough space");
		return 0;
	}
	
	NSString * string = [number stringValue];
	if ([string rangeOfString:@"."].location != NSNotFound) {
		pItemBuffer->type = MOFDataItemTypeFloat;
		pItemBuffer->floatValue = [number floatValue];
	} else {
		pItemBuffer->type = MOFDataItemTypeInteger;
		pItemBuffer->intValue = [number intValue];
	}
	
	return 1;
}

static unsigned long _processObject(NSObject * object,
									MOFDataItem * pItemBuffer,
									unsigned long iPlaceLeft,
									NSMutableArray * mStringsArray)
{
	if (iPlaceLeft == 0) {
		NSLog(@"[MOF] not enough space");
		return 0;
	}
	
	unsigned long iCount = 0;
	
	if ([object isKindOfClass:[NSArray class]])
	{
		NSArray * array = (NSArray *)object;
		iCount += _processArray(array, pItemBuffer, iPlaceLeft, mStringsArray);
	}
	else if ([object isKindOfClass:[NSDictionary class]])
	{
		NSDictionary * dict = (NSDictionary *)object;
		iCount += _processDictionary(dict, pItemBuffer, iPlaceLeft, mStringsArray);
	}
	else if ([object isKindOfClass:[NSString class]])
	{
		NSString * string = (NSString *)object;
		iCount += _processString(string, pItemBuffer, iPlaceLeft, mStringsArray);
	}
	else if ([object isKindOfClass:[NSNumber class]])
	{
		NSNumber * number = (NSNumber *)object;
		iCount += _processNumber(number, pItemBuffer, iPlaceLeft);
	}
	else
	{
		NSLog(@"[MOF] unknown object");
		pItemBuffer->type = MOFDataItemTypeUnknown;
		iCount += 1;
	}
	return iCount;
}

static unsigned char * _createItemsBuffer(NSObject * root,
										  unsigned long * pBufferLength,
										  NSMutableArray * mStringsArray)
{
	unsigned long iMaxItems = 65536;
	unsigned long iBufferLength = sizeof(MOFDataItem) * iMaxItems;
	
	MOFDataItem * pItemsBuffer = (MOFDataItem *)malloc(iBufferLength);
	if (!pItemsBuffer) {
		NSLog(@"[MOF] not enough memory");
		return NULL;
	}
	memset(pItemsBuffer, 0, iBufferLength);
	
	unsigned long iCount = _processObject(root, pItemsBuffer, iMaxItems, mStringsArray);
	
	*pBufferLength = sizeof(MOFDataItem) * iCount;
	return (unsigned char *)pItemsBuffer;
}

static unsigned char * _createStringsBuffer(NSArray * stringsArray,
											unsigned long * pBufferLength)
{
	unsigned long iCount = [stringsArray count];
	unsigned long iMaxLength = 65536 * iCount;
	
	unsigned char * pBuffer = (unsigned char *)malloc(iMaxLength);
	memset(pBuffer, 0, iMaxLength);
	unsigned char * p = (unsigned char *)pBuffer;
	
	// save 'count' first
	unsigned long * pCount = (unsigned long *)p;
	p += sizeof(unsigned long);
	*pCount = iCount;
	
	// save each string
	NSEnumerator * enumerator = [stringsArray objectEnumerator];
	NSString * string;
	const char * str;
	unsigned long len;
	MOFStringItem * item;
	while (string = [enumerator nextObject]) {
		//str = [string cStringUsingEncoding:NSUTF8StringEncoding];
		str = [string UTF8String];
		len = strlen(str);
		if (len > 65535) {
			// too long string
			len = 65535;
		}
		
		item = (MOFStringItem *)p;
		// entire item length, includes 'sizeof(length)' and the last '\0' of string
		item->length = sizeof(MOFStringItem) + len + 1;
		strncpy(item->string, str, len);
		item->string[len] = '\0';
		
		p += item->length;
	}
	
	*pBufferLength = p - pBuffer;
	return pBuffer;
}

static void _destroyBuffer(void * buffer)
{
	free(buffer);
}

@implementation SCMOFTransformer

- (instancetype) initWithObject:(NSObject *)root
{
	NSMutableArray * mStringsArray = [[NSMutableArray alloc] initWithCapacity:65535];
	
	// items buffer
	unsigned long itemsBufferLength = 0;
	unsigned char * itemsBuffer = _createItemsBuffer(root, &itemsBufferLength, mStringsArray);
	NSAssert(itemsBuffer && itemsBufferLength > 0, @"failed to create items buffer");
	
	// string array buffer
	unsigned long stringsBufferLength = 0;
	unsigned char * stringsBuffer = _createStringsBuffer(mStringsArray, &stringsBufferLength);
	NSAssert(stringsBuffer && stringsBufferLength > 0, @"failed to create strings buffer");
	
	// OK!
	NSLog(@"[MOF] itemsBufferLength: %ld, stringsBufferLength: %ld", itemsBufferLength, stringsBufferLength);
	
	unsigned long bufferLength = sizeof(MOFData) + itemsBufferLength + stringsBufferLength;
	NSLog(@"[MOF] bufferLength: %ld", bufferLength);
	
	self = [self initWithLength:bufferLength];
	if (self) {
		MOFData * data = (MOFData *)_dataBuffer;
		MOFDataBody * body = &data->body;
		unsigned char * p = (unsigned char *)body->items;
		
		// copy items buffer
		body->itemsBuffer.length = itemsBufferLength;
		memcpy(p, itemsBuffer, itemsBufferLength);
		
		// copy strings buffer
		p += itemsBufferLength;
		body->stringsBuffer.offset = body->itemsBuffer.offset + body->itemsBuffer.length;
		body->stringsBuffer.length = stringsBufferLength;
		memcpy(p, stringsBuffer, stringsBufferLength);
	}
	
	_destroyBuffer(stringsBuffer);
	_destroyBuffer(itemsBuffer);
	
	[mStringsArray release];
	
	return self;
}

@end
