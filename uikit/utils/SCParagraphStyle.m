//
//  SCParagraphStyle.m
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCParagraphStyle.h"

//typedef NS_ENUM(NSInteger, NSLineBreakMode) {		/* What to do with long lines */
//    NSLineBreakByWordWrapping = 0,     	/* Wrap at word boundaries, default */
//    NSLineBreakByCharWrapping,		/* Wrap at character boundaries */
//    NSLineBreakByClipping,		/* Simply clip */
//    NSLineBreakByTruncatingHead,	/* Truncate at head of line: "...wxyz" */
//    NSLineBreakByTruncatingTail,	/* Truncate at tail of line: "abcd..." */
//    NSLineBreakByTruncatingMiddle	/* Truncate middle of line:  "ab...yz" */
//} NS_ENUM_AVAILABLE_IOS(6_0);
NSLineBreakMode NSLineBreakModeFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"WordWrap")
			return NSLineBreakByWordWrapping;
		SC_SWITCH_CASE(string, @"CharWrap")
			return NSLineBreakByCharWrapping;
		SC_SWITCH_CASE(string, @"Clip")
			return NSLineBreakByClipping;
		SC_SWITCH_CASE(string, @"Head")
			return NSLineBreakByTruncatingHead;
		SC_SWITCH_CASE(string, @"Tail")
			return NSLineBreakByTruncatingTail;
		SC_SWITCH_CASE(string, @"Mid")
			return NSLineBreakByTruncatingMiddle;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}
