//
//  SCTextInput.m
//  SnowCat
//
//  Created by Moky on 14-4-3.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCTextInput.h"

//typedef NS_ENUM(NSInteger, UITextStorageDirection) {
//    UITextStorageDirectionForward = 0,
//    UITextStorageDirectionBackward
//};
UITextStorageDirection UITextStorageDirectionFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Forward")
			return UITextStorageDirectionForward;
		SC_SWITCH_CASE(string, @"Backward")
			return UITextStorageDirectionBackward;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

//typedef NS_ENUM(NSInteger, UITextLayoutDirection) {
//    UITextLayoutDirectionRight = 2,
//    UITextLayoutDirectionLeft,
//    UITextLayoutDirectionUp,
//    UITextLayoutDirectionDown
//};
UITextLayoutDirection UITextLayoutDirectionFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Right")
			return UITextLayoutDirectionRight;
		SC_SWITCH_CASE(string, @"Left")
			return UITextLayoutDirectionLeft;
		SC_SWITCH_CASE(string, @"Up")
			return UITextLayoutDirectionUp;
		SC_SWITCH_CASE(string, @"Down")
			return UITextLayoutDirectionDown;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

// UITextDirection

//typedef NS_ENUM(NSInteger, UITextWritingDirection) {
//    UITextWritingDirectionNatural = -1,
//    UITextWritingDirectionLeftToRight = 0,
//    UITextWritingDirectionRightToLeft,
//};
UITextWritingDirection UITextWritingDirectionFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Natural")
			return UITextWritingDirectionNatural;
		SC_SWITCH_CASE(string, @"LeftToRight")
			return UITextWritingDirectionLeftToRight;
		SC_SWITCH_CASE(string, @"RightToLeft")
			return UITextWritingDirectionRightToLeft;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

//typedef NS_ENUM(NSInteger, UITextGranularity) {
//    UITextGranularityCharacter,
//    UITextGranularityWord,
//    UITextGranularitySentence,
//    UITextGranularityParagraph,
//    UITextGranularityLine,
//    UITextGranularityDocument
//};
UITextGranularity UITextGranularityFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Character")
			return UITextGranularityCharacter;
		SC_SWITCH_CASE(string, @"Word")
			return UITextGranularityWord;
		SC_SWITCH_CASE(string, @"Sentence")
			return UITextGranularitySentence;
		SC_SWITCH_CASE(string, @"Paragraph")
			return UITextGranularityParagraph;
		SC_SWITCH_CASE(string, @"Line")
			return UITextGranularityLine;
		SC_SWITCH_CASE(string, @"Document")
			return UITextGranularityDocument;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

@implementation SCKeyInput

+ (BOOL) setAttributes:(NSDictionary *)dict to:(id<UIKeyInput>)keyInput
{
	if (![SCTextInputTraits setAttributes:dict to:keyInput]) {
		return NO;
	}
	
	return YES;
}

@end

@implementation SCTextInput

+ (BOOL) setAttributes:(NSDictionary *)dict to:(id<UITextInput>)textInput
{
	if (![SCKeyInput setAttributes:dict to:textInput]) {
		return NO;
	}
	
	// selectedTextRange
	
	// markedTextStyle
	
	// inputDelegate
	
	// selectionAffinity
	
	return YES;
}

@end
