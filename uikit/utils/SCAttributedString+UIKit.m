//
//  SCAttributedString+UIKit.m
//  SnowCat
//
//  Created by Moky on 15-5-14.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCParagraphStyle.h"
#import "SCShadow.h"
#import "SCTextAttachment.h"
#import "SCURL.h"
#import "SCFont.h"
#import "SCColor.h"
#import "SCAttributedString+UIKit.h"

NSString * const NSTextEffectStyleFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Letterpress")
			return NSTextEffectLetterpressStyle;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	// only this effect (iOS 7.0)
	return NSTextEffectLetterpressStyle;
}

NSArray * NSTextWritingDirectionsFromString(NSString * string)
{
	NSInteger direction = 0;
	
	if ([string rangeOfString:@"LeftToRight"].location != NSNotFound) {
		direction |= NSWritingDirectionLeftToRight;
	}
	if ([string rangeOfString:@"RightToLeft"].location != NSNotFound) {
		direction |= NSWritingDirectionRightToLeft;
	}
	
	if ([string rangeOfString:@"Embedding"].location != NSNotFound) {
		direction |= NSTextWritingDirectionEmbedding;
	}
	if ([string rangeOfString:@"Override"].location != NSNotFound) {
		direction |= NSTextWritingDirectionOverride;
	}
	
	return [NSArray arrayWithObject:[NSNumber numberWithInteger:direction]];
}

/************************ Attributes ************************/

/* Predefined character attributes for text. If the key is not in the dictionary, then use the default values as described below.
 */
//UIKIT_EXTERN NSString *const NSFontAttributeName NS_AVAILABLE_IOS(6_0);                // UIFont, default Helvetica(Neue) 12
//UIKIT_EXTERN NSString *const NSParagraphStyleAttributeName NS_AVAILABLE_IOS(6_0);      // NSParagraphStyle, default defaultParagraphStyle
//UIKIT_EXTERN NSString *const NSForegroundColorAttributeName NS_AVAILABLE_IOS(6_0);     // UIColor, default blackColor
//UIKIT_EXTERN NSString *const NSBackgroundColorAttributeName NS_AVAILABLE_IOS(6_0);     // UIColor, default nil: no background
//UIKIT_EXTERN NSString *const NSLigatureAttributeName NS_AVAILABLE_IOS(6_0);            // NSNumber containing integer, default 1: default ligatures, 0: no ligatures
//UIKIT_EXTERN NSString *const NSKernAttributeName NS_AVAILABLE_IOS(6_0);                // NSNumber containing floating point value, in points; amount to modify default kerning. 0 means kerning is disabled.
//UIKIT_EXTERN NSString *const NSStrikethroughStyleAttributeName NS_AVAILABLE_IOS(6_0);  // NSNumber containing integer, default 0: no strikethrough
//UIKIT_EXTERN NSString *const NSUnderlineStyleAttributeName NS_AVAILABLE_IOS(6_0);      // NSNumber containing integer, default 0: no underline
//UIKIT_EXTERN NSString *const NSStrokeColorAttributeName NS_AVAILABLE_IOS(6_0);         // UIColor, default nil: same as foreground color
//UIKIT_EXTERN NSString *const NSStrokeWidthAttributeName NS_AVAILABLE_IOS(6_0);         // NSNumber containing floating point value, in percent of font point size, default 0: no stroke; positive for stroke alone, negative for stroke and fill (a typical value for outlined text would be 3.0)
//UIKIT_EXTERN NSString *const NSShadowAttributeName NS_AVAILABLE_IOS(6_0);              // NSShadow, default nil: no shadow
//UIKIT_EXTERN NSString *const NSTextEffectAttributeName NS_AVAILABLE_IOS(7_0);          // NSString, default nil: no text effect
//
//UIKIT_EXTERN NSString *const NSAttachmentAttributeName NS_AVAILABLE_IOS(7_0);          // NSTextAttachment, default nil
//UIKIT_EXTERN NSString *const NSLinkAttributeName NS_AVAILABLE_IOS(7_0);                // NSURL (preferred) or NSString
//UIKIT_EXTERN NSString *const NSBaselineOffsetAttributeName NS_AVAILABLE_IOS(7_0);      // NSNumber containing floating point value, in points; offset from baseline, default 0
//UIKIT_EXTERN NSString *const NSUnderlineColorAttributeName NS_AVAILABLE_IOS(7_0);      // UIColor, default nil: same as foreground color
//UIKIT_EXTERN NSString *const NSStrikethroughColorAttributeName NS_AVAILABLE_IOS(7_0);  // UIColor, default nil: same as foreground color
//UIKIT_EXTERN NSString *const NSObliquenessAttributeName NS_AVAILABLE_IOS(7_0);         // NSNumber containing floating point value; skew to be applied to glyphs, default 0: no skew
//UIKIT_EXTERN NSString *const NSExpansionAttributeName NS_AVAILABLE_IOS(7_0);           // NSNumber containing floating point value; log of expansion factor to be applied to glyphs, default 0: no expansion
//
//UIKIT_EXTERN NSString *const NSWritingDirectionAttributeName NS_AVAILABLE_IOS(7_0);    // NSArray of NSNumbers representing the nested levels of writing direction overrides as defined by Unicode LRE, RLE, LRO, and RLO characters.  The control characters can be obtained by masking NSWritingDirection and NSTextWritingDirection values.  LRE: NSWritingDirectionLeftToRight|NSTextWritingDirectionEmbedding, RLE: NSWritingDirectionRightToLeft|NSTextWritingDirectionEmbedding, LRO: NSWritingDirectionLeftToRight|NSTextWritingDirectionOverride, RLO: NSWritingDirectionRightToLeft|NSTextWritingDirectionOverride,
//
//UIKIT_EXTERN NSString *const NSVerticalGlyphFormAttributeName NS_AVAILABLE_IOS(6_0);   // An NSNumber containing an integer value.  0 means horizontal text.  1 indicates vertical text.  If not specified, it could follow higher-level vertical orientation settings.  Currently on iOS, it's always horizontal.  The behavior for any other value is undefined.

