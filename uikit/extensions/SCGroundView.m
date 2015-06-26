//
//  SCGroundView.m
//  SnowCat
//
//  Created by Moky on 15-1-27.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "SCNib.h"
#import "SCGeometry.h"
#import "SCView.h"
#import "SCGroundView.h"

@implementation SCGroundView

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib

- (void) dealloc
{
	self.nodeFile = nil;
	
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCGroundView
{
	_scTag = 0;
	self.nodeFile = nil;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCGroundView];
	}
	return self;
}

// default initializer
- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeSCGroundView];
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

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIGroundView *)groundView
{
	if (![SCView setAttributes:dict to:groundView]) {
		return NO;
	}
	
	// ground
	NSString * ground = [dict objectForKey:@"ground"];
	if (ground) {
		groundView.ground = CGRectFromStringWithNode(ground, groundView);
	}
	
	return YES;
}

@end
