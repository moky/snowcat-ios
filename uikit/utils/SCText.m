//
//  SCText.m
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCText.h"

//typedef NS_ENUM(NSInteger, NSTextAlignment) {
//    NSTextAlignmentLeft      = 0,    // Visually left aligned
//#if TARGET_OS_IPHONE
//    NSTextAlignmentCenter    = 1,    // Visually centered
//    NSTextAlignmentRight     = 2,    // Visually right aligned
//#else /* !TARGET_OS_IPHONE */
//    NSTextAlignmentRight     = 1,    // Visually right aligned
//    NSTextAlignmentCenter    = 2,    // Visually centered
//#endif
//    NSTextAlignmentJustified = 3,    // Fully-justified. The last line in a paragraph is natural-aligned.
//    NSTextAlignmentNatural   = 4,    // Indicates the default alignment for script
//} NS_ENUM_AVAILABLE_IOS(6_0);
NSTextAlignment NSTextAlignmentFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Left")
			return NSTextAlignmentLeft;
		SC_SWITCH_CASE(string, @"Right")
			return NSTextAlignmentRight;
		SC_SWITCH_CASE(string, @"Center")
			return NSTextAlignmentCenter;
		SC_SWITCH_CASE(string, @"Justified")
			return NSTextAlignmentJustified;
		SC_SWITCH_CASE(string, @"Natural")
			return NSTextAlignmentNatural;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

//typedef NS_ENUM(NSInteger, NSWritingDirection) {
//    NSWritingDirectionNatural       = -1,    // Determines direction using the Unicode Bidi Algorithm rules P2 and P3
//    NSWritingDirectionLeftToRight   =  0,    // Left to right writing direction
//    NSWritingDirectionRightToLeft   =  1     // Right to left writing direction
//} NS_ENUM_AVAILABLE_IOS(6_0);
NSWritingDirection NSWritingDirectionFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Natural")
			return NSWritingDirectionNatural;
		SC_SWITCH_CASE(string, @"LeftToRight")
			return NSWritingDirectionLeftToRight;
		SC_SWITCH_CASE(string, @"RightToLeft")
			return NSWritingDirectionRightToLeft;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}
