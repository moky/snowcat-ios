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
	
	SC_SET_ATTRIBUTES_AS_LOCALIZED_STRING(label, dict, text);
	
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
	
	SC_SET_ATTRIBUTES_AS_UIFONT (label, dict, font);
	SC_SET_ATTRIBUTES_AS_UICOLOR(label, dict, shadowColor);
	SC_SET_ATTRIBUTES_AS_CGSIZE (label, dict, shadowOffset);
	
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
	
	SC_SET_ATTRIBUTES_AS_UICOLOR(label, dict, highlightedTextColor);
	SC_SET_ATTRIBUTES_AS_BOOL   (label, dict, highlighted);
	
	// userInteractionEnabled (already set by SCView)
	
	SC_SET_ATTRIBUTES_AS_BOOL   (label, dict, enabled);
	SC_SET_ATTRIBUTES_AS_INTEGER(label, dict, numberOfLines);
	SC_SET_ATTRIBUTES_AS_BOOL   (label, dict, adjustsFontSizeToFitWidth);
	
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
	SC_SET_ATTRIBUTES_AS_BOOL   (label, dict, adjustsLetterSpacingToFitWidth);
#pragma clang diagnostic pop
	
	// baselineAdjustment
	NSString * baselineAdjustment = [dict objectForKey:@"baselineAdjustment"];
	if (baselineAdjustment) {
		label.baselineAdjustment = UIBaselineAdjustmentFromString(baselineAdjustment);
	}
	
	SC_SET_ATTRIBUTES_AS_FLOAT  (label, dict, minimumScaleFactor);
	
	SC_SET_ATTRIBUTES_AS_UICOLOR(label, dict, backgroundColor);
//	if (!backgroundColor) {
//		label.backgroundColor = [UIColor clearColor];
//	}
	
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
