//
//  SCTextInputTraits.m
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCTextInputTraits.h"

//typedef NS_ENUM(NSInteger, UITextAutocapitalizationType) {
//    UITextAutocapitalizationTypeNone,
//    UITextAutocapitalizationTypeWords,
//    UITextAutocapitalizationTypeSentences,
//    UITextAutocapitalizationTypeAllCharacters,
//};
UITextAutocapitalizationType UITextAutocapitalizationTypeFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"All")
			return UITextAutocapitalizationTypeAllCharacters;
		SC_SWITCH_CASE(string, @"Sentences")
			return UITextAutocapitalizationTypeSentences;
		SC_SWITCH_CASE(string, @"Words")
			return UITextAutocapitalizationTypeWords;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return UITextAutocapitalizationTypeNone;
}

//typedef NS_ENUM(NSInteger, UITextAutocorrectionType) {
//    UITextAutocorrectionTypeDefault,
//    UITextAutocorrectionTypeNo,
//    UITextAutocorrectionTypeYes,
//};
UITextAutocorrectionType UITextAutocorrectionTypeFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Yes")
			return UITextAutocorrectionTypeYes;
		SC_SWITCH_CASE(string, @"No")
			return UITextAutocorrectionTypeYes;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return UITextAutocorrectionTypeDefault;
}

//typedef NS_ENUM(NSInteger, UITextSpellCheckingType) {
//    UITextSpellCheckingTypeDefault,
//    UITextSpellCheckingTypeNo,
//    UITextSpellCheckingTypeYes,
//} NS_ENUM_AVAILABLE_IOS(5_0);
UITextSpellCheckingType UITextSpellCheckingTypeFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Yes")
			return UITextSpellCheckingTypeYes;
		SC_SWITCH_CASE(string, @"No")
			return UITextSpellCheckingTypeNo;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return UITextSpellCheckingTypeDefault;
}

//typedef NS_ENUM(NSInteger, UIKeyboardType) {
//    UIKeyboardTypeDefault,                // Default type for the current input method.
//    UIKeyboardTypeASCIICapable,           // Displays a keyboard which can enter ASCII characters, non-ASCII keyboards remain active
//    UIKeyboardTypeNumbersAndPunctuation,  // Numbers and assorted punctuation.
//    UIKeyboardTypeURL,                    // A type optimized for URL entry (shows . / .com prominently).
//    UIKeyboardTypeNumberPad,              // A number pad (0-9). Suitable for PIN entry.
//    UIKeyboardTypePhonePad,               // A phone pad (1-9, *, 0, #, with letters under the numbers).
//    UIKeyboardTypeNamePhonePad,           // A type optimized for entering a person's name or phone number.
//    UIKeyboardTypeEmailAddress,           // A type optimized for multiple email address entry (shows space @ . prominently).
//#if __IPHONE_4_1 <= __IPHONE_OS_VERSION_MAX_ALLOWED
//    UIKeyboardTypeDecimalPad,             // A number pad with a decimal point.
//#endif
//#if __IPHONE_5_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED
//    UIKeyboardTypeTwitter,                // A type optimized for twitter text entry (easy access to @ #)
//#endif
//	
//    UIKeyboardTypeAlphabet = UIKeyboardTypeASCIICapable, // Deprecated
//	
//};
UIKeyboardType UIKeyboardTypeFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"ASCII")
			return UIKeyboardTypeASCIICapable;
		SC_SWITCH_CASE(string, @"NumbersAndPunctuation")
			return UIKeyboardTypeNumbersAndPunctuation;
		SC_SWITCH_CASE(string, @"URL")
			return UIKeyboardTypeURL;
		SC_SWITCH_CASE(string, @"Number")
			return UIKeyboardTypeNumberPad;
		SC_SWITCH_CASE(string, @"NamePhone")
			return UIKeyboardTypeNamePhonePad;
		SC_SWITCH_CASE(string, @"Phone")
			return UIKeyboardTypePhonePad;
		SC_SWITCH_CASE(string, @"Email")
			return UIKeyboardTypeEmailAddress;
#if __IPHONE_4_1 <= __IPHONE_OS_VERSION_MAX_ALLOWED
		SC_SWITCH_CASE(string, @"Decimal")
			return UIKeyboardTypeDecimalPad;
#endif
#if __IPHONE_5_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED
		SC_SWITCH_CASE(string, @"Twitter")
			return UIKeyboardTypeTwitter;
