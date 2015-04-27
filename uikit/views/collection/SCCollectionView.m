//
//  SCCollectionView.m
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCLog.h"
#import "SCNib.h"
#import "SCCollectionViewLayout.h"
#import "SCCollectionViewDataSource.h"
#import "SCCollectionViewDelegate.h"
#import "SCCollectionView.h"

//typedef NS_OPTIONS(NSUInteger, UICollectionViewScrollPosition) {
//    UICollectionViewScrollPositionNone                 = 0,
//    
//    // The vertical positions are mutually exclusive to each other, but are bitwise or-able with the horizontal scroll positions.
//    // Combining positions from the same grouping (horizontal or vertical) will result in an NSInvalidArgumentException.
//    UICollectionViewScrollPositionTop                  = 1 << 0,
//    UICollectionViewScrollPositionCenteredVertically   = 1 << 1,
//    UICollectionViewScrollPositionBottom               = 1 << 2,
//    
//    // Likewise, the horizontal positions are mutually exclusive to each other.
//    UICollectionViewScrollPositionLeft                 = 1 << 3,
//    UICollectionViewScrollPositionCenteredHorizontally = 1 << 4,
//    UICollectionViewScrollPositionRight                = 1 << 5
//};
UICollectionViewScrollPosition UICollectionViewScrollPositionFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"None")
			return UICollectionViewScrollPositionNone;
		SC_SWITCH_CASE(string, @"Top")
			return UICollectionViewScrollPositionTop;
		SC_SWITCH_CASE(string, @"Vertical")
			return UICollectionViewScrollPositionCenteredVertically;
		SC_SWITCH_CASE(string, @"Bottom")
			return UICollectionViewScrollPositionBottom;
		SC_SWITCH_CASE(string, @"Left")
			return UICollectionViewScrollPositionLeft;
		SC_SWITCH_CASE(string, @"Horizontal")
			return UICollectionViewScrollPositionCenteredHorizontally;
		SC_SWITCH_CASE(string, @"Right")
			return UICollectionViewScrollPositionRight;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

@interface SCCollectionView ()

@property(nonatomic, retain) SCCollectionViewDataSource * collectionViewDataSource;
@property(nonatomic, retain) SCCollectionViewDelegate * collectionViewDelegate;

@end

@implementation SCCollectionView

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib
@synthesize collectionViewDataSource = _collectionViewDataSource;
@synthesize collectionViewDelegate = _collectionViewDelegate;

- (void) dealloc
{
	[_collectionViewDataSource release];
	[_collectionViewDelegate release];
	
	[_nodeFile release];
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCCollectionView
{
	_scTag = 0;
	self.nodeFile = nil;
	
	self.collectionViewDataSource = nil;
	self.collectionViewDelegate = nil;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCCollectionView];
	}
	return self;
}

// the designated initializer
- (instancetype) initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
	self = [super initWithFrame:frame collectionViewLayout:layout];
	if (self) {
		[self _initializeSCCollectionView];
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	NSDictionary * layout = [dict objectForKey:@"collectionViewLayout"];
	if (!layout) {
		layout = [dict objectForKey:@"layout"];
	}
	if (layout) {
		SCCollectionViewLayout * cvl = [SCCollectionViewLayout create:layout autorelease:NO];
		NSAssert([cvl isKindOfClass:[UICollectionViewLayout class]], @"collection view layout's definition error: %@", layout);
		self = [self initWithFrame:CGRectZero collectionViewLayout:cvl];
		SC_UIKIT_SET_ATTRIBUTES(cvl, SCCollectionViewLayout, layout);
		[cvl release];
	} else {
		self = [self initWithFrame:CGRectZero collectionViewLayout:nil];
	}
	
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
		self.collectionViewDataSource = [SCCollectionViewDataSource create:dataSource];
		// self.dataSource only assign but won't retain the data delegate,
		// so don't release it now
		self.dataSource = _collectionViewDataSource;
	}
	
	NSDictionary * delegate = [dict objectForKey:@"delegate"];
	if (delegate) {
		self.collectionViewDelegate = [SCCollectionViewDelegate create:delegate];
		// self.delegate only assign but won't retain the action delegate,
		// so don't release it now
		self.delegate = _collectionViewDelegate;
	}
	
	// support using the SAME ONE data handler to service the data source and delegate
	if (_collectionViewDelegate.handler == nil) {
		_collectionViewDelegate.handler = _collectionViewDataSource.handler;
	} else if (_collectionViewDataSource.handler == nil) {
		_collectionViewDataSource.handler = _collectionViewDelegate.handler;
	}
}

// awakeFromNib
SC_UIKIT_IMPLEMENT_AWAKE_FUNCTION()

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UICollectionView *)collectionView
{
	if (![SCScrollView setAttributes:dict to:collectionView]) {
		SCLog(@"failed to set attributes: %@", dict);
		return NO;
	}
	
	// backgroundView
	NSDictionary * backgroundView = [dict objectForKey:@"backgroundView"];
	if (backgroundView) {
		SC_UIKIT_DIG_CREATION_INFO(backgroundView); // support ObjectFromFile
		SCView * view = [SCView create:backgroundView autorelease:NO];
		NSAssert([view isKindOfClass:[UIView class]], @"backgroundView's definition error: %@", view);
		collectionView.backgroundView = view;
		SC_UIKIT_SET_ATTRIBUTES(view, SCView, backgroundView);
		[view release];
	}
	
	// allowsSelection
	id allowsSelection = [dict objectForKey:@"allowsSelection"];
	if (allowsSelection) {
		collectionView.allowsSelection = [allowsSelection boolValue];
	}
	
	// allowsMultipleSelection
	id allowsMultipleSelection = [dict objectForKey:@"allowsMultipleSelection"];
	if (allowsMultipleSelection) {
		collectionView.allowsMultipleSelection = [allowsMultipleSelection boolValue];
	}
	
	// reuseIdentifiers
	NSArray * reuseIdentifiers = [dict objectForKey:@"reuseIdentifiers"];
	if (reuseIdentifiers) {
		if ([reuseIdentifiers containsObject:@"SCCollectionViewCell"]) {
			[reuseIdentifiers retain];
		} else {
			NSMutableArray * mArray = [reuseIdentifiers mutableCopy];
			[mArray addObject:@"SCCollectionViewCell"];
			reuseIdentifiers = mArray;
		}
	} else {
		reuseIdentifiers = [[NSArray alloc] initWithObjects:@"SCCollectionViewCell", nil];
	}
	if (reuseIdentifiers) {
		NSEnumerator * enumerator = [reuseIdentifiers objectEnumerator];
		NSString * name;
		Class class;
		while (name = [enumerator nextObject]) {
			class = NSClassFromString(name);
			if (!class) {
				name = [[NSString alloc] initWithFormat:@"SC%@", name]; // add prefix 'SC'
				class = NSClassFromString(name);
				[name release];
			}
			NSAssert(class, @"reuse identifier class error: %@", name);
			[collectionView registerClass:class forCellWithReuseIdentifier:name];
		}
		[reuseIdentifiers release];
	}
	
	return YES;
}

- (void) reloadData
{
	[_collectionViewDataSource reloadData:self];
	
	[super reloadData];
}

@end
