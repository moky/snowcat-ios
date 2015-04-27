//
//  SCTransition.h
//  SnowCat
//
//  Created by Moky on 14-3-27.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "SCObject.h"

@class CAMediaTimingFunction;
@class UIView;

CA_EXTERN CAMediaTimingFunction * CAMediaTimingFunctionFromString(NSString * string);
CA_EXTERN NSString * const CAFillModeFromString(NSString * string);
CA_EXTERN NSString * const CATransitionTypeFromString(NSString * string);
CA_EXTERN NSString * const CATransitionSubtypeFromString(NSString * string);

@interface SCTransition : SCObject

- (void) runWithView:(UIView *)view;

@end
