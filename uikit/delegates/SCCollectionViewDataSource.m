//
//  SCCollectionViewDataSource.m
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCDictionary.h"
#import "SCCollectionViewCell.h"
#import "SCCollectionViewDataSource.h"

@implementation SCCollectionViewDataSource

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

- (void) reloadData:(UICollectionView *)collectionView
{
	NSAssert(_handler, @"there must be a handler");
	[_handler reloadData:nil];
}

#pragma mark - UICollectionViewDataSource

//@required

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	NSAssert(_handler, @"there must be a handler");
	return [_handler numberOfRowsInSection:section];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSAssert(_handler, @"there must be a handler");
	
	NSDictionary * template = [_handler cellTemplateForSection:indexPath.section];
	NSAssert(template, @"cell template not found");
	
	NSDictionary * row = [_handler rowAtIndex:indexPath.row sectionIndex:indexPath.section];
	NSAssert(!row || [row isKindOfClass:[NSDictionary class]], @"error row index: %d, section index: %d", (int)indexPath.row, (int)indexPath.section);
	NSDictionary * dict = [SCDictionary replaceDictionary:template withData:row];
	
	NSString * reuseIdentifier = [dict objectForKey:@"reuseIdentifier"];
	if (!reuseIdentifier) {
		reuseIdentifier = [dict objectForKey:@"Class"]; // use Class as reuse identifier
		if (!reuseIdentifier) {
			reuseIdentifier = @"SCCollectionViewCell";
		}
	}
	
	UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
	
	if ([cell.contentView.subviews count] == 0) {
		// empty cell
		SC_UIKIT_SET_ATTRIBUTES(cell, SCCollectionViewCell, dict);
	}
	
	return cell;
}

//@optional

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	NSAssert(_handler, @"there must be a handler");
	return [_handler numberOfSections];
}

//// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;

@end
