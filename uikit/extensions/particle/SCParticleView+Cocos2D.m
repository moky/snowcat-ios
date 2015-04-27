//
//  SCParticleView+Cocos2D.m
//  SnowCat
//
//  Created by Moky on 15-1-2.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "SCParticleView.h"

@implementation SCParticleView (Cocos2D)

// emitterCells
// birthRate
// lifetime
// emitterPosition
// emitterZPosition
// emitterSize
// emitterDepth
// emitterShape
// emitterMode
// renderMode
// preservesDepth
// velocity
// scale
// spin
// seed
+ (BOOL) setParticleAttributes:(NSDictionary *)dict toEmitterLayer:(CAEmitterLayer *)layer
{
	
	return YES;
}

// name
// enabled
// birthRate
// lifetime
// lifetimeRange
// emissionLatitude
// emissionLongitude
// emissionRange
// velocity
// velocityRange
// xAcceleration
// yAcceleration
// zAcceleration
// scale
// scaleRange
// scaleSpeed
// spin
// spinRange
// color
// redRange
// greenRange
// blueRange
// alphaRange
// redSpeed
// greenSpeed
// blueSpeed
// alphaSpeed
// contents
// contentsRect
// minificationFilter
// magnificationFilter
// minificationFilterBias
// emitterCells
// style
+ (BOOL) setParticleAttributes:(NSDictionary *)dict toEmitterCell:(CAEmitterCell *)cell
{
	
	return YES;
}

@end
