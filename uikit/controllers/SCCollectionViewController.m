//
//  SCCollectionViewController.m
//  SnowCat
//
//  Created by Moky on 14-4-9.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCDevice.h"
#import "SCApplication.h"
#import "SCNib.h"
#import "SCCollectionViewLayout.h"
#import "SCCollectionView.h"
#import "SCCollectionViewController.h"

@interface SCCollectionViewController () {
	
	NSUInteger _supportedInterfaceOrientations;
}

@end

@implementation SCCollectionViewController

@synthesize scTag = _scTag;

- (void) dealloc
{
	[SCResponder onDestroy:self.view];
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCCollectionViewController
{
	_scTag = 0;
	_supportedInterfaceOrientations = SC_UIKIT_DEFAULT_SUPPORTED_INTERFACE_ORIENTATIONS;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCCollectionViewController];
	}
	return self;
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		[self _initializeSCCollectionViewController];
	}
	return self;
}

- (instancetype) initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
	self = [super initWithCollectionViewLayout:layout];
	if (self) {
		[self _initializeSCCollectionViewController];
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
		NSDictionary * layout = [dict objectForKey:@"layout"];
		NSAssert([layout isKindOfClass:[NSDictionary class]], @"layout must be a dictionary: %@", dict);
		
		SCCollectionViewLayout * cvl = [SCCollectionViewLayout create:layout autorelease:NO];
		NSAssert([cvl isKindOfClass:[UICollectionViewLayout class]], @"layout's definition error: %@", layout);
		SC_UIKIT_SET_ATTRIBUTES(cvl, SCCollectionViewLayout, layout);
		
		self = [self initWithCollectionViewLayout:cvl];
		[cvl release];
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

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UICollectionViewController *)collectionViewController
{
	if (![SCViewController setAttributes:dict to:collectionViewController]) {
		return NO;
	}
	
	// collectionView
	NSMutableDictionary * collectionView = [dict objectForKey:@"collectionView"];
	if (collectionView) {
		NSDictionary * d = collectionView;
		SC_UIKIT_DIG_CREATION_INFO(d); // support ObjectFromFile
		collectionView = [d mutableCopy];
	} else {
		collectionView = [[NSMutableDictionary alloc] initWithCapacity:3];
	}
	if (collectionView) {
		// layout
		if (![collectionView objectForKey:@"layout"]) {
			NSDictionary * layout = [dict objectForKey:@"layout"];
			if (layout) {
				[collectionView setObject:layout forKey:@"layout"];
			}
		}
		// dataSource
		if (![collectionView objectForKey:@"dataSource"]) {
			NSDictionary * dataSource = [dict objectForKey:@"dataSource"];
			if (dataSource) {
				[collectionView setObject:dataSource forKey:@"dataSource"];
			}
		}
		// delegate
		if (![collectionView objectForKey:@"delegate"]) {
			NSDictionary * delegate = [dict objectForKey:@"delegate"];
			if (delegate) {
				[collectionView setObject:delegate forKey:@"delegate"];
			}
		}
		
		// create it
		SCCollectionView * cv = [SCCollectionView create:collectionView autorelease:NO];
		NSAssert([cv isKindOfClass:[UICollectionView class]], @"collectionView's definition error: %@", collectionView);
		collectionViewController.collectionView = cv; // replace the default collectionView
		SC_UIKIT_SET_ATTRIBUTES(cv, SCCollectionView, collectionView);
		[cv release];
		
		[collectionView release];
	}
	
	// clearsSelectionOnViewWillAppear
	id clearsSelectionOnViewWillAppear = [dict objectForKey:@"clearsSelectionOnViewWillAppear"];
	if (clearsSelectionOnViewWillAppear) {
		collectionViewController.clearsSelectionOnViewWillAppear = [clearsSelectionOnViewWillAppear boolValue];
	}
	
	return YES;
}

// view loading functions
SC_UIKIT_VIEW_CONTROLLER_IMPLEMENT_LOAD_VIEW_FUNCTIONS()

// Autorotate
SC_UIKIT_IMPLEMENT_AUTOROTATE_FUNCTIONS_WITH_PROPERTY(_supportedInterfaceOrientations)

@end
