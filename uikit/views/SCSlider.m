//
//  SCSlider.m
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCLog.h"
#import "SCNib.h"
#import "SCColor.h"
#import "SCImage.h"
#import "SCEventHandler.h"
#import "SCSlider.h"

@implementation SCSlider

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib

- (void) dealloc
{
	[_nodeFile release];
	
	[self removeTarget:self action:@selector(onChange:) forControlEvents:UIControlEventValueChanged];
	
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCSlider
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
		[self _initializeSCSlider];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeSCSlider];
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

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UISlider *)slider forState:(UIControlState)state
{
	NSAssert([dict isKindOfClass:[NSDictionary class]], @"parameters error: %@", dict);
	
	// thumbImage
	id thumbImage = [dict objectForKey:@"thumbImage"];
	if (thumbImage) {
		SCImage * image = [SCImage create:thumbImage autorelease:NO];
		[slider setThumbImage:image forState:state];
		[image release];
	}
	
	// minimumTrackImage
	id minimumTrackImage = [dict objectForKey:@"minimumTrackImage"];
	if (minimumTrackImage) {
		SCImage * image = [SCImage create:minimumTrackImage autorelease:NO];
		[slider setMinimumTrackImage:image forState:state];
		[image release];
	}
	
	// maximumTrackImage
	id maximumTrackImage = [dict objectForKey:@"maximumTrackImage"];
	if (maximumTrackImage) {
		SCImage * image = [SCImage create:maximumTrackImage autorelease:NO];
		[slider setMaximumTrackImage:image forState:state];
		[image release];
	}
	
	return YES;
}

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UISlider *)slider
{
	if (![SCControl setAttributes:dict to:slider]) {
		return NO;
	}
	
	// value
	id value = [dict objectForKey:@"value"];
	if (value) {
		slider.value = [value floatValue];
	}
	
	// minimumValue
	id minimumValue = [dict objectForKey:@"minimumValue"];
	if (minimumValue) {
		slider.minimumValue = [minimumValue floatValue];
	}
	
	// maximumValue
	id maximumValue = [dict objectForKey:@"maximumValue"];
	if (maximumValue) {
		slider.maximumValue = [maximumValue floatValue];
	}
	
	// minimumValueImage
	NSDictionary * minimumValueImage = [dict objectForKey:@"minimumValueImage"];
	if (minimumValueImage) {
		SCImage * image = [SCImage create:minimumValueImage autorelease:NO];
		slider.minimumValueImage = image;
		[image release];
	}
	
	// maximumValueImage
	NSDictionary * maximumValueImage = [dict objectForKey:@"maximumValueImage"];
	if (maximumValueImage) {
		SCImage * image = [SCImage create:maximumValueImage autorelease:NO];
		slider.maximumValueImage = image;
		[image release];
	}
	
	// continuous
	id continuous = [dict objectForKey:@"continuous"];
	if (continuous) {
		slider.continuous = [continuous boolValue];
	}
	
	// minimumTrackTintColor
	id minimumTrackTintColor = [dict objectForKey:@"minimumTrackTintColor"];
	if (minimumTrackTintColor) {
		SCColor * color = [SCColor create:minimumTrackTintColor autorelease:NO];
		slider.minimumTrackTintColor = color;
		[color release];
	}
	
	// maximumTrackTintColor
	id maximumTrackTintColor = [dict objectForKey:@"maximumTrackTintColor"];
	if (maximumTrackTintColor) {
		SCColor * color = [SCColor create:maximumTrackTintColor autorelease:NO];
		slider.maximumTrackTintColor = color;
		[color release];
	}
	
	// thumbTintColor
	id thumbTintColor = [dict objectForKey:@"thumbTintColor"];
	if (thumbTintColor) {
		SCColor * color = [SCColor create:thumbTintColor autorelease:NO];
		slider.thumbTintColor = color;
		[color release];
	}
	
	// slider states
	NSDictionary * states = [dict objectForKey:@"states"];
	{
		// normal
		NSDictionary * normal = [states objectForKey:@"normal"];
		if (!normal) {
			normal = dict; // default values
		}
		[self setAttributes:normal to:slider forState:UIControlStateNormal];
		
		// highlighted
		NSDictionary * highlighted = [states objectForKey:@"highlighted"];
		if (highlighted) {
			[self setAttributes:highlighted to:slider forState:UIControlStateHighlighted];
		}
		
		// disabled
		NSDictionary * disabled = [states objectForKey:@"disabled"];
		if (disabled) {
			[self setAttributes:disabled to:slider forState:UIControlStateDisabled];
		}
		
		// selected
		NSDictionary * selected = [states objectForKey:@"selected"];
		if (selected) {
			[self setAttributes:selected to:slider forState:UIControlStateSelected];
		}
	}
	
	return YES;
}

#pragma mark - Value Event Interfaces

- (void) onChange:(id)sender
{
	SCLog(@"onChange: %@", sender);
	SCDoEvent(@"onChange", sender);
}

@end
