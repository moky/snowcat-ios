//
//  mof_protocol.h
//  MemoryObjectFile
//
//  Created by Moky on 14-12-8.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#ifndef __mof_protocol__
#define __mof_protocol__

// items count for dictionary/array
#define MOFArrayItemsCountMax      0xffff
#define MOFDictionaryItemsCountMax 0xffff

// items count for global
#define MOFItemsCountMax           0xffffffff

// max string length
#define MOFStringLengthMax         0xffff
// strings count for global string buffer
#define MOFStringsCountMax         0xffffffff

#define MOFStringNotFound          MOFStringsCountMax
#define MOFKeyNotFound             MOFStringsCountMax

// data type
#define MOFString   const char *
#define MOFInteger  int
#define MOFUInteger unsigned int
#define MOFFloat    float
#define MOFBool     int

#define MOFTrue     1
#define MOFFalse    0

//
// error code
//
enum {
	MOFCorrect         = 0,
	MOFErrorFormat     = 1 << 0,
	MOFErrorVersion    = 1 << 1,
	MOFErrorFileLength = 1 << 2,
	MOFErrorBufferInfo = 1 << 3,
};

//
// type for data item
//
typedef enum {
	MOFDataItemTypeKey,         // 0 (key for dictionary)
	
	MOFDataItemTypeArray,       // 1
	MOFDataItemTypeDictionary,  // 2
	
	MOFDataItemTypeString,      // 3
	MOFDataItemTypeInteger,     // 4
	MOFDataItemTypeFloat,       // 5
	MOFDataItemTypeBool,        // 6
	MOFDataItemTypeUnknown      // ?
} MOFDataItemType;

#pragma pack(1)

//
// string item in strings buffer
//
typedef struct {
	unsigned short length;    // entire item length, includes 'sizeof(length)' and the last '\0' of string
	char           string[0]; // head of string buffer
} MOFStringItem;

//
// data item
//
typedef struct {
	unsigned char      type;        // 0 - 255
	unsigned char      reserved[3]; // reserved for bytes alignment
	union {
		// key (for dictionary)
		unsigned long  keyId;       // 0 - 4,294,967,295 (4G)
		// string
		unsigned long  stringId;    // 0 - 4,294,967,295 (4G)
		// count (for dictionary/array)
		unsigned short count;       // 0 - 65,535 (64K)
		// numeric
		MOFInteger     intValue;
		MOFUInteger    uintValue;
		MOFFloat       floatValue;
		// bool
		MOFBool        boolValue;
	};
} MOFDataItem;

//
// data body
//
typedef struct {
	unsigned long offset; // offset of memory buffer (from data head)
	unsigned long length; // length of memory buffer (bytes)
} MOFBufferInfo;

typedef struct {
	MOFBufferInfo itemsBuffer;
	MOFBufferInfo stringsBuffer;
	
	MOFDataItem items[0]; // head of item buffer
} MOFDataBody;

//
// data head
//
typedef struct {
	// protocol
	unsigned char format[4];   // "MOF"
	unsigned char version;
	unsigned char subVersion;
	unsigned char reserved[2]; // reserved for bytes alignment
	unsigned long fileLength;
	// info
	unsigned char description[64];
	unsigned char copyright[32];
	unsigned char author[32];
} MOFDataHead;

//
// MOF data
//
typedef struct {
	MOFDataHead head;
	MOFDataBody body;
} MOFData;

#pragma pack()

#endif
