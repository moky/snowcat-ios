//
//  SCCollectionReusableView.m
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCNib.h"
#import "SCCollectionViewLayoutAttributes.h"
#import "SCCollectionReusableView.h"

@implementation SCCollectionReusableView

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

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UICollectionReusableView *)collectionReusableView
{
	if (![SCView setAttributes:dict to:collectionReusableView]) {
		return NO;
	}
	
	// layoutAttributes
	NSDictionary * layoutAttributes = [dict objectForKey:@"layoutAttributes"];
	if (layoutAttributes) {
		SCCollectionViewLayoutAttributes * cvla = [SCCollectionViewLayoutAttributes create:layoutAttributes autorelease:NO];
		NSAssert([cvla isKindOfClass:[UICollectionViewLayoutAttributes class]], @"layout attributes's definition error: %@", layoutAttributes);
		[collectionReusableView applyLayoutAttributes:cvla];
		[cvla release];
	}
	
	return YES;
}

@end