NSString * const NSAttributeNameFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
#ifdef __IPHONE_6_0
		//----------------------------------------------------------------------
		SC_SWITCH_CASE(string, @"Font")
			return NSFontAttributeName;
		SC_SWITCH_CASE(string, @"Paragraph") // ParagraphStyle
			return NSParagraphStyleAttributeName;
		SC_SWITCH_CASE(string, @"BackgroundColor")
			return NSBackgroundColorAttributeName;
		SC_SWITCH_CASE(string, @"Ligature")
			return NSLigatureAttributeName;
		SC_SWITCH_CASE(string, @"Kern")
			return NSKernAttributeName;
		SC_SWITCH_CASE(string, @"StrokeColor")
			return NSStrokeColorAttributeName;
		SC_SWITCH_CASE(string, @"StrokeWidth")
			return NSStrokeWidthAttributeName;
		SC_SWITCH_CASE(string, @"Shadow")
			return NSShadowAttributeName;
#ifdef __IPHONE_7_0
		SC_SWITCH_CASE(string, @"TextEffect")
			return NSTextEffectAttributeName;
		SC_SWITCH_CASE(string, @"Attachment")
			return NSAttachmentAttributeName;
		SC_SWITCH_CASE(string, @"Link")
			return NSLinkAttributeName;
		SC_SWITCH_CASE(string, @"BaselineOffset")
			return NSBaselineOffsetAttributeName;
		SC_SWITCH_CASE(string, @"UnderlineColor")
			return NSUnderlineColorAttributeName;
		SC_SWITCH_CASE(string, @"StrikethroughColor")
			return NSStrikethroughColorAttributeName;
		SC_SWITCH_CASE(string, @"Obliqueness")
			return NSObliquenessAttributeName;
		SC_SWITCH_CASE(string, @"Expansion")
			return NSExpansionAttributeName;
		SC_SWITCH_CASE(string, @"WritingDirection")
			return NSWritingDirectionAttributeName;
#endif // __IPHONE_7_0
		SC_SWITCH_CASE(string, @"VerticalGlyphForm")
			return NSVerticalGlyphFormAttributeName;
		//----------------------------------------------------------------------
		SC_SWITCH_CASE(string, @"Color")              // ForegroundColor
			return NSForegroundColorAttributeName;
		SC_SWITCH_CASE(string, @"VerticalForm")       // VerticalGlyphForm
			return NSVerticalGlyphFormAttributeName;
		SC_SWITCH_CASE(string, @"Strikethrough")      // StrikethroughStyle
			return NSStrikethroughStyleAttributeName;
		SC_SWITCH_CASE(string, @"Underline")          // UnderlineStyle
			return NSUnderlineStyleAttributeName;
#endif // __IPHONE_6_0
		//----------------------------------------------------------------------
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return string;
}

id NSAttributeFromObject(id obj, NSString * const name)
{
	SC_SWITCH_BEGIN(name)
		//----------------------------------------------------------------------
		SC_SWITCH_CASE(name, @"Font")
			return [SCFont create:obj];
		SC_SWITCH_CASE(name, @"Paragraph") // ParagraphStyle
			return [SCParagraphStyle create:obj];
		SC_SWITCH_CASE(name, @"Shadow")
			return [SCShadow create:obj];
		SC_SWITCH_CASE(name, @"TextEffect")
			return NSTextEffectStyleFromString(obj);
		SC_SWITCH_CASE(name, @"Attachment")
			return [SCTextAttachment create:obj];
		SC_SWITCH_CASE(name, @"Link")
			return [[[SCURL alloc] initWithString:obj isDirectory:NO] autorelease];
		SC_SWITCH_CASE(name, @"WritingDirection")
			return NSTextWritingDirectionsFromString(obj);
		//----------------------------------------------------------------------
		SC_SWITCH_CASE(name, @"Color")         // XxxxColor
			return [SCColor create:obj];
		//----------------------------------------------------------------------
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return obj;
}

@implementation SCAttributedString (UIKit)

+ (NSDictionary *) attributesWithDictionary:(NSDictionary *)dict
{
	NSAssert([dict isKindOfClass:[NSDictionary class]], @"error: %@", dict);
	
	NSMutableDictionary * mDict = [NSMutableDictionary dictionaryWithCapacity:[dict count]];
	
	id key;
	id object;
	
	id name;
	id value;
	
	SC_FOR_EACH_KEY_VALUE(key, object, dict) {
		name = NSAttributeNameFromString(key);
		value = NSAttributeFromObject(object, key);
		
		if (name && value) {
			[mDict setObject:value forKey:name];
		}
	}
	
	return mDict;
}

@end
