//
//  SCTableViewDelegate.m
//  SnowCat
//
//  Created by Moky on 14-3-18.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCView.h"
#import "SCScrollRefreshControl.h"
#import "SCScrollViewDelegate.h"
#import "SCTableViewCell.h"
#import "SCTableViewDelegate.h"

@implementation SCTableViewDelegate

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
	
	SCScrollRefreshControlReloadData(tableView);
}

#pragma mark - UITableViewDelegate

//@optional
//
//// Display customization
//
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);
//- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);
//- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath NS_AVAILABLE_IOS(6_0);
//- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);
//- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);

// Variable height support

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSAssert(_handler, @"there must be a handler");
	
	// return height for row
	NSDictionary * row = [_handler rowAtIndex:indexPath.row sectionIndex:indexPath.section];
	id height = [row objectForKey:@"height"];
	if (height) {
		return [height floatValue];
	}
	
	// return row height for section
	NSDictionary * section = [_handler sectionAtIndex:indexPath.section];
	id rowHeight = [section objectForKey:@"rowHeight"];
	if (rowHeight) {
		return [rowHeight floatValue];
	}
	
	// return row height for table view
	return tableView.rowHeight;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
	NSAssert(_handler, @"there must be a handler");
	
	// return header height for section
	NSDictionary * section = [_handler sectionAtIndex:sectionIndex];
	id headerHeight = [section objectForKey:@"headerHeight"];
	if (headerHeight) {
		return [headerHeight floatValue];
	}
	
	// return section footer height for table view
	return tableView.sectionHeaderHeight;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)sectionIndex
{
	NSAssert(_handler, @"there must be a handler");
	
	// return footer height for section
	NSDictionary * section = [_handler sectionAtIndex:sectionIndex];
	id footerHeight = [section objectForKey:@"footerHeight"];
	if (footerHeight) {
		return [footerHeight floatValue];
	}
	
	// return section footer height for table view
	return tableView.sectionFooterHeight;
}

// Use the estimatedHeight methods to quickly calcuate guessed values which will allow for fast load times of the table.
// If these methods are implemented, the above -tableView:heightForXXX calls will be deferred until views are ready to be displayed, so more expensive logic can be placed there.
- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(7_0)
{
	NSAssert(_handler, @"there must be a handler");
	
	// return estimated height for row
	NSDictionary * row = [_handler rowAtIndex:indexPath.row sectionIndex:indexPath.section];
	id estimatedHeight = [row objectForKey:@"estimatedHeight"];
	if (estimatedHeight) {
		return [estimatedHeight floatValue];
	}
	
	// return estimated row height for section
	NSDictionary * section = [_handler sectionAtIndex:indexPath.section];
	id estimatedRowHeight = [section objectForKey:@"estimatedRowHeight"];
	if (estimatedRowHeight) {
		return [estimatedRowHeight floatValue];
	}
	
	// patch:
	//   use 'height' instead while 'estimatedHeight' not found
	id height = [row objectForKey:@"height"];
	if (height) {
		return [height floatValue];
	}
	//   use 'rowHeight' instead while 'estimatedRowHeight' not found
	id rowHeight = [section objectForKey:@"rowHeight"];
	if (rowHeight) {
		return [rowHeight floatValue];
	}
	
	// return estimated row height for table view
	return tableView.estimatedRowHeight > 0.0f ? tableView.estimatedRowHeight : tableView.rowHeight;
}

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)sectionIndex NS_AVAILABLE_IOS(7_0)
{
	NSAssert(_handler, @"there must be a handler");
	
	// return estimated header height for section
	NSDictionary * section = [_handler sectionAtIndex:sectionIndex];
	id estimatedHeaderHeight = [section objectForKey:@"estimatedHeaderHeight"];
	if (estimatedHeaderHeight) {
		return [estimatedHeaderHeight floatValue];
	}
	
	// patch:
	//   use 'headerHeight' instead while 'estimatedHeaderHeight' not found
	id headerHeight = [section objectForKey:@"headerHeight"];
	if (headerHeight) {
		return [headerHeight floatValue];
	}
	
	// return estimated section header height for table view
	return tableView.estimatedSectionHeaderHeight > 0.0f ? tableView.estimatedSectionHeaderHeight : tableView.sectionHeaderHeight;
}

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)sectionIndex NS_AVAILABLE_IOS(7_0)
{
	NSAssert(_handler, @"there must be a handler");
	
	// return estimated footer height for section
	NSDictionary * section = [_handler sectionAtIndex:sectionIndex];
	id estimatedFooterHeight = [section objectForKey:@"estimatedFooterHeight"];
	if (estimatedFooterHeight) {
		return [estimatedFooterHeight floatValue];
	}
	
	// patch:
	//   use 'footerHeight' instead while 'estimatedFooterHeight' not found
	id footerHeight = [section objectForKey:@"footerHeight"];
	if (footerHeight) {
		return [footerHeight floatValue];
	}
	
	// return estimated section footer height for table view
	return tableView.estimatedSectionFooterHeight > 0.0f ? tableView.estimatedSectionFooterHeight : tableView.sectionFooterHeight;
}

