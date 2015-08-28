//
//  SCTableViewDataSource.m
//  SnowCat
//
//  Created by Moky on 14-3-18.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "SCDictionary.h"
#import "SCTableViewCell.h"
#import "SCTableViewDataSource.h"

@interface SCTableViewDataSource () {
	
	NSUInteger _reloadTimes; // once reloadData call, _reloadTimes++
}

@end

@implementation SCTableViewDataSource

@synthesize handler = _handler;

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

- (void) dealloc
{
	[_handler release];
	
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		self.handler = nil;
		_reloadTimes = 0;
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	self = [self init];
	if (self) {
		// set data handler
		NSDictionary * handler = [dict objectForKey:@"handler"];
		if (handler) {
			[handler retain];
		} else {
			NSString * filename = [dict objectForKey:@"File"];
			if (filename) {
				handler = [[NSDictionary alloc] initWithObjectsAndKeys:filename, @"File", nil];
			}
		}
		if (handler) {
			SCTableViewDataHandler * tvdh = [SCTableViewDataHandler create:handler autorelease:NO];
			NSAssert([tvdh isKindOfClass:[SCTableViewDataHandler class]], @"handler's definition error: %@", handler);
			self.handler = tvdh;
			[tvdh release];
			
			[handler release];
		}
	}
	return self;
}

- (void) reloadData:(UITableView *)tableView
{
	NSAssert(_handler, @"there must be a handler");
	[_handler reloadData:tableView];
	
	++_reloadTimes;
}

#pragma mark - UITableViewDataSource

//@required
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSAssert(_handler, @"there must be a handler");
	return [_handler numberOfRowsInSection:section];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

//
//  create a standard table view cell
//
- (UITableViewCell *) _tableView:(UITableView *)tableView standardCellForRowAtIndexPath:(NSIndexPath *)indexPath withTemplate:(NSDictionary *)template
{
	NSString * reuseIdentifier = [template objectForKey:@"reuseIdentifier"];
	if (!reuseIdentifier) {
		reuseIdentifier = @"reuseIdentifier";
	}
	
	SCTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	if (cell) {
		// tearing for SCSwipeTableViewCell
		SEL func = @selector(onReuse:);
		if ([cell respondsToSelector:func]) {
			[cell performSelector:func withObject:self];
		}
	} else {
		cell = [SCTableViewCell create:template];
		[SCTableViewCell resetCell:cell withTableView:tableView];
		NSAssert([cell isKindOfClass:[UITableViewCell class]], @"table view cell's definition error: %@", template);
		SC_UIKIT_SET_ATTRIBUTES(cell, SCTableViewCell, template);
	}
	
	NSDictionary * item = [_handler rowAtIndex:indexPath.row sectionIndex:indexPath.section];
	NSAssert(!item || [item isKindOfClass:[NSDictionary class]], @"error row index: %d, section index: %d", (int)indexPath.row, (int)indexPath.section);
	
	// use 'setAttributes:' to reset parameters
	SC_UIKIT_SET_ATTRIBUTES(cell, SCTableViewCell, item);
	
	return cell;
}

//
//  create a customized table view cell
//
- (UITableViewCell *) _tableView:(UITableView *)tableView customizedCellForRowAtIndexPath:(NSIndexPath *)indexPath withTemplate:(NSDictionary *)template
{
	NSString * reuseIdentifier = [[NSString alloc] initWithFormat:@"<%d,%d>", (int)indexPath.section, (int)indexPath.row];
	
	SCTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	if (cell) {
		// 1. new cell
		if (cell.tag == _reloadTimes) {
			// tearing for SCSwipeTableViewCell
			SEL func = @selector(onReuse:);
			if ([cell respondsToSelector:func]) {
				[cell performSelector:func withObject:self];
			}
			[reuseIdentifier release];
			return cell;
		}
		// 2. old cell
	//} else {
		// 3. no cell
	}
	
	NSDictionary * item = [_handler rowAtIndex:indexPath.row sectionIndex:indexPath.section];
	NSAssert(!item || [item isKindOfClass:[NSDictionary class]], @"error row index: %d, section index: %d", (int)indexPath.row, (int)indexPath.section);
	if (template && ![item objectForKey:@"Class"]) {
		// when the item includes 'Class', means it is a UITableViewCell's definition,
		// not just a key-value data,
		// so we create it directly, no need replacing.
		item = [SCDictionary replaceDictionary:template withData:item];
	}
	
	NSMutableDictionary * md = [[NSMutableDictionary alloc] initWithDictionary:item];
	[md setObject:reuseIdentifier forKey:@"reuseIdentifier"];
	
	if (!cell) {
		cell = [SCTableViewCell create:md];
	}
	
	[SCTableViewCell resetCell:cell withTableView:tableView];
	NSAssert([cell isKindOfClass:[UITableViewCell class]], @"table view cell's definition error: %@", md);
	SC_UIKIT_SET_ATTRIBUTES(cell, SCTableViewCell, md);
	cell.tag = _reloadTimes;
	[md release];
	
	[reuseIdentifier release];
	return cell;
}

//Do not use the tag of cell. Because it is redefine when the cell reuse;
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSAssert(_handler, @"there must be a handler");
	
	NSDictionary * template = [_handler cellTemplateForSection:indexPath.section];
	NSAssert(!template || [template isKindOfClass:[NSDictionary class]], @"cell template must be a dictioanry: %@", template);
	
	NSString * stype = [template objectForKey:@"style"];
	if (stype) {
		return [self _tableView:tableView standardCellForRowAtIndexPath:indexPath withTemplate:template];
	} else {
		return [self _tableView:tableView customizedCellForRowAtIndexPath:indexPath withTemplate:template];
	}
}

//@optional
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
	NSAssert(_handler, @"there must be a handler");
	return [_handler numberOfSections];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section    // fixed font style. use custom view (UILabel) if you want something different
{
	NSAssert(_handler, @"there must be a handler");
	return [[_handler sectionAtIndex:section] objectForKey:@"header"];
}
- (NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	NSAssert(_handler, @"there must be a handler");
	return [[_handler sectionAtIndex:section] objectForKey:@"footer"];
}

//// Editing
//
//// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
//
//// Moving/reordering
//
//// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;
//
//// Index
//
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView;                                                    // return list of section titles to display in section index view (e.g. "ABCD...Z#")
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;  // tell table which section corresponds to section title/index (e.g. "B",1))
//
//// Data manipulation - insert and delete support
//
//// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
//
//// Data manipulation - reorder / moving support
//
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;

@end
