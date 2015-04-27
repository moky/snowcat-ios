//
//  SCSplitViewController.m
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCDevice.h"
#import "SCApplication.h"
#import "SCNib.h"
#import "SCSplitViewControllerDelegate.h"
#import "SCSplitViewController.h"

@interface SCSplitViewController () {
	
	NSUInteger _supportedInterfaceOrientations;
}

@property(nonatomic, retain) id<SCSplitViewControllerDelegate> splitViewControllerDelegate;

@end

@implementation SCSplitViewController

@synthesize scTag = _scTag;
@synthesize splitViewControllerDelegate = _splitViewControllerDelegate;

- (void) dealloc
{
	[_splitViewControllerDelegate release];
	
	[SCResponder onDestroy:self.view];
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCSplitViewController
{
	_scTag = 0;
	_supportedInterfaceOrientations = SC_UIKIT_DEFAULT_SUPPORTED_INTERFACE_ORIENTATIONS;
	self.splitViewControllerDelegate = nil;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCSplitViewController];
	}
	return self;
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		[self _initializeSCSplitViewController];
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	// initWithNibName:bundle:
	NSString * nibName = [SCNib nibNameFromDictionary:dict];
	
	NSBundle * bundle = [SCNib bundleFromDictionary:dict autorelease:NO];
	self = [self initWithNibName:nibName bundle:bundle];
	[bundle release];
	
	if (self) {
		[self buildHandlers:dict];
	}
	return self;
}

// buildHandlers:
- (void) buildHandlers:(NSDictionary *)dict
{
	[SCResponder onCreate:self withDictionary:dict];
	
	NSDictionary * delegate = [dict objectForKey:@"delegate"];
	if (delegate) {
		self.splitViewControllerDelegate = [SCSplitViewControllerDelegate create:delegate];
		// self.delegate only assign but won't retain the action delegate,
		// so don't release it now
		self.delegate = _splitViewControllerDelegate;
	}
}

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_VIEW_CONTROLLER_IMPLEMENT_SET_ATTRIBUTES_WITH_ORIENTATIONS(_supportedInterfaceOrientations, @"supportedInterfaceOrientations")

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UISplitViewController *)splitViewController
{
	if (![SCViewController setAttributes:dict to:splitViewController]) {
		return NO;
	}
	
	// viewControllers
	NSArray * viewControllers = [dict objectForKey:@"viewControllers"];
	if (viewControllers) {
		NSAssert([viewControllers isKindOfClass:[NSArray class]], @"viewControllers must be an array: %@", viewControllers);
		NSMutableArray * mArray = [[NSMutableArray alloc] initWithCapacity:[viewControllers count]];
		
		NSEnumerator * enumerator = [viewControllers objectEnumerator];
		NSDictionary * item;
		SCViewController * child;
		while (item = [enumerator nextObject]) {
			NSAssert([item isKindOfClass:[NSDictionary class]], @"viewControllers's item must be a dictionary: %@", item);
			SC_UIKIT_DIG_CREATION_INFO(item); // support ObjectFromFile
			child = [SCViewController create:item autorelease:NO];
			NSAssert([child isKindOfClass:[UIViewController class]], @"viewControllers item's definition error: %@", item);
			if (child) {
				SC_UIKIT_SET_ATTRIBUTES(child, SCViewController, item);
				[mArray addObject:child];
				[child release];
			}
		}
		
		splitViewController.viewControllers = mArray;
		[mArray release];
	}
	
	// presentsWithGesture
	id presentsWithGesture = [dict objectForKey:@"presentsWithGesture"];
	if (presentsWithGesture) {
		splitViewController.presentsWithGesture = [presentsWithGesture boolValue];
	}
	
	return YES;
}

// view loading functions
SC_UIKIT_VIEW_CONTROLLER_IMPLEMENT_LOAD_VIEW_FUNCTIONS()

// Autorotate
SC_UIKIT_IMPLEMENT_AUTOROTATE_FUNCTIONS_WITH_PROPERTY(_supportedInterfaceOrientations)

@end
