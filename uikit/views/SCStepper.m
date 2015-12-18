//
//  SCStepper.m
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCNib.h"
#import "SCColor.h"
#import "SCEventHandler.h"
#import "SCStepper.h"

#if !TARGET_OS_TV

@implementation SCStepper

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib

- (void) dealloc
{
	[_nodeFile release];
	
	[self removeTarget:self action:@selector(onChange:) forControlEvents:UIControlEventValueChanged];
	
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCStepper
{
	_scTag = 0;
	self.nodeFile = nil;
	
	// Note that the target is not retained, so this assignment won't cause memory leaks
	[self addTarget:self action:@selector(onChange:) forControlEvents:UIControlEventValueChanged];
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCStepper];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeSCStepper];
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

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIStepper *)stepper
{
	if (![SCControl setAttributes:dict to:stepper]) {
		return NO;
	}
	
	SC_SET_ATTRIBUTES_AS_BOOL   (stepper, dict, continuous);
	SC_SET_ATTRIBUTES_AS_BOOL   (stepper, dict, autorepeat);
	SC_SET_ATTRIBUTES_AS_BOOL   (stepper, dict, wraps);
	SC_SET_ATTRIBUTES_AS_DOUBLE (stepper, dict, value);
	SC_SET_ATTRIBUTES_AS_DOUBLE (stepper, dict, minimumValue);
	SC_SET_ATTRIBUTES_AS_DOUBLE (stepper, dict, maximumValue);
	SC_SET_ATTRIBUTES_AS_DOUBLE (stepper, dict, stepValue);
	SC_SET_ATTRIBUTES_AS_UICOLOR(stepper, dict, tintColor);
	
	// TODO: set images...
	
	return YES;
}

#pragma mark - Value Event Interfaces

- (void) onChange:(id)sender
{
	SCLog(@"onChange: %@", sender);
	SCDoEvent(@"onChange", sender);
}

@end

#endif
