//
//  SCComplexTableView.m
//  SnowCat
//
//  Created by Moky on 14-12-30.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCClient.h"
#import "SCNib.h"
#import "SCComplexTableViewDataSource.h"
#import "SCComplexTableViewDelegate.h"
#import "SCComplexTableView.h"

@implementation UIComplexTableView

- (void) setFrame:(CGRect)frame
{
	[super setFrame:frame];
	
	if (frame.size.width > 0) {
		[self reloadData];
	}
}

@end

#pragma mark -

@interface SCComplexTableView ()

@property(nonatomic, retain) SCComplexTableViewDataSource * complexTableViewDataSource;
@property(nonatomic, retain) SCComplexTableViewDelegate * complexTableViewDelegate;

@end

@implementation SCComplexTableView

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib

@synthesize complexTableViewDataSource = _complexTableViewDataSource;
@synthesize complexTableViewDelegate = _complexTableViewDelegate;

- (void) dealloc
{
	[_complexTableViewDataSource release];
	[_complexTableViewDelegate release];
	
	[_nodeFile release];
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCComplexTableView
{
	_scTag = 0;
	self.nodeFile = nil;
	
	self.complexTableViewDataSource = nil;
	self.complexTableViewDelegate = nil;
	
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
		[self _initializeSCComplexTableView];
	}
	return self;
}

// must specify style at creation. -initWithFrame: calls this with UITableViewStylePlain
- (instancetype) initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
	self = [super initWithFrame:frame style:style];
	if (self) {
		[self _initializeSCComplexTableView];
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
		self.complexTableViewDataSource = [SCComplexTableViewDataSource create:dataSource];
		// self.dataSource only assign but won't retain the data delegate,
		// so don't release it now
		self.dataSource = _complexTableViewDataSource;
	}
	
	NSDictionary * delegate = [dict objectForKey:@"delegate"];
	if (delegate) {
		self.complexTableViewDelegate = [SCComplexTableViewDelegate create:delegate];
		// self.delegate only assign but won't retain the action delegate,
		// so don't release it now
		self.delegate = _complexTableViewDelegate;
	}
	
	// support using the SAME ONE data handler to service the data source and delegate
	if (_complexTableViewDelegate.handler == nil) {
		_complexTableViewDelegate.handler = _complexTableViewDataSource.handler;
	} else if (_complexTableViewDataSource.handler == nil) {
		_complexTableViewDataSource.handler = _complexTableViewDelegate.handler;
	}
}

// awakeFromNib
SC_UIKIT_IMPLEMENT_AWAKE_FUNCTION()

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIComplexTableView *)complexTableView
{
	if (![SCTableView setAttributes:dict to:complexTableView]) {
		return NO;
	}
	
	return YES;
}

- (void) reloadData
{
	NSAssert(_complexTableViewDataSource, @"there must be a data source");
	[_complexTableViewDataSource reloadData:self];
	
	[_complexTableViewDelegate reloadData:self];
	
	[super reloadData];
}

@end
