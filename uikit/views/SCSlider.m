//
//  SCSlider.m
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
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
		SCImage * image = [SCImage create:thumbImage];
		[slider setThumbImage:image forState:state];
	}
	
	// minimumTrackImage
	id minimumTrackImage = [dict objectForKey:@"minimumTrackImage"];
	if (minimumTrackImage) {
		SCImage * image = [SCImage create:minimumTrackImage];
		[slider setMinimumTrackImage:image forState:state];
	}
	
	// maximumTrackImage
	id maximumTrackImage = [dict objectForKey:@"maximumTrackImage"];
	if (maximumTrackImage) {
		SCImage * image = [SCImage create:maximumTrackImage];
		[slider setMaximumTrackImage:image forState:state];
	}
	
	return YES;
}

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UISlider *)slider
{
	if (![SCControl setAttributes:dict to:slider]) {
		return NO;
	}
	
	SC_SET_ATTRIBUTES_AS_FLOAT(slider, dict, value);
	SC_SET_ATTRIBUTES_AS_FLOAT(slider, dict, minimumValue);
	SC_SET_ATTRIBUTES_AS_FLOAT(slider, dict, maximumValue);
	
	SC_SET_ATTRIBUTES_AS_UIIMAGE(slider, dict, minimumValueImage);
	SC_SET_ATTRIBUTES_AS_UIIMAGE(slider, dict, maximumValueImage);
	
	SC_SET_ATTRIBUTES_AS_BOOL(slider, dict, continuous);
	
	SC_SET_ATTRIBUTES_AS_UICOLOR(slider, dict, minimumTrackTintColor);
	SC_SET_ATTRIBUTES_AS_UICOLOR(slider, dict, maximumTrackTintColor);
	SC_SET_ATTRIBUTES_AS_UICOLOR(slider, dict, thumbTintColor);
	
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
