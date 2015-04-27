//
//  SCGridTableViewDataSource.m
//  SnowCat
//
//  Created by Moky on 14-4-23.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCDictionary.h"
#import "SCTableViewCell.h"
#import "SCGridTableView.h"
#import "SCGridTableViewDataSource.h"

@interface SCGridTableViewDataSource () {
	
	NSUInteger _countPerLine;
	
	NSUInteger _reloadTimes; // once reloadData call, _reloadTimes++
}

@end

@implementation SCGridTableViewDataSource

- (instancetype) init
{
	self = [super init];
	if (self) {
		_countPerLine = 0;
		_reloadTimes = 0;
	}
	return self;
}

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

- (void) reloadData:(UITableView *)tableView
{
	_countPerLine = 0;
	[super reloadData:tableView];
	++_reloadTimes;
}

- (void) updateGrid:(UIGridTableView *)gridTableView
{
	SCTableViewDataHandler * handler = [self handler];
	NSAssert(handler, @"there must be a handler");
	
	NSDictionary * template = [handler templates];
	NSAssert(!template || [template isKindOfClass:[NSDictionary class]], @"templates error: %@", template);
	
	// update max count perline
	NSString * maxCount = [template objectForKey:@"countPerLine"];
	if (maxCount) {
		_countPerLine = [maxCount integerValue];
	} else {
		CGSize size = [handler cellSize];
		if (size.width > 0) {
			_countPerLine = floor(gridTableView.bounds.size.width / size.width);
		}
	}
	if (_countPerLine < 1) {
		_countPerLine = 1;
	}
	
	// update grid column width
	NSString * columnWidth = [template objectForKey:@"columnWidth"];
	if (columnWidth) {
		gridTableView.columnWidth = [columnWidth floatValue];
	} else {
		gridTableView.columnWidth = gridTableView.bounds.size.width / _countPerLine;
	}
}

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	SCTableViewDataHandler * handler = [self handler];
	NSAssert(handler, @"there must be a handler");
	
	NSInteger totalCount = [handler numberOfRowsInSection:section];
	
	if (_countPerLine == 0) {// first run
		[self updateGrid:(UIGridTableView *)tableView];
	}
	NSAssert(_countPerLine > 0, @"error! counts per line: %u", (unsigned int)_countPerLine);
	if (totalCount > 1 && _countPerLine > 1) {
		totalCount = ceil((CGFloat)totalCount / _countPerLine);
	}
	
	return totalCount;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (_countPerLine == 0) {// first run
		[self updateGrid:(UIGridTableView *)tableView];
	}
	NSAssert(_countPerLine > 0, @"error! counts per line: %u", (unsigned int)_countPerLine);
	if (_countPerLine <= 1) {
		// single cell in each row
		return [super tableView:tableView cellForRowAtIndexPath:indexPath];
	}
	
	// multi cells in each row
	
	NSString * reuseIdentifier = [[NSString alloc] initWithFormat:@"<%d,%d|%u>", (int)indexPath.section, (int)indexPath.row, (unsigned int)_reloadTimes];
	SCTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	
	if (!cell) {
		SCTableViewDataHandler * handler = [self handler];
		NSAssert(handler, @"there must be a handler");
		
		NSDictionary * template = [handler cellTemplateForSection:indexPath.section];
		NSAssert(!template || [template isKindOfClass:[NSDictionary class]], @"cell template's definition error: %@", template);
		
		NSInteger totalCount = [handler numberOfRowsInSection:indexPath.section];
		
		UIGridTableView * gridTableView = (UIGridTableView *)tableView;
		NSAssert([gridTableView isKindOfClass:[UIGridTableView class]], @"parameters error: %@", tableView);
		CGFloat columnWidth = gridTableView.columnWidth;
		NSAssert(columnWidth > 0, @"column width error: %f", columnWidth);
		
		// 1. create an empty cell without content view
		NSMutableDictionary * md = [[NSMutableDictionary alloc] initWithDictionary:template];
		[md setObject:reuseIdentifier forKey:@"reuseIdentifier"];
		[md removeObjectForKey:@"contentView"];
		
		cell = [SCTableViewCell create:md];
		[SCTableViewCell resetCell:cell withTableView:tableView];
		NSAssert([cell isKindOfClass:[UITableViewCell class]], @"table view cell's definition error: %@", md);
		SC_UIKIT_SET_ATTRIBUTES(cell, SCTableViewCell, md);
		[md release];
		
		// 2. create cells in line
		NSDictionary * contentView = [template objectForKey:@"contentView"];
		NSUInteger start = indexPath.row * _countPerLine;
		NSUInteger end = start + _countPerLine;
		if (end > totalCount) {
			end = totalCount;
		}
		
		NSDictionary * item;
		SCView * view;
		CGPoint center;
		CGRect bounds;
		NSString * autoresizingMask;
		for (NSUInteger i = start; i < end; ++i) {
			item = [handler rowAtIndex:i sectionIndex:indexPath.section];
			if (contentView && ![item objectForKey:@"Class"]) {
				// when the item includes 'Class', means it is a UIView's definition,
				// not just a key-value data,
				// so we create it directly, no need replacing.
				item = [SCDictionary replaceDictionary:contentView withData:item];
			}
			NSAssert([item isKindOfClass:[NSDictionary class]], @"item not a dictionary: %@", item);
			
			view = [SCView create:item autorelease:NO];
			NSAssert([view isKindOfClass:[UIView class]], @"item error: %@", item);
			[cell.contentView addSubview:view];
			SC_UIKIT_SET_ATTRIBUTES(view, SCView, item);
			
			autoresizingMask = [item objectForKey:@"autoresizingMask"];
			if (autoresizingMask && (UIViewAutoresizingFromString(autoresizingMask) & UIViewAutoresizingFlexibleWidth)) {
				// resize it to fill the grid
				bounds = view.bounds;
				bounds.size.width = columnWidth;
				view.bounds = bounds;
			}
			// position it appropriately
			center = view.center;
			center.x = columnWidth * (i - start + 0.5);
			view.center = center;
			[view release];
		}
	}
	
	[reuseIdentifier release];
	return cell;
}

@end
