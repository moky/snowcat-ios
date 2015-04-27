//
//  SCTableViewController.m
//  SnowCat
//
//  Created by Moky on 14-3-18.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCLog.h"
#import "SCClient.h"
#import "SCDevice.h"
#import "SCApplication.h"
#import "SCNib.h"
#import "SCRefreshControl.h"
#import "SCTableView.h"
#import "SCTableViewController.h"

@interface SCTableViewController () {
	
	NSUInteger _supportedInterfaceOrientations;
}

@end

@implementation SCTableViewController

@synthesize scTag = _scTag;

- (void) dealloc
{
	[SCResponder onDestroy:self.view];
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCTableViewController
{
	_scTag = 0;
	_supportedInterfaceOrientations = SC_UIKIT_DEFAULT_SUPPORTED_INTERFACE_ORIENTATIONS;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCTableViewController];
	}
	return self;
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		[self _initializeSCTableViewController];
	}
	return self;
}

- (instancetype) initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	if (self) {
		[self _initializeSCTableViewController];
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	// initWithNibName:bundle:
	NSString * nibName = [SCNib nibNameFromDictionary:dict];
	
	if (nibName) {
		NSBundle * bundle = [SCNib bundleFromDictionary:dict autorelease:NO];
		self = [self initWithNibName:nibName bundle:bundle];
		[bundle release];
	} else {
		UITableViewStyle style = UITableViewStyleFromString([dict objectForKey:@"style"]);
		self = [self initWithStyle:style];
	}
	
	if (self) {
		[self buildHandlers:dict];
	}
	return self;
}

// buildHandlers:
SC_UIKIT_IMELEMENT_BUILD_HANDLERS_FUNCTION()

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_VIEW_CONTROLLER_IMPLEMENT_SET_ATTRIBUTES_WITH_ORIENTATIONS(_supportedInterfaceOrientations, @"supportedInterfaceOrientations")

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UITableViewController *)tableViewController
{
	if (![SCViewController setAttributes:dict to:tableViewController]) {
		SCLog(@"failed to set attributes: %@", dict);
		return NO;
	}
	
#ifdef __IPHONE_6_0
	CGFloat systemVersion = SCSystemVersion();
	if (systemVersion >= 6.0f) {
		// refreshControl
		NSDictionary * refreshControl = [dict objectForKey:@"refreshControl"];
		if (refreshControl) {
			SC_UIKIT_DIG_CREATION_INFO(refreshControl); // support ObjectFromFile
			SCRefreshControl * rc = [SCRefreshControl create:refreshControl autorelease:NO];
			NSAssert([rc isKindOfClass:[UIRefreshControl class]], @"refreshControl's definition error: %@", refreshControl);
			tableViewController.refreshControl = rc;
			SC_UIKIT_SET_ATTRIBUTES(rc, SCRefreshControl, refreshControl);
			[rc release];
		}
	}
#endif // EOF '__IPHONE_6_0'
	
	// tableView
	NSMutableDictionary * tableView = [dict objectForKey:@"tableView"];
	if (tableView) {
		NSDictionary * d = tableView;
		SC_UIKIT_DIG_CREATION_INFO(d); // support ObjectFromFile
		tableView = [d mutableCopy];
	} else {
		tableView = [[NSMutableDictionary alloc] initWithCapacity:2];
		
		NSDictionary * dataSource = [dict objectForKey:@"dataSource"];
		if (dataSource) {
			[tableView setObject:dataSource forKey:@"dataSource"];
		}
		NSDictionary * delegate = [dict objectForKey:@"delegate"];
		if (delegate) {
			[tableView setObject:delegate forKey:@"delegate"];
		}
	}
	SCTableView * tv = [SCTableView create:tableView autorelease:NO];
	NSAssert([tv isKindOfClass:[UITableView class]], @"tableView's definition error: %@", tableView);
	tableViewController.tableView = tv; // replace the default tableView
	SC_UIKIT_SET_ATTRIBUTES(tv, SCTableView, tableView);
	[tv release];
	[tableView release];
	
	// clearsSelectionOnViewWillAppear
	id clearsSelectionOnViewWillAppear = [dict objectForKey:@"clearsSelectionOnViewWillAppear"];
	if (clearsSelectionOnViewWillAppear) {
		tableViewController.clearsSelectionOnViewWillAppear = [clearsSelectionOnViewWillAppear boolValue];
	}
	
	return YES;
}

// view loading functions
SC_UIKIT_VIEW_CONTROLLER_IMPLEMENT_LOAD_VIEW_FUNCTIONS()

// Autorotate
SC_UIKIT_IMPLEMENT_AUTOROTATE_FUNCTIONS_WITH_PROPERTY(_supportedInterfaceOrientations)

@end
