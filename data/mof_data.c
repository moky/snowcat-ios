//
//  mof_data.c
//  MemoryObjectFile
//
//  Created by Moky on 14-12-8.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "mof_data.h"

#define MOF_VERSION     0x01
#define MOF_SUB_VERSION 0x01

#define MOF_ASSERT(cond, format, ...)                                          \
    if (!(cond)) {                                                             \
        printf("<mof_data.c:%d> %s ", __LINE__, __FUNCTION__);                 \
        printf(format, ##__VA_ARGS__);                                         \
        printf("\r\n");                                                        \
    }                                                                          \
                                                        /* EOF 'MOF_ASSERT()' */

// create initialized buffer
MOFData * mof_create(const unsigned long buf_len)
{
	if (buf_len <= sizeof(MOFData)) {
		MOF_ASSERT(MOFFalse, "buffer length error: %ld", buf_len);
		return NULL;
	}
	
	unsigned char * buffer = (unsigned char *)malloc(buf_len);
	if (!buffer) {
		MOF_ASSERT(MOFFalse, "not enough memory: %ld", buf_len);
		return NULL;
	}
	memset(buffer, 0, buf_len);
	
	// data
	MOFData * data = (MOFData *)buffer;
	
	// data head
	MOFDataHead * head = &data->head;
	
	//-- protocol
	head->format[0] = 'M';
	head->format[1] = 'O';
	head->format[2] = 'F';
	head->format[3] = '\0';
	
	head->version = MOF_VERSION;
	head->subVersion = MOF_SUB_VERSION;
	
	head->fileLength = buf_len;
	
	//-- info
	time_t now = time(NULL);
	struct tm * tm = gmtime(&now);
	
	snprintf((char *)head->description, sizeof(head->description),
			 "Memory Object File. Generated at %d-%d-%d %d:%d:%d",
			 tm->tm_year + 1900, tm->tm_mon, tm->tm_mday, tm->tm_hour, tm->tm_min, tm->tm_sec);
	
	snprintf((char *)head->copyright, sizeof(head->copyright),
			 "Copyright %d Slanissue Inc.",
			 tm->tm_year + 1900);
	
	snprintf((char *)head->author, sizeof(head->author),
			 "Author: Moky@Beva, %d-%d-%d", 2014, 12, 10);
	
	// data body
	MOFDataBody * body = &data->body;
	
	body->itemsBuffer.offset = sizeof(MOFData);
	//body->itemsBuffer.length = sizeof(MOFDataItem) * MOFItemsCountMax;
	//body->stringsBuffer.offset = body->itemsBuffer.offset + body->itemsBuffer.length;
	//body->stringsBuffer.length =
	
	return data;
}

// destroy buffer
void mof_destroy(void * data)
{
	free(data);
}

// check data format
int mof_check(const MOFData * data)
{
	const MOFDataHead * head = &data->head;
	
	// 1. format
	if (head->format[0] != 'M' || head->format[1] != 'O' || head->format[2] != 'F' || head->format[3] != '\0') {
		return MOFErrorFormat;
	}
	
	// 2. version
	if (head->version != MOF_VERSION || head->subVersion != MOF_SUB_VERSION) {
		return MOFErrorVersion;
	}
	
	const MOFDataBody * body = &data->body;
	unsigned long buf_len = sizeof(MOFData) + body->itemsBuffer.length + body->stringsBuffer.length;
	
	// 3. file length
	if (head->fileLength != buf_len) {
		return MOFErrorFileLength;
	}
	
	// 4. buffer info
	if (body->itemsBuffer.offset != sizeof(MOFData) ||
		body->itemsBuffer.length == 0) {
		return MOFErrorBufferInfo;
	}
	if (body->stringsBuffer.offset != body->itemsBuffer.offset + body->itemsBuffer.length ||
		body->stringsBuffer.length == 0) {
		return MOFErrorBufferInfo;
	}
	
	return MOFCorrect;
}

#pragma mark - Input/Output

const MOFData * mof_load(const char * filename)
{
	FILE * fp = fopen(filename, "rb");
	if (!fp) {
		// failed to open file for reading
		MOF_ASSERT(MOFFalse, "failed to open file for reading: %s", filename);
		return NULL;
	}
	
	// get file size
	fseek(fp, 0, SEEK_END);
	unsigned long size = ftell(fp);
	fseek(fp, 0, SEEK_SET);
	
	// create buffer for reading
	unsigned char * buffer = (unsigned char *)malloc(size);
	if (!buffer) {
		// not enough memory
		MOF_ASSERT(MOFFalse, "not enough memory: %ld", size);
		return NULL;
	}
	memset(buffer, 0, size);
	
	// read file
	fread(buffer, sizeof(unsigned char), size, fp);
	fclose(fp);
	
	MOFData * data = (MOFData *)buffer;
	
	int err = mof_check(data);
	if (err == MOFCorrect) {
		return data;
	} else {
		MOF_ASSERT(MOFFalse, "data file error: %s, code: %d", filename, err);
		mof_destroy(buffer);
		return NULL;
	}
}

int mof_save(const char * filename, const MOFData * data)
{
	int err = mof_check(data);
	if (err != MOFCorrect) {
		MOF_ASSERT(MOFFalse, "data error: %d", err);
		return -1;
	}
	unsigned char * buffer = (unsigned char *)data;
	unsigned long buf_len = data->head.fileLength;
	
	// open file to write
	FILE * fp = fopen(filename, "wb");
	if (!fp) {
		MOF_ASSERT(MOFFalse, "failed to open file for writing: %s", filename);
		return -2;
	}
	
	// do writing
	unsigned long written = fwrite(buffer, sizeof(unsigned char), buf_len, fp);
	
	// close file
	fclose(fp);
	
	if (written == buf_len) {
		return 0; // ok
	} else {
		MOF_ASSERT(MOFFalse, "written error: %ld, buffer len: %ld", written, buf_len);
		return -3; // error
	}
}

#pragma mark - getter

//// get id (index) for string
//static unsigned long _string_id(const char * string, const MOFData * data)
//{
//	const unsigned char * buffer = (const unsigned char *)data;
//	const unsigned char * start = buffer + data->body.stringsBuffer.offset;
//	const unsigned char * end = start + data->body.stringsBuffer.length;
//	// head of the strings buffer is the total 'count'
//	unsigned long * count = (unsigned long *)start;
//	const unsigned char * p = start + sizeof(unsigned long); // start reading after 'count'
//	unsigned long i;
//	MOFStringItem * item;
//	for (i = 0; i < *count && p < end; ++i) {
//		item = (MOFStringItem *)p;
//		if (strcmp(item->string, string) == 0) {
//			return i;
//		}
//		p += item->length; // move to next string item
//	}
//	return MOFStringNotFound;
//}

// get string by id (index)
static MOFString _string_by_id(const unsigned long index, const MOFData * data)
{
	const unsigned char * buffer = (const unsigned char *)data;
	const unsigned char * start = buffer + data->body.stringsBuffer.offset;
	const unsigned char * end = start + data->body.stringsBuffer.length;
	// head of the strings buffer is the total 'count'
	unsigned long * count = (unsigned long *)start;
	const unsigned char * p = start + sizeof(unsigned long); // start reading after 'count'
	unsigned long i;
	MOFStringItem * item;
	for (i = 0; i < *count && p < end; ++i) {
		item = (MOFStringItem *)p;
		if (i == index) {
			return item->string;
		}
		p += item->length; // move to next string item
	}
	return NULL;
}

// get root item (the first item)
const MOFDataItem * mof_root(const MOFData * data)
{
	return mof_item(0, data);
}

// get first item
const MOFDataItem * mof_items_start(const MOFData * data)
{
	return mof_item(0, data);
}

// get tail of items (next of the last item)
const MOFDataItem * mof_items_end(const MOFData * data)
{
	const MOFDataBody * body = &data->body;
	const MOFBufferInfo * buffer = &body->itemsBuffer;
	unsigned long count = buffer->length / sizeof(MOFDataItem);
	MOF_ASSERT(count > 0, "items count must > 0");
	return body->items + count;
}

// get item with global index
const MOFDataItem * mof_item(const unsigned long index, const MOFData * data)
{
	const MOFDataBody * body = &data->body;
	const MOFBufferInfo * buffer = &body->itemsBuffer;
	unsigned long count = buffer->length / sizeof(MOFDataItem);
	if (index >= count) {
		MOF_ASSERT(MOFFalse, "out of range: %ld >= %ld", index, count);
		return NULL;
	}
	return body->items + index;
}

#pragma mark values

// get key with item (for dictionary)
MOFString mof_key(const MOFDataItem * item, const MOFData * data)
{
	MOF_ASSERT(item->type == MOFDataItemTypeKey, "not key type: %d", item->type);
	return _string_by_id(item->keyId, data);
}

// get string with item
MOFString mof_str(const MOFDataItem * item, const MOFData * data)
{
	MOF_ASSERT(item->type == MOFDataItemTypeString, "not string type: %d", item->type);
	return _string_by_id(item->stringId, data);
}

// get integer with item
MOFInteger mof_int(const MOFDataItem * item)
{
	MOF_ASSERT(item->type == MOFDataItemTypeInteger, "not int type: %d", item->type);
	return item->intValue;
}

// get unsigned integer with item
MOFUInteger mof_uint(const MOFDataItem * item)
{
	MOF_ASSERT(item->type == MOFDataItemTypeInteger, "not unsigned int type: %d", item->type);
	return item->uintValue;
}

// get float with item
MOFFloat mof_float(const MOFDataItem * item)
{
	MOF_ASSERT(item->type == MOFDataItemTypeFloat, "not float type: %d", item->type);
	return item->floatValue;
}

// get bool with item
MOFBool mof_bool(const MOFDataItem * item)
{
	MOF_ASSERT(item->type == MOFDataItemTypeBool, "not bool type: %d", item->type);
	return item->boolValue;
}
