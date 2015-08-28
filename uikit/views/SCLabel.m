//
//  SCLabel.m
//  SnowCat
//
//  Created by Moky on 14-3-22.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCNib.h"
#import "SCParagraphStyle.h"
#import "SCText.h"
#import "SCStringDrawing.h"
#import "SCAttributedString.h"
#import "SCColor.h"
#import "SCFont.h"
#import "SCGeometry.h"
#import "SCLabel.h"

@implementation SCLabel

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib

- (void) dealloc
{
	[_nodeFile release];
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		_scTag = 0;
		self.nodeFile = nil;
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		_scTag = 0;
		self.nodeFile = nil;
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	self = [self initWithFrame:CGRectZero];
	if (self) {
		[self buildHandlers:dict];
	}
	return self;
}

// buildHandlers:
SC_UIKIT_IMELEMENT_BUILD_HANDLERS_FUNCTION()

// awakeFromNib
SC_UIKIT_IMPLEMENT_AWAKE_FUNCTION()

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UILabel *)label
{
	NSAssert([dict isKindOfClass:[NSDictionary class]], @"parameters error: %@", dict);
	
	// text
	NSString * text = [dict objectForKey:@"text"];
	if (text) {
		text = SCLocalizedString(text, nil);
		label.text = text;
	}
	
	// textColor
	NSDictionary * textColor = [dict objectForKey:@"textColor"];
	if (!textColor) {
		textColor = [dict objectForKey:@"color"];
	}
	if (textColor) {
		SCColor * color = [SCColor create:textColor autorelease:NO];
		label.textColor = color;
		[color release];
	}
	
	// font
	NSDictionary * font = [dict objectForKey:@"font"];
	if (font) {
		label.font = [SCFont create:font];
	}
	
	// shadowColor
	NSDictionary * shadowColor = [dict objectForKey:@"shadowColor"];
	if (shadowColor) {
		SCColor * color = [SCColor create:textColor autorelease:NO];
		label.shadowColor = color;
		[color release];
	}
	
	// shadowOffset
	NSString * shadowOffset = [dict objectForKey:@"shadowOffset"];
	if (shadowOffset) {
		label.shadowOffset = CGSizeFromStringWithNode(shadowOffset, label);
	}
	
	// textAlignment
	NSString * textAlignment = [dict objectForKey:@"textAlignment"];
	if (textAlignment) {
		label.textAlignment = NSTextAlignmentFromString(textAlignment);
	}
	
	// lineBreakMode
	NSString * lineBreakMode = [dict objectForKey:@"lineBreakMode"];
	if (lineBreakMode) {
		label.lineBreakMode = NSLineBreakModeFromString(lineBreakMode);
	}
	
	// attributedText
	NSDictionary * attributedText = [dict objectForKey:@"attributedText"];
	if (attributedText) {
		SCAttributedString * as = [SCAttributedString create:attributedText autorelease:NO];
		NSAssert([as isKindOfClass:[NSAttributedString class]], @"attributedText's definition error: %@", attributedText);
		label.attributedText = as;
		[as release];
	}
	
	// highlightedTextColor
	NSDictionary * highlightedTextColor = [dict objectForKey:@"highlightedTextColor"];
	if (highlightedTextColor) {
		SCColor * color = [SCColor create:highlightedTextColor autorelease:NO];
		label.highlightedTextColor = color;
		[color release];
	}
	
	// highlighted
	id highlighted = [dict objectForKey:@"highlighted"];
	if (highlighted) {
		label.highlighted = [highlighted boolValue];
	}
	
	// userInteractionEnabled (already set by SCView)
	
	// enabled
	id enabled = [dict objectForKey:@"enabled"];
	if (enabled) {
		label.enabled = [enabled boolValue];
	}
	
	// numberOfLines
	id numberOfLines = [dict objectForKey:@"numberOfLines"];
	if (numberOfLines) {
		label.numberOfLines = [numberOfLines integerValue];
	}
	
	// adjustsFontSizeToFitWidth
	id adjustsFontSizeToFitWidth = [dict objectForKey:@"adjustsFontSizeToFitWidth"];
	if (adjustsFontSizeToFitWidth) {
		label.adjustsFontSizeToFitWidth = [adjustsFontSizeToFitWidth boolValue];
	}
	
	// adjustsLetterSpacingToFitWidth
	id adjustsLetterSpacingToFitWidth = [dict objectForKey:@"adjustsLetterSpacingToFitWidth"];
	if (adjustsLetterSpacingToFitWidth) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		label.adjustsLetterSpacingToFitWidth = [adjustsLetterSpacingToFitWidth boolValue];
#pragma clang diagnostic pop
	}
	
	// baselineAdjustment
	NSString * baselineAdjustment = [dict objectForKey:@"baselineAdjustment"];
	if (baselineAdjustment) {
		label.baselineAdjustment = UIBaselineAdjustmentFromString(baselineAdjustment);
	}
	
	// minimumScaleFactor
	id minimumScaleFactor = [dict objectForKey:@"minimumScaleFactor"];
	if (minimumScaleFactor) {
		label.minimumScaleFactor = [minimumScaleFactor floatValue];
	}
	
	// backgroundColor
	id backgroundColor = [dict objectForKey:@"backgroundColor"];
	if (!backgroundColor) {
		label.backgroundColor = [UIColor clearColor];
	}
	
	// size
	NSString * frame = [dict objectForKey:@"frame"];
	NSString * bounds = [dict objectForKey:@"bounds"];
	NSString * size = [dict objectForKey:@"size"];
	if (!frame && !bounds && !size) {
		// 1. resize to fill superview
		UIView * pv = label.superview;
		if (pv) {
			CGRect fr = label.frame;
			fr.size = pv.bounds.size;
			label.frame = fr;
		}
		// 2. resize to fit self
		[label sizeToFit];
	}
	
	// set general attributes after
	if (![SCView setAttributes:dict to:label]) {
		SCLog(@"failed to set attributes: %@", dict);
		return NO;
	}
	
	return YES;
}

@end
