//
//  SCCollectionViewCell.m
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCNib.h"
#import "SCCollectionViewCell.h"

@implementation SCCollectionViewCell

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib

- (void) dealloc
{
	[_nodeFile release];
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		_scTag = 0;
		self.nodeFile = nil;
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		_scTag = 0;
		self.nodeFile = nil;
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	self = [self initWithFrame:CGRectZero];
	if (self) {
		[self buildHandlers:dict];
	}
	return self;
}

// buildHandlers:
SC_UIKIT_IMELEMENT_BUILD_HANDLERS_FUNCTION()

// awakeFromNib
SC_UIKIT_IMPLEMENT_AWAKE_FUNCTION()

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UICollectionViewCell *)collectionViewCell
{
	if (![SCCollectionReusableView setAttributes:dict to:collectionViewCell]) {
		return NO;
	}
	
	// contentView
	NSDictionary * contentView = [dict objectForKey:@"contentView"];
	if (contentView) {
		SC_UIKIT_DIG_CREATION_INFO(contentView); // support ObjectFromFile
		SC_UIKIT_SET_ATTRIBUTES(collectionViewCell.contentView, SCView, contentView);
	}
	
	SC_SET_ATTRIBUTES_AS_BOOL(collectionViewCell, dict, selected);
	SC_SET_ATTRIBUTES_AS_BOOL(collectionViewCell, dict, highlighted);
	
	// backgroundView
	NSDictionary * backgroundView = [dict objectForKey:@"backgroundView"];
	if (backgroundView) {
		SC_UIKIT_DIG_CREATION_INFO(backgroundView); // support ObjectFromFile
		SCView * view = [SCView create:backgroundView];
		NSAssert([view isKindOfClass:[UIView class]], @"backgroundView's definition error: %@", backgroundView);
		collectionViewCell.backgroundView = view;
		SC_UIKIT_SET_ATTRIBUTES(view, SCView, backgroundView);
	}
	
	// selectedBackgroundView
	NSDictionary * selectedBackgroundView = [dict objectForKey:@"selectedBackgroundView"];
	if (selectedBackgroundView) {
		SC_UIKIT_DIG_CREATION_INFO(selectedBackgroundView); // support ObjectFromFile
		SCView * view = [SCView create:selectedBackgroundView];
		NSAssert([view isKindOfClass:[UIView class]], @"selectedBackgroundView's definition error: %@", selectedBackgroundView);
		collectionViewCell.selectedBackgroundView = view;
		SC_UIKIT_SET_ATTRIBUTES(view, SCView, selectedBackgroundView);
	}
	
	return YES;
}

@end
