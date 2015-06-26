//
//  SCParagraphStyle.m
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCText.h"
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
		SC_SWITCH_CASE(string, @"WordWrap") // WordWrapping
			return NSLineBreakByWordWrapping;
		SC_SWITCH_CASE(string, @"CharWrap") // CharWrapping
			return NSLineBreakByCharWrapping;
		SC_SWITCH_CASE(string, @"Clip")     // Clipping
			return NSLineBreakByClipping;
		SC_SWITCH_CASE(string, @"Head")     // TruncatingHead
			return NSLineBreakByTruncatingHead;
		SC_SWITCH_CASE(string, @"Tail")     // TruncatingTail
			return NSLineBreakByTruncatingTail;
		SC_SWITCH_CASE(string, @"Mid")      // TruncatingMiddle
			return NSLineBreakByTruncatingMiddle;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

@implementation SCParagraphStyle

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	self = [self init];
	if (self) {
		[self setAttributes:dict];
	}
	return self;
}

// create:
SC_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

//@property(readwrite) CGFloat lineSpacing;
//@property(readwrite) CGFloat paragraphSpacing;
//@property(readwrite) NSTextAlignment alignment;
//@property(readwrite) CGFloat firstLineHeadIndent;
//@property(readwrite) CGFloat headIndent;
//@property(readwrite) CGFloat tailIndent;
//@property(readwrite) NSLineBreakMode lineBreakMode;
//@property(readwrite) CGFloat minimumLineHeight;
//@property(readwrite) CGFloat maximumLineHeight;
//@property(readwrite) NSWritingDirection baseWritingDirection;
//@property(readwrite) CGFloat lineHeightMultiple;
//@property(readwrite) CGFloat paragraphSpacingBefore;
//@property(readwrite) float hyphenationFactor;
//@property(readwrite,copy,NS_NONATOMIC_IOSONLY) NSArray *tabStops NS_AVAILABLE_IOS(7_0);
//@property(readwrite,NS_NONATOMIC_IOSONLY) CGFloat defaultTabInterval NS_AVAILABLE_IOS(7_0);
+ (BOOL) setAttributes:(NSDictionary *)dict to:(NSMutableParagraphStyle *)paragraphStyle
{
	NSAssert([dict isKindOfClass:[NSDictionary class]], @"parameters error: %@", dict);
	
	SC_SET_ATTRIBUTES_AS_FLOAT   (paragraphStyle, dict, lineSpacing);
	SC_SET_ATTRIBUTES_AS_FLOAT   (paragraphStyle, dict, paragraphSpacing);
	
	// alignment
	NSString * alignment = [dict objectForKey:@"alignment"];
	if (alignment) {
		paragraphStyle.alignment = NSTextAlignmentFromString(alignment);
	}
	
	SC_SET_ATTRIBUTES_AS_FLOAT   (paragraphStyle, dict, firstLineHeadIndent);
	SC_SET_ATTRIBUTES_AS_FLOAT   (paragraphStyle, dict, headIndent);
	SC_SET_ATTRIBUTES_AS_FLOAT   (paragraphStyle, dict, tailIndent);
	
	// lineBreakMode
	NSString * lineBreakMode = [dict objectForKey:@"lineBreakMode"];
	if (lineBreakMode) {
		paragraphStyle.lineBreakMode = NSLineBreakModeFromString(lineBreakMode);
	}
	
	SC_SET_ATTRIBUTES_AS_FLOAT   (paragraphStyle, dict, minimumLineHeight);
	SC_SET_ATTRIBUTES_AS_FLOAT   (paragraphStyle, dict, maximumLineHeight);
	
	// baseWritingDirection
	NSString * baseWritingDirection = [dict objectForKey:@"baseWritingDirection"];
	if (baseWritingDirection) {
		paragraphStyle.baseWritingDirection = NSWritingDirectionFromString(baseWritingDirection);
	}
	
	SC_SET_ATTRIBUTES_AS_FLOAT   (paragraphStyle, dict, lineHeightMultiple);
	SC_SET_ATTRIBUTES_AS_FLOAT   (paragraphStyle, dict, paragraphSpacingBefore);
	SC_SET_ATTRIBUTES_AS_FLOAT   (paragraphStyle, dict, hyphenationFactor);
	
	// tabStops
	
#ifdef __IPHONE_7_0
	SC_SET_ATTRIBUTES_AS_FLOAT   (paragraphStyle, dict, defaultTabInterval);
#endif
	
	return YES;
}

@end
