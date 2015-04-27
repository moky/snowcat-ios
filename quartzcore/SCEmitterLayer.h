//
//  SCEmitterLayer.h
//  SnowCat
//
//  Created by Moky on 14-12-31.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

CA_EXTERN NSString * CAEmitterShapeFromString(NSString * string);
CA_EXTERN NSString * CAEmitterModeFromString(NSString * string);
CA_EXTERN NSString * CARenderModeFromString(NSString * string);

@interface SCEmitterLayer : CAEmitterLayer<SCObject>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(CAEmitterLayer *)emitterLayer;

@end
