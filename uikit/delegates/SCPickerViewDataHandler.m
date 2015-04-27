//
//  SCPickerViewDataHandler.m
//  SnowCat
//
//  Created by Moky on 14-11-22.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCMemoryCache.h"
#import "SCNodeFileParser.h"
#import "SCPickerViewDataHandler.h"

@interface SCPickerViewDataHandler ()

@property(nonatomic, retain) NSString * filename;
@property(nonatomic, retain) NSDictionary * data;

@end

@implementation SCPickerViewDataHandler

@synthesize filename = _filename;
@synthesize data = _data;

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

- (void) dealloc
{
	[_filename release];
	[_data release];
	
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		self.filename = nil;
		self.data = nil;
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	self = [self init];
	if (self) {
		self.filename = [dict objectForKey:@"File"];
		[self reloadData:nil];
	}
	return self;
}

#pragma mark protocol

- (NSDictionary *) _reloadData
{
	NSAssert(_filename, @"must defined 'File' tag for filename");
	NSDictionary * data = nil;
	
	SCMemoryCache * cache = [SCMemoryCache getInstance];
//	// remove from memory cache(just the root file, not includes)
//	// 1. remove cache by file path
//	[cache removeObjectForKey:_filename];
//	// 2. remove cache by file url
//	NSURL * url = [[SCURL alloc] initWithString:_filename isDirectory:NO];
//	[cache removeObjectForKey:url];
//	[url release];
//	// 3. purge all cache
//	//[cache purgeDataCache];
	
	// get from memory cache
	data = [cache objectForKey:_filename];
	
	if (!data) {
		// load as a node file
		SCNodeFileParser * parser = [SCNodeFileParser parser:_filename];
		data = [parser node];
		NSAssert([data isKindOfClass:[NSDictionary class]], @"node file data error: %@", _filename);
		
		// cache by file path
		[cache setObject:data forKey:_filename];
	}
	
	return data;
}

- (void) reloadData:(UIPickerView *)pickerView
{
	self.data = [self _reloadData];
}

- (NSArray *) components
{
	NSArray * components = [_data objectForKey:@"components"];
	return components ? components : [NSArray arrayWithObject:_data]; // take the whole dict as section 0
}

- (NSUInteger) numberOfComponents
{
	return [[self components] count];
}

- (NSDictionary *) componentAtIndex:(NSInteger)componentIndex
{
	NSAssert(componentIndex >= 0, @"error component index: %d", (int)componentIndex);
	NSArray * components = [self components];
	if (componentIndex >= [components count]) {
		SCLog(@"What the hell are you doing? %d >= %u", (int)componentIndex, (unsigned int)[components count]);
		return nil;
	}
	return [components objectAtIndex:componentIndex];
}

- (NSArray *) rowsInComponent:(NSInteger)componentIndex
{
	NSDictionary * component = [self componentAtIndex:componentIndex];
	NSAssert([component isKindOfClass:[NSDictionary class]], @"error component index: %d", (int)componentIndex);
	return [component objectForKey:@"rows"];
}

- (NSUInteger) numberOfRowsInComponent:(NSInteger)componentIndex
{
	NSArray * rows = [self rowsInComponent:componentIndex];
	NSAssert([rows isKindOfClass:[NSArray class]], @"error component index: %d", (int)componentIndex);
	return [rows count];
}

- (NSDictionary *) rowAtIndex:(NSInteger)rowIndex componentIndex:(NSInteger)componentIndex
{
	NSAssert(rowIndex >= 0 && componentIndex >= 0, @"error component index: %d, row index: %d", (int)componentIndex, (int)rowIndex);
	NSArray * rows = [self rowsInComponent:componentIndex];
	if (rowIndex >= [rows count]) {
		SCLog(@"What the hell are you doing? %d >= %u", (int)rowIndex, (unsigned int)[rows count]);
		return nil;
	}
	return [rows objectAtIndex:rowIndex];
}

@end
