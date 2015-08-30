//
//  SCGeometry.h
//  SnowCat
//
//  Created by Moky on 15-1-1.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "SCUIKit.h"

UIKIT_EXTERN CGRect CGRectFromStringWithRects(NSString * string, CGRect selfFrame, CGRect parentBounds);
UIKIT_EXTERN CGSize CGSizeFromStringWithRects(NSString * string, CGRect selfFrame, CGRect parentBounds);
UIKIT_EXTERN CGPoint CGPointFromStringWithRects(NSString * string, CGRect selfFrame, CGRect parentBounds);

UIKIT_EXTERN CGRect CGRectFromStringWithNode(NSString * string, id node);
UIKIT_EXTERN CGSize CGSizeFromStringWithNode(NSString * string, id node);
UIKIT_EXTERN CGPoint CGPointFromStringWithNode(NSString * string, id node);
