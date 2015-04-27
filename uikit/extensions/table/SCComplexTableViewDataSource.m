//
//  SCComplexTableViewDataSource.m
//  SnowCat
//
//  Created by Moky on 14-12-30.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCDictionary.h"
#import "SCTableViewCell.h"
#import "SCComplexTableViewDataSource.h"

@interface SCComplexTableViewDataSource () {
	
	NSUInteger _reloadTimes; // once reloadData call, _reloadTimes++
}

@end

@implementation SCComplexTableViewDataSource

- (instancetype) init
{
	self = [super init];
	if (self) {
		_reloadTimes = 0;
	}
	return self;
}

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

- (void) reloadData:(UITableView *)tableView
{
	[super reloadData:tableView];
	++_reloadTimes;
}

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	SCTableViewDataHandler * handler = [self handler];
	NSAssert(handler, @"there must be a handler");
	
	NSDictionary * template = [handler cellTemplateForSection:section];
	NSAssert(!template || [template isKindOfClass:[NSDictionary class]], @"cell template's definition error: %@", template);
	
	NSInteger totalCount = [handler numberOfRowsInSection:section];
	
	NSString * size = [[template objectForKey:@"contentView"] objectForKey:@"size"];
	CGSize s = CGSizeFromString(size);
	if (s.width < 1) {
		return totalCount;
	}
	
	int cpl = floor(tableView.bounds.size.width / s.width); // count per line
	NSAssert(cpl > 0, @"error");
	return ceil((float)totalCount / cpl);
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	SCTableViewDataHandler * handler = [self handler];
	NSAssert(handler, @"there must be a handler");
	
	NSDictionary * template = [handler cellTemplateForSection:indexPath.section];
	NSAssert(!template || [template isKindOfClass:[NSDictionary class]], @"cell template's definition error: %@", template);
	
	NSString * size = [[template objectForKey:@"contentView"] objectForKey:@"size"];
	CGSize s = CGSizeFromString(size);
	int cpl = s.width < 1 ? 1 : floor(tableView.bounds.size.width / s.width); // count per line
	NSAssert(cpl > 0, @"error");
	
	if (cpl == 1) {
		// single cell in each row
		return [super tableView:tableView cellForRowAtIndexPath:indexPath];
	}
	
	// multi cells in each row
	
	NSString * reuseIdentifier = [[NSString alloc] initWithFormat:@"<%d,%d|%u>", (int)indexPath.section, (int)indexPath.row, (unsigned int)_reloadTimes];
	SCTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	
	if (!cell) {
		NSInteger totalCount = [handler numberOfRowsInSection:indexPath.section];
		
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
		NSUInteger start = indexPath.row * cpl;
		NSUInteger end = start + cpl;
		if (end > totalCount) {
			end = totalCount;
		}
		
		CGFloat columnWidth = tableView.bounds.size.width / cpl;
		
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
