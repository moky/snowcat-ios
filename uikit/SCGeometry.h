//
//  SCGeometry.h
//  SnowCat
//
//  Created by Moky on 15-1-1.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "SCUIKit.h"

UIKIT_EXTERN CGSize CGSizeAspectFit(CGSize fromSize, CGSize toSize);
UIKIT_EXTERN CGSize CGSizeAspectFill(CGSize fromSize, CGSize toSize);

UIKIT_EXTERN CGRect CGRectFromStringWithNode(NSString * string, id node);
UIKIT_EXTERN CGSize CGSizeFromStringWithNode(NSString * string, id node);
UIKIT_EXTERN CGPoint CGPointFromStringWithNode(NSString * string, id node);

#pragma mark -

UIKIT_EXTERN CGRect CGRectGetFrameFromNode(id node);
UIKIT_EXTERN CGRect CGRectGetBoundsFromParentOfNode(id node);

#pragma mark - Siblings

UIKIT_EXTERN NSArray * SCSiblingsOfNode(id node);

UIKIT_EXTERN id SCPreviousSiblingOfNode(id node);
UIKIT_EXTERN id SCNextSiblingOfNode(id node);
