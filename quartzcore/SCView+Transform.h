//
//  SCView+Transform.h
//  SnowCat
//
//  Created by Moky on 14-7-9.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Transform2D)

// scale
- (void) scaleWithScale:(CGFloat)scale;
- (void) scaleWithScaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY;

// rotate
- (void) rotateWithRotation:(CGFloat)rotation;

@end

@interface UIView (Transform3D)

// reset the view's transform to Identity
- (void) resetTransform;

// rotating around axis X
- (void) pitchWithRotation:(CGFloat)radians;
// rotating around axis Y
- (void) rollWithRotation:(CGFloat)radians;
// rotating around axis Z
- (void) yawWithRotation:(CGFloat)radians;

@end
