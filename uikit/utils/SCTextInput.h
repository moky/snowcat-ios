//
//  SCTextInput.h
//  SnowCat
//
//  Created by Moky on 14-4-3.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCTextInputTraits.h"

UIKIT_EXTERN UITextStorageDirection UITextStorageDirectionFromString(NSString * string);
UIKIT_EXTERN UITextLayoutDirection UITextLayoutDirectionFromString(NSString * string);
// UITextDirection
UIKIT_EXTERN UITextWritingDirection UITextWritingDirectionFromString(NSString * string);
UIKIT_EXTERN UITextGranularity UITextGranularityFromString(NSString * string);

@interface SCKeyInput : NSObject

+ (BOOL) setAttributes:(NSDictionary *)dict to:(id<UIKeyInput>)keyInput;

@end

@interface SCTextInput : NSObject

+ (BOOL) setAttributes:(NSDictionary *)dict to:(id<UITextInput>)textInput;

@end
