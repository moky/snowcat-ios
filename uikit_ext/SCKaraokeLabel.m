//
//  SCKaraokeLabel.m
//  SnowCat
//
//  Created by Moky on 15-11-12.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "SCNib.h"
#import "SCView.h"
#import "SCKaraokeLabel.h"

@implementation SCKaraokeLabel

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

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIKaraokeLabel *)karaokeView
{
	if (![SCView setAttributes:dict to:karaokeView]) {
		return NO;
	}
	
	// progress
	NSString * progress = [dict objectForKey:@"progress"];
	if (progress) {
		karaokeView.progress = [progress floatValue];
	}
	
	return YES;
}

@end
