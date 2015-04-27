//
//  SCTextView.m
//  SnowCat
//
//  Created by Moky on 14-4-3.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCNib.h"
#import "SCDataDetectors.h"
#import "SCAttributedString.h"
#import "SCText.h"
#import "SCTextInput.h"
#import "SCColor.h"
#import "SCFont.h"
#import "SCTextViewDelegate.h"
#import "SCTextView.h"

@interface SCTextView ()

@property(nonatomic, retain) id<SCTextViewDelegate> textViewDelegate;

@end

@implementation SCTextView

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib
@synthesize textViewDelegate = _textViewDelegate;

- (void) dealloc
{
	[_textViewDelegate release];
	[_nodeFile release];
	
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCTextView
{
	_scTag = 0;
	self.nodeFile = nil;
	
	self.textViewDelegate = nil;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCTextView];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeSCTextView];
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
- (void) buildHandlers:(NSDictionary *)dict
{
	[SCResponder onCreate:self withDictionary:dict];
	
	NSDictionary * delegate = [dict objectForKey:@"delegate"];
	if (delegate) {
		self.textViewDelegate = [SCTextViewDelegate create:delegate];
		// self.delegate only assign but won't retain the action delegate,
		// so don't release it now
		self.delegate = _textViewDelegate;
	}
}

// awakeFromNib
SC_UIKIT_IMPLEMENT_AWAKE_FUNCTION()

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UITextView *)textView
{
	if (![SCScrollView setAttributes:dict to:textView]) {
		return NO;
	}
	
	// protocol
	if (![SCTextInput setAttributes:dict to:textView]) {
		return NO;
	}
	
	// text
	NSString * text = [dict objectForKey:@"text"];
	if (text) {
		text = SCLocalizedString(text, nil);
		textView.text = text;
	}
	
	// font
	NSDictionary * font = [dict objectForKey:@"font"];
	if (font) {
		SCFont * f = [SCFont create:font autorelease:NO];
		textView.font = f;
		[f release];
	}
	
	// textColor
	NSDictionary * textColor = [dict objectForKey:@"textColor"];
	if (!textColor) {
		textColor = [dict objectForKey:@"color"];
	}
	if (textColor) {
		SCColor * color = [SCColor create:textColor autorelease:NO];
		textView.textColor = color;
		[color release];
	}
	
	// textAlignment
	NSString * textAlignment = [dict objectForKey:@"textAlignment"];
	if (textAlignment) {
		textView.textAlignment = NSTextAlignmentFromString(textAlignment);
	}
	
	// selectedRange
	NSString * selectedRange = [dict objectForKey:@"selectedRange"];
	if (selectedRange) {
		textView.selectedRange = NSRangeFromString(selectedRange);
	}
	
	// editable
	id editable = [dict objectForKey:@"editable"];
	if (editable) {
		textView.editable = [editable boolValue];
	}
	
	// dataDetectorTypes
	NSString * dataDetectorTypes = [dict objectForKey:@"dataDetectorTypes"];
	if (dataDetectorTypes) {
		textView.dataDetectorTypes = UIDataDetectorTypesFromString(dataDetectorTypes);
	}
	
	// allowsEditingTextAttributes
	id allowsEditingTextAttributes = [dict objectForKey:@"allowsEditingTextAttributes"];
	if (allowsEditingTextAttributes) {
		textView.allowsEditingTextAttributes = [allowsEditingTextAttributes boolValue];
	}
	
	// attributedText
	NSDictionary * attributedText = [dict objectForKey:@"attributedText"];
	if (attributedText) {
		SCAttributedString * as = [SCAttributedString create:attributedText autorelease:NO];
		NSAssert([as isKindOfClass:[NSAttributedString class]], @"attributedText's definition error: %@", attributedText);
		textView.attributedText = as;
		[as release];
	}
	
	// typingAttributes
	NSDictionary * typingAttributes = [dict objectForKey:@"typingAttributes"];
	if (typingAttributes) {
		textView.typingAttributes = typingAttributes;
	}
	
	// inputView
	NSDictionary * inputView = [dict objectForKey:@"inputView"];
	if (inputView) {
		SC_UIKIT_DIG_CREATION_INFO(inputView); // support ObjectFromFile
		SCView * view = [SCView create:inputView autorelease:NO];
		NSAssert([view isKindOfClass:[UIView class]], @"inputView's definition error: %@", inputView);
		textView.inputView = view;
		SC_UIKIT_SET_ATTRIBUTES(view, SCView, inputView);
		[view release];
	}
	
	// inputAccessoryView
	NSDictionary * inputAccessoryView = [dict objectForKey:@"inputAccessoryView"];
	if (inputAccessoryView) {
		SC_UIKIT_DIG_CREATION_INFO(inputAccessoryView); // support ObjectFromFile
		SCView * view = [SCView create:inputAccessoryView autorelease:NO];
		NSAssert([view isKindOfClass:[UIView class]], @"inputAccessoryView's definition error: %@", inputAccessoryView);
		textView.inputAccessoryView = view;
		SC_UIKIT_SET_ATTRIBUTES(view, SCView, inputAccessoryView);
		[view release];
	}
	
	// clearsOnInsertion
	id clearsOnInsertion = [dict objectForKey:@"clearsOnInsertion"];
	if (clearsOnInsertion) {
		textView.clearsOnInsertion = [clearsOnInsertion boolValue];
	}
	
	return YES;
}

@end
