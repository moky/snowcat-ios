//
//  SCParticleView.m
//  SnowCat
//
//  Created by Moky on 14-12-31.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCDictionary.h"
#import "SCNib.h"
#import "SCEmitterLayer.h"
#import "SCView.h"
#import "SCParticleView.h"

@implementation SCParticleView

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

// default initializer
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

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIParticleView *)particleView
{
	if (![SCView setAttributes:dict to:particleView]) {
		return NO;
	}
	
	// 1. load from 'File' (ParticleSystem data format)
	NSString * file = [dict objectForKey:@"File"];
	if (file) {
		SCLog(@"loading particle system data from file: %@ (Designer)", file);
		NSDictionary * data = [SCDictionary dictionaryWithContentsOfFile:file];
		CAEmitterLayer * emitter = [particleView emitter];
		NSAssert([emitter isKindOfClass:[CAEmitterLayer class]], @"emitter error: %@", emitter);
		[self setParticleAttributes:data toEmitterLayer:emitter];
	}
	
	// 2. set extra attributes
	NSDictionary * emitterLayer = [dict objectForKey:@"emitterLayer"];
	if (!emitterLayer) {
		emitterLayer = [dict objectForKey:@"emitter"];
	}
	if (emitterLayer) {
		CAEmitterLayer * emitter = [particleView emitter];
		NSAssert([emitter isKindOfClass:[CAEmitterLayer class]], @"emitter error: %@", emitter);
		SC_UIKIT_SET_ATTRIBUTES(emitter, SCEmitterLayer, emitterLayer);
	}
	
	return YES;
}

@end
