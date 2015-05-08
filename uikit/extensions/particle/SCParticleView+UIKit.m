//
//  UIParticleView.m
//  SnowCat
//
//  Created by Moky on 15-5-5.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "SCParticleView+UIKit.h"

@implementation UIParticleView

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		self.userInteractionEnabled = NO;
	}
	return self;
}

// default initializer
- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.userInteractionEnabled = NO;
	}
	return self;
}

+ (Class) layerClass
{
	return [CAEmitterLayer class];
}

- (CAEmitterLayer *) emitter
{
	NSAssert([self.layer isKindOfClass:[CAEmitterLayer class]], @"emitterLayer error: %@", self.layer);
	return (CAEmitterLayer *)[self layer];
}

- (CGPoint) emitterPosition
{
	return self.emitter.emitterPosition;
}

- (void) setEmitterPosition:(CGPoint)emitterPosition
{
	self.emitter.emitterPosition = emitterPosition;
}

@end