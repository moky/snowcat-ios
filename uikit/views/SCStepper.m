//
//  SCStepper.m
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCNib.h"
#import "SCColor.h"
#import "SCEventHandler.h"
#import "SCStepper.h"

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
	
	// continuous
	id continuous = [dict objectForKey:@"continuous"];
	if (continuous) {
		stepper.continuous = [continuous boolValue];
	}
	
	// autorepeat
	id autorepeat = [dict objectForKey:@"autorepeat"];
	if (autorepeat) {
		stepper.autorepeat = [autorepeat boolValue];
	}
	
	// wraps
	id wraps = [dict objectForKey:@"wraps"];
	if (wraps) {
		stepper.wraps = [wraps boolValue];
	}
	
	// value
	id value = [dict objectForKey:@"value"];
	if (value) {
		stepper.value = [value doubleValue];
	}
	
	// minimumValue
	id minimumValue = [dict objectForKey:@"minimumValue"];
	if (minimumValue) {
		stepper.minimumValue = [minimumValue doubleValue];
	}
	
	// maximumValue
	id maximumValue = [dict objectForKey:@"maximumValue"];
	if (maximumValue) {
		stepper.maximumValue = [maximumValue doubleValue];
	}
	
	// stepValue
	id stepValue = [dict objectForKey:@"stepValue"];
	if (stepValue) {
		stepper.stepValue = [stepValue doubleValue];
	}
	
	// tintColor
	NSDictionary * tintColor = [dict objectForKey:@"tintColor"];
	if (tintColor) {
		SCColor * color = [SCColor create:tintColor autorelease:NO];
		stepper.tintColor = color;
		[color release];
	}
	
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
