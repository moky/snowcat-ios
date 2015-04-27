//
//  SCTouchParticleView.h
//  SnowCat
//
//  Created by Moky on 15-1-1.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "SCParticleView.h"

@interface SCTouchParticleView : SCParticleView

// store 'birthRate' for emitter
@property(nonatomic, readwrite) CGFloat birthRate;

@end
