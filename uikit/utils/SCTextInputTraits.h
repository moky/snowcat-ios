//
//  SCTextInputTraits.h
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCUIKit.h"

UIKIT_EXTERN UITextAutocapitalizationType UITextAutocapitalizationTypeFromString(NSString * string);
UIKIT_EXTERN UITextAutocorrectionType UITextAutocorrectionTypeFromString(NSString * string);

UIKIT_EXTERN UITextSpellCheckingType UITextSpellCheckingTypeFromString(NSString * string);

UIKIT_EXTERN UIKeyboardType UIKeyboardTypeFromString(NSString * string);
UIKIT_EXTERN UIKeyboardAppearance UIKeyboardAppearanceFromString(NSString * string);

UIKIT_EXTERN UIReturnKeyType UIReturnKeyTypeFromString(NSString * string);

@interface SCTextInputTraits : NSObject

+ (BOOL) setAttributes:(NSDictionary *)dict to:(id<UITextInputTraits>)textInputTraits;

@end
