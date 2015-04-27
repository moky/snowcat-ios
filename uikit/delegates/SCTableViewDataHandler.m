//
//  SCTableViewDataHandler.m
//  SnowCat
//
//  Created by Moky on 14-4-12.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCURL.h"
#import "SCMemoryCache.h"
#import "SCNodeFileParser.h"
#import "SCTableViewDataHandler.h"

@interface SCTableViewDataHandler ()

@property(nonatomic, retain) NSString * filename;
@property(nonatomic, retain) NSDictionary * data;

@property(nonatomic, retain) NSDictionary * cellTemplate;
@property(nonatomic, readwrite) CGSize cellSize;

@end

@implementation SCTableViewDataHandler

@synthesize filename = _filename;
@synthesize data = _data;

@synthesize cellTemplate = _cellTemplate;
@synthesize cellSize = _cellSize;

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

- (void) dealloc
{
	[_filename release];
	[_data release];
	
	[_cellTemplate release];
	
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		self.filename = nil;
		self.data = nil;
		
		self.cellTemplate = nil;
		self.cellSize = CGSizeZero;
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	self = [self init];
	if (self) {
		// templates
		NSDictionary * templates = [dict objectForKey:@"templates"];
		if (templates) {
			self.cellTemplate = [self _getCellTemplate:templates];
		}
		
		// rows
		NSArray * rows = [dict objectForKey:@"rows"];
		if (rows) {
			NSDictionary * section0 = [[NSDictionary alloc] initWithObjectsAndKeys:rows, @"rows", nil];
			NSArray * sections = [[NSArray alloc] initWithObjects:section0, nil];
			NSDictionary * data = [[NSDictionary alloc] initWithObjectsAndKeys:sections, @"sections", nil];
			self.data = data;
			[data release];
			[sections release];
			[section0 release];
		}
		
		// File
		NSString * filename = [dict objectForKey:@"File"];
		if (filename) {
			self.filename = filename;
		}
		
		[self reloadData:nil];
	}
	return self;
}

#pragma mark -

- (NSDictionary *) templates
{
	NSAssert(!_data || [_data isKindOfClass:[NSDictionary class]], @"data error: %@", _data);
	return [_data objectForKey:@"templates"];
}

- (NSDictionary *) _getCellTemplate:(NSDictionary *)templates
{
	NSAssert(!templates || [templates isKindOfClass:[NSDictionary class]], @"templates error: %@", templates);
	NSDictionary * cell = [templates objectForKey:@"cell"];
	if (!cell) {
		return nil;
	}
	NSAssert([cell isKindOfClass:[NSDictionary class]], @"cell template error: %@", cell);
	if ([cell objectForKey:@"contentView"]) {
		return cell;
	} else {
		return [NSDictionary dictionaryWithObject:cell forKey:@"contentView"];
	}
}

- (NSDictionary *) cellTemplate
{
	if (!_cellTemplate) {
		NSDictionary * templates = [self templates];
		self.cellTemplate = [self _getCellTemplate:templates];
	}
	return _cellTemplate;
}

- (NSDictionary *) cellTemplateForSection:(NSInteger)sectionIndex
{
	NSDictionary * section = [self sectionAtIndex:sectionIndex];
	NSAssert([section isKindOfClass:[NSDictionary class]], @"failed to get section: %d", (int)sectionIndex);
	NSDictionary * templates = [section objectForKey:@"templates"];
	if (templates) {
		NSDictionary * cell = [self _getCellTemplate:templates];
		if (cell) {
			return cell;
		}
	}
	return [self cellTemplate];
}

#pragma mark protocol

- (NSDictionary *) _reloadData
{
	if (!_filename) {
		SCLog(@"data file not defined, nothing changed");
		return _data;
	}
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

- (void) reloadData:(UITableView *)tableView
{
	self.data = [self _reloadData];
	
	NSDictionary * templates = self.templates;
	if (!templates) {
		SCLog(@"templates not updated");
		return;
	}
	self.cellTemplate = [self _getCellTemplate:templates];
	self.cellSize = CGSizeZero;
	
	// update contentSize
	NSDictionary * cell = self.cellTemplate;
	NSAssert(!cell || [cell isKindOfClass:[NSDictionary class]], @"cell template must be a dictionary: %@", cell);
	NSDictionary * contentView = [cell objectForKey:@"contentView"];
	NSAssert(!contentView || [contentView isKindOfClass:[NSDictionary class]], @"contentView's definition must be a dictioanry: %@", contentView);
	
	NSString * contentSize = [contentView objectForKey:@"size"];
	if (contentSize) {
		self.cellSize = CGSizeFromString(contentSize);
	}
}

- (NSArray *) sections
{
	NSAssert([_data isKindOfClass:[NSDictionary class]], @"data error: %@", _data);
	NSArray * sections = [_data objectForKey:@"sections"];
	if (sections) {
		return sections;
	}
	if (_data) {
		// take the whole dict as section 0
		return [NSArray arrayWithObject:_data];
	}
	// error
	return nil;
}

- (NSUInteger) numberOfSections
{
	return [[self sections] count];
}

- (NSDictionary *) sectionAtIndex:(NSInteger)sectionIndex
{
	NSAssert(sectionIndex >= 0, @"error section index: %d", (int)sectionIndex);
	NSArray * sections = [self sections];
	if (sectionIndex >= [sections count]) {
		SCLog(@"What the hell are you doing? %d >= %u", (int)sectionIndex, (unsigned int)[sections count]);
		return nil;
	}
	return [sections objectAtIndex:sectionIndex];
}

- (NSArray *) rowsInSection:(NSInteger)sectionIndex
{
	NSDictionary * section = [self sectionAtIndex:sectionIndex];
	NSAssert([section isKindOfClass:[NSDictionary class]], @"error section index: %d", (int)sectionIndex);
	return [section objectForKey:@"rows"];
}

- (NSUInteger) numberOfRowsInSection:(NSInteger)sectionIndex
{
	NSArray * rows = [self rowsInSection:sectionIndex];
	NSAssert([rows isKindOfClass:[NSArray class]], @"error section index: %d", (int)sectionIndex);
	return [rows count];
}

- (NSDictionary *) rowAtIndex:(NSInteger)rowIndex sectionIndex:(NSInteger)sectionIndex
{
	NSAssert(rowIndex >= 0 && sectionIndex >= 0, @"error section index: %d, row index: %d", (int)sectionIndex, (int)rowIndex);
	NSArray * rows = [self rowsInSection:sectionIndex];
	if (rowIndex >= [rows count]) {
		SCLog(@"What the hell are you doing? %d >= %u", (int)rowIndex, (unsigned int)[rows count]);
		return nil;
	}
	return [rows objectAtIndex:rowIndex];
}

- (BOOL) removeRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSAssert(indexPath.row >= 0 && indexPath.section >= 0, @"error section index: %d, row index: %d", (int)indexPath.section, (int)indexPath.row);
	NSArray * rows = [self rowsInSection:indexPath.section];
	if (indexPath.row >= [rows count]) {
		SCLog(@"What the hell are you doing? %d >= %u", (int)indexPath.row, (unsigned int)[rows count]);
		return NO;
	}
	[(NSMutableArray *)rows removeObjectAtIndex:indexPath.row];
	return YES;
}

@end
