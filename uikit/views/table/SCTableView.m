//
//  SCTableView.m
//  SnowCat
//
//  Created by Moky on 14-3-18.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCClient.h"
#import "SCNib.h"
#import "SCColor.h"
#import "SCTableViewCell.h"
#import "SCTableViewDataSource.h"
#import "SCTableViewDelegate.h"
#import "SCTableView.h"

//typedef NS_ENUM(NSInteger, UITableViewStyle) {
//    UITableViewStylePlain,                  // regular table view
//    UITableViewStyleGrouped                 // preferences style table view
//};
UITableViewStyle UITableViewStyleFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Group") // Grouped
			return UITableViewStyleGrouped;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return UITableViewStylePlain;
}

//typedef NS_ENUM(NSInteger, UITableViewScrollPosition) {
//    UITableViewScrollPositionNone,
//    UITableViewScrollPositionTop,
//    UITableViewScrollPositionMiddle,
//    UITableViewScrollPositionBottom
//};                // scroll so row of interest is completely visible at top/center/bottom of view
UITableViewScrollPosition UITableViewScrollPositionFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Top")
			return UITableViewScrollPositionTop;
		SC_SWITCH_CASE(string, @"Middle")
			return UITableViewScrollPositionMiddle;
		SC_SWITCH_CASE(string, @"Bottom")
			return UITableViewScrollPositionBottom;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return UITableViewScrollPositionNone;
}

//typedef NS_ENUM(NSInteger, UITableViewRowAnimation) {
//    UITableViewRowAnimationFade,
//    UITableViewRowAnimationRight,           // slide in from right (or out to right)
//    UITableViewRowAnimationLeft,
//    UITableViewRowAnimationTop,
//    UITableViewRowAnimationBottom,
//    UITableViewRowAnimationNone,            // available in iOS 3.0
//    UITableViewRowAnimationMiddle,          // available in iOS 3.2.  attempts to keep cell centered in the space it will/did occupy
//    UITableViewRowAnimationAutomatic = 100  // available in iOS 5.0.  chooses an appropriate animation style for you
//};
UITableViewRowAnimation UITableViewRowAnimationFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Fade")
			return UITableViewRowAnimationFade;
		SC_SWITCH_CASE(string, @"Right")
			return UITableViewRowAnimationRight;
		SC_SWITCH_CASE(string, @"Left")
			return UITableViewRowAnimationLeft;
		SC_SWITCH_CASE(string, @"Top")
			return UITableViewRowAnimationTop;
		SC_SWITCH_CASE(string, @"Bottom")
			return UITableViewRowAnimationBottom;
		SC_SWITCH_CASE(string, @"None")
			return UITableViewRowAnimationNone;
		SC_SWITCH_CASE(string, @"Middle")
			return UITableViewRowAnimationMiddle;
		SC_SWITCH_CASE(string, @"Auto") // Automatic
			return UITableViewRowAnimationAutomatic;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

@interface SCTableView ()

@property(nonatomic, retain) SCTableViewDataSource * tableViewDataSource;
@property(nonatomic, retain) SCTableViewDelegate * tableViewDelegate;

@end

@implementation SCTableView

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib
@synthesize tableViewDataSource = _tableViewDataSource;
@synthesize tableViewDelegate = _tableViewDelegate;

- (void) dealloc
{
	[_tableViewDataSource release];
	[_tableViewDelegate release];
	[_nodeFile release];
	
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCTableView
{
	_scTag = 0;
	self.nodeFile = nil;
	
	self.tableViewDataSource = nil;
	self.tableViewDelegate = nil;
	
#ifdef __IPHONE_7_0
	
	CGFloat systemVersion = SCSystemVersion();
	if (systemVersion >= 7.0f) {
		self.separatorInset = UIEdgeInsetsZero;
	}
	
#endif
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCTableView];
	}
	return self;
}

// must specify style at creation. -initWithFrame: calls this with UITableViewStylePlain
- (instancetype) initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
	self = [super initWithFrame:frame style:style];
	if (self) {
		[self _initializeSCTableView];
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	NSInteger style = UITableViewStyleFromString([dict objectForKey:@"style"]);
	
	self = [self initWithFrame:CGRectZero style:style];
	if (self) {
		[self buildHandlers:dict];
	}
	return self;
}

// buildHandlers:
- (void) buildHandlers:(NSDictionary *)dict
{
	[SCResponder onCreate:self withDictionary:dict];
	
	NSDictionary * dataSource = [dict objectForKey:@"dataSource"];
	if (dataSource) {
		self.tableViewDataSource = [SCTableViewDataSource create:dataSource];
		// self.dataSource only assign but won't retain the data delegate,
		// so don't release it now
		self.dataSource = _tableViewDataSource;
	}
	
	NSDictionary * delegate = [dict objectForKey:@"delegate"];
	if (delegate) {
		self.tableViewDelegate = [SCTableViewDelegate create:delegate];
		// self.delegate only assign but won't retain the action delegate,
		// so don't release it now
		self.delegate = _tableViewDelegate;
	}
	
	// support using the SAME ONE data handler to service the data source and delegate
	if (_tableViewDelegate.handler == nil) {
		_tableViewDelegate.handler = _tableViewDataSource.handler;
	} else if (_tableViewDataSource.handler == nil) {
		_tableViewDataSource.handler = _tableViewDelegate.handler;
	}
}