// Section header & footer information. Views are preferred over title should you decide to provide both

// custom view for header. will be adjusted to default or specified header height
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
	NSAssert(_handler, @"there must be a handler");
	
	NSDictionary * section = [_handler sectionAtIndex:sectionIndex];
	NSDictionary * headerView = [section objectForKey:@"headerView"];
	if (headerView) {
		SCView * view = [SCView create:headerView];
		NSAssert([view isKindOfClass:[UIView class]], @"headerView's definition error: %@", headerView);
		[tableView addSubview:view];
		SC_UIKIT_SET_ATTRIBUTES(view, SCView, headerView);
		[view removeFromSuperview];
		return view;
	}
	
	return nil;
}

// custom view for footer. will be adjusted to default or specified footer height
- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)sectionIndex
{
	NSAssert(_handler, @"there must be a handler");
	
	NSDictionary * section = [_handler sectionAtIndex:sectionIndex];
	NSDictionary * footerView = [section objectForKey:@"footerView"];
	if (footerView) {
		SCView * view = [SCView create:footerView];
		NSAssert([view isKindOfClass:[UIView class]], @"footerView's definition error: %@", footerView);
		[tableView addSubview:view];
		SC_UIKIT_SET_ATTRIBUTES(view, SCView, footerView);
		[view removeFromSuperview];
		return view;
	}
	
	return nil;
}

//// Accessories (disclosures).
//
//- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath NS_DEPRECATED_IOS(2_0, 3_0);
//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;
//
//// Selection
//
//// -tableView:shouldHighlightRowAtIndexPath: is called when a touch comes down on a row.
//// Returning NO to that message halts the selection process and does not cause the currently selected row to lose its selected look while the touch is down.
//- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0);
//- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0);
//- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0);
//
//// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
//- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0);
//// Called after the user changes the selection.
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0);
//
//// Editing
//
//// Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSAssert(_handler, @"there must be a handler");
	
	// return editing style for row
	NSDictionary * row = [_handler rowAtIndex:indexPath.row sectionIndex:indexPath.section];
	NSString * editingStyle = [row objectForKey:@"editingStyle"];
	if (editingStyle) {
		return UITableViewCellEditingStyleFromString(editingStyle);
	}
	
	// return editing style for section
	NSDictionary * section = [_handler sectionAtIndex:indexPath.section];
	editingStyle = [section objectForKey:@"editingStyle"];
	if (editingStyle) {
		return UITableViewCellEditingStyleFromString(editingStyle);
	}
	
	// return default editing style for table view
	return UITableViewCellEditingStyleDelete;
}

//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0);

// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
- (BOOL) tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSAssert(_handler, @"there must be a handler");
	
	// return value for row
	NSDictionary * row = [_handler rowAtIndex:indexPath.row sectionIndex:indexPath.section];
	NSString * shouldIndentWhileEditing = [row objectForKey:@"shouldIndentWhileEditing"];
	if (shouldIndentWhileEditing) {
		return [shouldIndentWhileEditing boolValue];
	}
	
	// return value for section
	NSDictionary * section = [_handler sectionAtIndex:indexPath.section];
	shouldIndentWhileEditing = [section objectForKey:@"shouldIndentWhileEditing"];
	if (shouldIndentWhileEditing) {
		return [shouldIndentWhileEditing boolValue];
	}
	
	// return default value for table view
	return YES;
}

//// The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
//- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath;
//- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath;
//
//// Moving/reordering
//
//// Allows customization of the target row for a particular row as it is being moved/reordered
//- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath;
//
//// Indentation
//
//- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath; // return 'depth' of row for hierarchies
//
//// Copy/Paste.  All three methods must be implemented by the delegate.
//
//- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(5_0);
//- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender NS_AVAILABLE_IOS(5_0);
//- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender NS_AVAILABLE_IOS(5_0);

#pragma mark - UIScrollViewDelegate

//@optional
//
// any offset changes
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
	SCScrollRefreshControlDidScroll(scrollView);
}

//- (void)scrollViewDidZoom:(UIScrollView *)scrollView NS_AVAILABLE_IOS(3_2); // any zoom scale changes
//
// called on start of dragging (may require some time and or distance to move)
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	SCScrollRefreshControlWillBeginDragging(scrollView);
}

//// called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0);
// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	SCScrollRefreshControlDidEndDragging(scrollView);
}

//
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;   // called on finger up as we are moving
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;      // called when scroll view grinds to a halt
//
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView; // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
//
//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;     // return a view that will be scaled. if delegate returns nil, nothing happens
//- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view NS_AVAILABLE_IOS(3_2); // called before the scroll view begins zooming its content
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale; // scale between minimum and maximum. called after any 'bounce' animations
//
//- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView;   // return a yes if you want to scroll to the top. if not defined, assumes YES
//- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView;      // called when scrolling animation finished. may be called immediately if already at top

@end
