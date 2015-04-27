//
//  SCParticleView.h
//  SnowCat
//
//  Created by Moky on 14-12-31.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCView.h"

@class CAEmitterLayer;

@interface UIParticleView : UIView

@property(nonatomic, readonly) CAEmitterLayer * emitter;
@property(nonatomic, readwrite) CGPoint emitterPosition;

@end

#pragma mark -

@interface SCParticleView : UIParticleView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIParticleView *)particleView;

@end

@interface SCParticleView (Cocos2D)

// use particle system data file to set attributes
+ (BOOL) setParticleAttributes:(NSDictionary *)dict toEmitterLayer:(CAEmitterLayer *)layer;
+ (BOOL) setParticleAttributes:(NSDictionary *)dict toEmitterCell:(CAEmitterCell *)cell;

@end