// awakeFromNib
SC_UIKIT_IMPLEMENT_AWAKE_FUNCTION()

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) _setIOS7Attributes:(NSDictionary *)dict to:(UITableView *)tableView
{
#ifdef __IPHONE_7_0
	
	CGFloat systemVersion = SCSystemVersion();
	if (systemVersion < 7.0f) {
		return NO;
	}
	
	SC_SET_ATTRIBUTES_AS_FLOAT(tableView, dict, estimatedRowHeight);
	SC_SET_ATTRIBUTES_AS_FLOAT(tableView, dict, estimatedSectionHeaderHeight);
	SC_SET_ATTRIBUTES_AS_FLOAT(tableView, dict, estimatedSectionFooterHeight);
	
	SC_SET_ATTRIBUTES_AS_UIEDGEINSETS(tableView, dict, separatorInset);
	
	SC_SET_ATTRIBUTES_AS_UICOLOR(tableView, dict, sectionIndexBackgroundColor);
	
#endif
	return YES;
}

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UITableView *)tableView
{
	if (![SCScrollView setAttributes:dict to:tableView]) {
		SCLog(@"failed to set attributes: %@", dict);
		return NO;
	}
	
	SC_SET_ATTRIBUTES_AS_FLOAT(tableView, dict, rowHeight);
	SC_SET_ATTRIBUTES_AS_FLOAT(tableView, dict, sectionHeaderHeight);
	SC_SET_ATTRIBUTES_AS_FLOAT(tableView, dict, sectionFooterHeight);
	
	// backgroundView
	NSDictionary * backgroundView = [dict objectForKey:@"backgroundView"];
	if (backgroundView) {
		SC_UIKIT_DIG_CREATION_INFO(backgroundView); // support ObjectFromFile
		SCView * view = [SCView create:backgroundView autorelease:NO];
		NSAssert([view isKindOfClass:[UIView class]], @"backgroundView's definition error: %@", backgroundView);
		tableView.backgroundView = view;
		SC_UIKIT_SET_ATTRIBUTES(view, SCView, backgroundView);
		[view release];
	}
	
	SC_SET_ATTRIBUTES_AS_BOOL(tableView, dict, editing);
	SC_SET_ATTRIBUTES_AS_BOOL(tableView, dict, allowsSelection);
	SC_SET_ATTRIBUTES_AS_BOOL(tableView, dict, allowsSelectionDuringEditing);
	SC_SET_ATTRIBUTES_AS_BOOL(tableView, dict, allowsMultipleSelection);
	SC_SET_ATTRIBUTES_AS_BOOL(tableView, dict, allowsMultipleSelectionDuringEditing);
	
	SC_SET_ATTRIBUTES_AS_INTEGER(tableView, dict, sectionIndexMinimumDisplayRowCount);
	
	SC_SET_ATTRIBUTES_AS_UICOLOR(tableView, dict, sectionIndexColor);
	SC_SET_ATTRIBUTES_AS_UICOLOR(tableView, dict, sectionIndexTrackingBackgroundColor);
	
	// separatorStyle
	NSString * separatorStyle = [dict objectForKey:@"separatorStyle"];
	if (separatorStyle) {
		tableView.separatorStyle = UITableViewCellSeparatorStyleFromString(separatorStyle);
	}
	
	SC_SET_ATTRIBUTES_AS_UICOLOR(tableView, dict, separatorColor);
	
	// tableHeaderView
	NSDictionary * tableHeaderView = [dict objectForKey:@"tableHeaderView"];
	if (tableHeaderView) {
		SC_UIKIT_DIG_CREATION_INFO(tableHeaderView); // support ObjectFromFile
		SCView * view = [SCView create:tableHeaderView autorelease:NO];
		NSAssert([view isKindOfClass:[UIView class]], @"tableHeaderView's definition error: %@", tableHeaderView);
		tableView.tableHeaderView = view;
		SC_UIKIT_SET_ATTRIBUTES(view, SCView, tableHeaderView);
		tableView.tableHeaderView = view; // set it again to occupy the place
		[view release];
	}
	
	// tableFooterView
	NSDictionary * tableFooterView = [dict objectForKey:@"tableFooterView"];
	if (tableFooterView) {
		SC_UIKIT_DIG_CREATION_INFO(tableFooterView); // support ObjectFromFile
		SCView * view = [SCView create:tableFooterView autorelease:NO];
		NSAssert([view isKindOfClass:[UIView class]], @"tableFooterView's definition error: %@", tableFooterView);
		tableView.tableFooterView = view;
		SC_UIKIT_SET_ATTRIBUTES(view, SCView, tableFooterView);
		tableView.tableFooterView = view; // set it again to occupy the place
		[view release];
	}
	
#ifdef __IPHONE_7_0
	// (iOS 7.0)
	[self _setIOS7Attributes:dict to:tableView];
#endif
	
	return YES;
}

- (void) reloadData
{
	NSAssert(_tableViewDataSource, @"there must be a data source");
	[_tableViewDataSource reloadData:self];
	
	[_tableViewDelegate reloadData:self];
	
	[super reloadData];
}

@end
