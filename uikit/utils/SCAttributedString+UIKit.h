//
//  SCAttributedString+UIKit.h
//  SnowCat
//
//  Created by Moky on 15-5-14.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#include <UIKit/UIKit.h>

#import "SCAttributedString.h"

UIKIT_EXTERN NSString * const NSTextEffectStyleFromString(NSString * string);

UIKIT_EXTERN NSString * const NSAttributeNameFromString(NSString * string);
UIKIT_EXTERN id NSAttributeFromObject(id obj, NSString * const name);

@interface SCAttributedString (UIKit)

+ (NSDictionary *) attributesWithDictionary:(NSDictionary *)dict;

@end
