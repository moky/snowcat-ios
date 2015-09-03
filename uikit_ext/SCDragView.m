//
//  SCDragView.m
//  SnowCat
//
//  Created by Moky on 14-11-14.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCNib.h"
#import "SCGeometry.h"
#import "SCGroundView.h"
#import "SCDragView.h"

@implementation SCDragView

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

+ (void) _checkGestures:(NSArray *)gestures with:(UIDragView *)dragView
{
	if (gestures) {
		NSString * name;
		SC_FOR_EACH(name, gestures) {
			if ([name isEqualToString:@"Pan"]) {
				return; // already add
			}
		}
	}
	[SCView addGestureRecognizerWithName:@"Pan" to:dragView];
}

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIDragView *)dragView
{
	if (![SCGroundView setAttributes:dict to:dragView]) {
		return NO;
	}
	
	// make sure the 'Pan' gesture has been added
	NSArray * gestures = [dict objectForKey:@"gestures"];
	[self _checkGestures:gestures with:dragView];
	
	return YES;
}

@end
