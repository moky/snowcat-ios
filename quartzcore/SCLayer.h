//
//  SCLayer.h
//  SnowCat
//
//  Created by Moky on 14-8-6.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "SCObject.h"

#ifndef __IPHONE_8_0
typedef enum CAEdgeAntialiasingMask CAEdgeAntialiasingMask;
#endif

CA_EXTERN CAEdgeAntialiasingMask CAEdgeAntialiasingMaskFromString(NSString * string);
CA_EXTERN NSString * CAGravityFromString(NSString * string);
CA_EXTERN NSString * CAFilterNameFromString(NSString * string);

@interface SCLayer : CALayer<SCObject>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(CALayer *)layer;

@end
