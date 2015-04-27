//
//  SCView+Geometry.h
//  SnowCat
//
//  Created by Moky on 14-11-11.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCView.h"

@interface SCView (Geometry)

+ (BOOL) setGeometryAttributes:(NSDictionary *)dict to:(UIView *)view;

// input size: view.frame.size
+ (CGSize) sizeThatFits:(CGSize)size to:(UIView *)view;

// calculating relative position
+ (CGPoint) centerFromDictionary:(NSDictionary *)dict withView:(UIView *)view;

@end