#endif
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return UIKeyboardTypeDefault;
}

//typedef NS_ENUM(NSInteger, UIKeyboardAppearance) {
//    UIKeyboardAppearanceDefault,          // Default apperance for the current input method.
//    UIKeyboardAppearanceAlert             // Appearance suitable for use in "alert" scenarios.
//};
UIKeyboardAppearance UIKeyboardAppearanceFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Alert")
			return UIKeyboardAppearanceAlert;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return UIKeyboardAppearanceDefault;
}

//typedef NS_ENUM(NSInteger, UIReturnKeyType) {
//    UIReturnKeyDefault,
//    UIReturnKeyGo,
//    UIReturnKeyGoogle,
//    UIReturnKeyJoin,
//    UIReturnKeyNext,
//    UIReturnKeyRoute,
//    UIReturnKeySearch,
//    UIReturnKeySend,
//    UIReturnKeyYahoo,
//    UIReturnKeyDone,
//    UIReturnKeyEmergencyCall,
//};
UIReturnKeyType UIReturnKeyTypeFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Google")
			return UIReturnKeyGoogle;
		SC_SWITCH_CASE(string, @"Go")
			return UIReturnKeyGo;
		SC_SWITCH_CASE(string, @"Join")
			return UIReturnKeyJoin;
		SC_SWITCH_CASE(string, @"Next")
			return UIReturnKeyNext;
		SC_SWITCH_CASE(string, @"Route")
			return UIReturnKeyRoute;
		SC_SWITCH_CASE(string, @"Search")
			return UIReturnKeySearch;
		SC_SWITCH_CASE(string, @"Send")
			return UIReturnKeySend;
		SC_SWITCH_CASE(string, @"Yahoo")
			return UIReturnKeyYahoo;
		SC_SWITCH_CASE(string, @"Done")
			return UIReturnKeyDone;
		SC_SWITCH_CASE(string, @"Emergency")
			return UIReturnKeyEmergencyCall;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return UIReturnKeyDefault;
}

@implementation SCTextInputTraits

+ (BOOL) setAttributes:(NSDictionary *)dict to:(id<UITextInputTraits>)textInputTraits
{
	NSAssert([dict isKindOfClass:[NSDictionary class]], @"parameters error: %@", dict);
	
	// autocapitalizationType
	NSString * autocapitalizationType = [dict objectForKey:@"autocapitalizationType"];
	if (autocapitalizationType) {
		textInputTraits.autocapitalizationType = UITextAutocapitalizationTypeFromString(autocapitalizationType);
	}
	
	// autocorrectionType
	NSString * autocorrectionType = [dict objectForKey:@"autocorrectionType"];
	if (autocorrectionType) {
		textInputTraits.autocorrectionType = UITextAutocorrectionTypeFromString(autocorrectionType);
	}
	
	// spellCheckingType
	NSString * spellCheckingType = [dict objectForKey:@"spellCheckingType"];
	if (spellCheckingType) {
		textInputTraits.spellCheckingType = UITextSpellCheckingTypeFromString(spellCheckingType);
	}
	
	// keyboardType
	NSString * keyboardType = [dict objectForKey:@"keyboardType"];
	if (keyboardType) {
		textInputTraits.keyboardType = UIKeyboardTypeFromString(keyboardType);
	}
	
	// keyboardAppearance
	NSString * keyboardAppearance = [dict objectForKey:@"keyboardAppearance"];
	if (keyboardAppearance) {
		textInputTraits.keyboardAppearance = UIKeyboardAppearanceFromString(keyboardAppearance);
	}
	
	// returnKeyType
	NSString * returnKeyType = [dict objectForKey:@"returnKeyType"];
	if (returnKeyType) {
		textInputTraits.returnKeyType = UIReturnKeyTypeFromString(returnKeyType);
	}
	
	// enablesReturnKeyAutomatically
	id enablesReturnKeyAutomatically = [dict objectForKey:@"enablesReturnKeyAutomatically"];
	if (enablesReturnKeyAutomatically) {
		textInputTraits.enablesReturnKeyAutomatically = [enablesReturnKeyAutomatically boolValue];
	}
	
	// secureTextEntry
	id secureTextEntry = [dict objectForKey:@"secureTextEntry"];
	if (secureTextEntry) {
		textInputTraits.secureTextEntry = [secureTextEntry boolValue];
	}
	
	return YES;
}

@end
