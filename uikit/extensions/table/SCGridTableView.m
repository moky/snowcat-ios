//
//  SCGridTableView.m
//  SnowCat
//
//  Created by Moky on 14-4-23.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCClient.h"
#import "SCNib.h"
#import "SCGridTableViewDataSource.h"
#import "SCGridTableViewDelegate.h"
#import "SCGridTableView.h"

@implementation UIGridTableView

@synthesize columnWidth = _columnWidth;

- (void) _initializeUIGridTableView
{
	// default attributes
	self.allowsSelection = NO;
	self.allowsSelectionDuringEditing = NO;
	self.allowsMultipleSelection = NO;
	self.allowsMultipleSelectionDuringEditing = NO;
	self.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	_columnWidth = self.bounds.size.width;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeUIGridTableView];
	}
	return self;
}

// must specify style at creation. -initWithFrame: calls this with UITableViewStylePlain
- (instancetype) initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
	self = [super initWithFrame:frame style:style];
	if (self) {
		[self _initializeUIGridTableView];
	}
	return self;
}

- (void) setFrame:(CGRect)frame
{
	CGFloat width = self.frame.size.width;
	[super setFrame:frame];
	
	if (frame.size.width > 0 && _columnWidth > 0 &&
		floor(width / _columnWidth) != floor(frame.size.width / _columnWidth)) {
		[self reloadData];
	}
}

@end

#pragma mark -

@interface SCGridTableView ()

@property(nonatomic, retain) SCGridTableViewDataSource * gridTableViewDataSource;
@property(nonatomic, retain) SCGridTableViewDelegate * gridTableViewDelegate;

@end

@implementation SCGridTableView

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib

@synthesize gridTableViewDataSource = _gridTableViewDataSource;
@synthesize gridTableViewDelegate = _gridTableViewDelegate;

- (void) dealloc
{
	[_gridTableViewDataSource release];
	[_gridTableViewDelegate release];
	
	[_nodeFile release];
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCGridTableView
{
	_scTag = 0;
	self.nodeFile = nil;
	
	self.gridTableViewDataSource = nil;
	self.gridTableViewDelegate = nil;
	
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
		[self _initializeSCGridTableView];
	}
	return self;
}

// must specify style at creation. -initWithFrame: calls this with UITableViewStylePlain
- (instancetype) initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
	self = [super initWithFrame:frame style:style];
	if (self) {
		[self _initializeSCGridTableView];
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
		self.gridTableViewDataSource = [SCGridTableViewDataSource create:dataSource];
		// self.dataSource only assign but won't retain the data delegate,
		// so don't release it now
		self.dataSource = _gridTableViewDataSource;
	}
	
	NSDictionary * delegate = [dict objectForKey:@"delegate"];
	if (delegate) {
		self.gridTableViewDelegate = [SCGridTableViewDelegate create:delegate];
		// self.delegate only assign but won't retain the action delegate,
		// so don't release it now
		self.delegate = _gridTableViewDelegate;
	}
	
	// support using the SAME ONE data handler to service the data source and delegate
	if (_gridTableViewDelegate.handler == nil) {
		_gridTableViewDelegate.handler = _gridTableViewDataSource.handler;
	} else if (_gridTableViewDataSource.handler == nil) {
		_gridTableViewDataSource.handler = _gridTableViewDelegate.handler;
	}
}

// awakeFromNib
SC_UIKIT_IMPLEMENT_AWAKE_FUNCTION()

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIGridTableView *)gridTableView
{
	if (![SCTableView setAttributes:dict to:gridTableView]) {
		return NO;
	}
	
	// columnWidth
	id columnWidth = [dict objectForKey:@"columnWidth"];
	if (columnWidth) {
		gridTableView.columnWidth = [columnWidth floatValue];
	} else {
		gridTableView.columnWidth = gridTableView.bounds.size.width;
	}
	
	return YES;
}

- (void) reloadData
{
	NSAssert(_gridTableViewDataSource, @"there must be a data source");
	[_gridTableViewDataSource updateGrid:self];
	[_gridTableViewDataSource reloadData:self];
	
	[_gridTableViewDelegate reloadData:self];
	
	[super reloadData];
}

@end
