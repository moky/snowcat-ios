//
//  SCParticleView.h
//  SnowCat
//
//  Created by Moky on 14-12-31.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "SlanissueToolkit.h"

#import "SCUIKit.h"

@interface SCParticleView : UIParticleView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIParticleView *)particleView;

@end

@interface SCParticleView (Designer)

// use particle system data file to set attributes
+ (BOOL) setParticleAttributes:(NSDictionary *)dict toEmitterLayer:(CAEmitterLayer *)layer;
+ (BOOL) setParticleAttributes:(NSDictionary *)dict toEmitterCell:(CAEmitterCell *)cell;

@end
