//
//  SCGeometry.h
//  SnowCat
//
//  Created by Moky on 15-1-1.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>

CG_EXTERN CGRect CGRectFromStringWithRects(NSString * string, CGRect selfFrame, CGRect parentBounds);
CG_EXTERN CGSize CGSizeFromStringWithRects(NSString * string, CGRect selfFrame, CGRect parentBounds);
CG_EXTERN CGPoint CGPointFromStringWithRects(NSString * string, CGRect selfFrame, CGRect parentBounds);

CG_EXTERN CGRect CGRectFromStringWithNode(NSString * string, id node);
CG_EXTERN CGSize CGSizeFromStringWithNode(NSString * string, id node);
CG_EXTERN CGPoint CGPointFromStringWithNode(NSString * string, id node);
