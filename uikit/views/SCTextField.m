//
//  SCTextField.m
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCNib.h"
#import "SCAttributedString.h"
#import "SCText.h"
#import "SCTextInput.h"
#import "SCColor.h"
#import "SCFont.h"
#import "SCImage.h"
#import "SCTextFieldDelegate.h"
#import "SCTextField.h"

//typedef NS_ENUM(NSInteger, UITextBorderStyle) {
//    UITextBorderStyleNone,
//    UITextBorderStyleLine,
//    UITextBorderStyleBezel,
//    UITextBorderStyleRoundedRect
//};
UITextBorderStyle UITextBorderStyleFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"None")
			return UITextBorderStyleNone;
		SC_SWITCH_CASE(string, @"Line")
			return UITextBorderStyleLine;
		SC_SWITCH_CASE(string, @"Bez")   // Bezel
			return UITextBorderStyleBezel;
		SC_SWITCH_CASE(string, @"Round") // RoundedRect
			return UITextBorderStyleRoundedRect;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

//typedef NS_ENUM(NSInteger, UITextFieldViewMode) {
//    UITextFieldViewModeNever,
//    UITextFieldViewModeWhileEditing,
//    UITextFieldViewModeUnlessEditing,
//    UITextFieldViewModeAlways
//};
UITextFieldViewMode UITextFieldViewModeFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Never")
			return UITextFieldViewModeNever;
		SC_SWITCH_CASE(string, @"WhileEditing")
			return UITextFieldViewModeWhileEditing;
		SC_SWITCH_CASE(string, @"UnlessEditing")
			return UITextFieldViewModeUnlessEditing;
		SC_SWITCH_CASE(string, @"Always")
			return UITextFieldViewModeAlways;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

@interface SCTextField ()

@property(nonatomic, retain) id<SCTextFieldDelegate> textFieldDelegate;

@end

@implementation SCTextField

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib
@synthesize textFieldDelegate = _textFieldDelegate;

- (void) dealloc
{
	[_textFieldDelegate release];
	[_nodeFile release];
	
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCTextField
{
	_scTag = 0;
	self.nodeFile = nil;
	
	self.textFieldDelegate = nil;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCTextField];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeSCTextField];
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
		self.textFieldDelegate = [SCTextFieldDelegate create:delegate];
		// self.delegate only assign but won't retain the action delegate,
		// so don't release it now
		self.delegate = _textFieldDelegate;
	}
}

// awakeFromNib
SC_UIKIT_IMPLEMENT_AWAKE_FUNCTION()

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UITextField *)textField
{
	if (![SCControl setAttributes:dict to:textField]) {
		return NO;
	}
	
	// protocol
	if (![SCTextInput setAttributes:dict to:textField]) {
		return NO;
	}
	
	SC_SET_ATTRIBUTES_AS_LOCALIZED_STRING(textField, dict, text);
	
	// attributedText
	NSDictionary * attributedText = [dict objectForKey:@"attributedText"];
	if (attributedText) {
		SCAttributedString * as = [SCAttributedString create:attributedText];
		NSAssert([as isKindOfClass:[NSAttributedString class]], @"attributedText's definition error: %@", attributedText);
		textField.attributedText = as;
	}
	
	// textColor
	NSDictionary * textColor = [dict objectForKey:@"textColor"];
	if (!textColor) {
		textColor = [dict objectForKey:@"color"];
	}
	if (textColor) {
		SCColor * color = [SCColor create:textColor];
		textField.textColor = color;
	}
	
	SC_SET_ATTRIBUTES_AS_UIFONT(textField, dict, font);
	
	// textAlignment
	NSString * textAlignment = [dict objectForKey:@"textAlignment"];
	if (textAlignment) {
		textField.textAlignment = NSTextAlignmentFromString(textAlignment);
	}
	
	// borderStyle
	NSString * borderStyle = [dict objectForKey:@"borderStyle"];
	if (borderStyle) {
		textField.borderStyle = UITextBorderStyleFromString(borderStyle);
	}
	
	SC_SET_ATTRIBUTES_AS_LOCALIZED_STRING(textField, dict, placeholder);
	
	// attributedPlaceholder
	NSDictionary * attributedPlaceholder = [dict objectForKey:@"attributedPlaceholder"];
	if (attributedPlaceholder) {
		SCAttributedString * as = [SCAttributedString create:attributedPlaceholder];
		NSAssert([as isKindOfClass:[NSAttributedString class]], @"attributedPlaceholder's definition error: %@", attributedPlaceholder);
		textField.attributedPlaceholder = as;
	}
	
	SC_SET_ATTRIBUTES_AS_BOOL   (textField, dict, clearsOnBeginEditing);
	SC_SET_ATTRIBUTES_AS_BOOL   (textField, dict, adjustsFontSizeToFitWidth);
	SC_SET_ATTRIBUTES_AS_FLOAT  (textField, dict, minimumFontSize);
	SC_SET_ATTRIBUTES_AS_UIIMAGE(textField, dict, background);
	SC_SET_ATTRIBUTES_AS_UIIMAGE(textField, dict, disabledBackground);
	SC_SET_ATTRIBUTES_AS_BOOL   (textField, dict, allowsEditingTextAttributes);
	
	// typingAttributes
	NSDictionary * typingAttributes = [dict objectForKey:@"typingAttributes"];
	if (typingAttributes) {
		textField.typingAttributes = typingAttributes;
	}
	
	// clearButtonMode
	NSString * clearButtonMode = [dict objectForKey:@"clearButtonMode"];
	if (clearButtonMode) {
		textField.clearButtonMode = UITextFieldViewModeFromString(clearButtonMode);
	}
	
	// leftView
	NSDictionary * leftView = [dict objectForKey:@"leftView"];
	if (leftView) {
		SC_UIKIT_DIG_CREATION_INFO(leftView); // support ObjectFromFile
		SCView * view = [SCView create:leftView];
		NSAssert([view isKindOfClass:[UIView class]], @"leftView's definition error: %@", leftView);
		textField.leftView = view;
		SC_UIKIT_SET_ATTRIBUTES(view, SCView, leftView);
	}
	
	// leftViewMode
	NSString * leftViewMode = [dict objectForKey:@"leftViewMode"];
	if (leftViewMode) {
		textField.leftViewMode = UITextFieldViewModeFromString(leftViewMode);
	}
	
	// rightView
	NSDictionary * rightView = [dict objectForKey:@"rightView"];
	if (rightView) {
		SC_UIKIT_DIG_CREATION_INFO(rightView); // support ObjectFromFile
		SCView * view = [SCView create:rightView];
		NSAssert([view isKindOfClass:[UIView class]], @"rightView's definition error: %@", rightView);
		textField.rightView = view;
		SC_UIKIT_SET_ATTRIBUTES(view, SCView, rightView);
	}
	
	// rightViewMode
	NSString * rightViewMode = [dict objectForKey:@"rightViewMode"];
	if (rightViewMode) {
		textField.rightViewMode = UITextFieldViewModeFromString(rightViewMode);
	}
	
	// inputView
	NSDictionary * inputView = [dict objectForKey:@"inputView"];
	if (inputView) {
		SC_UIKIT_DIG_CREATION_INFO(inputView); // support ObjectFromFile
		SCView * view = [SCView create:inputView];
		NSAssert([view isKindOfClass:[UIView class]], @"inputView's definition error: %@", inputView);
		textField.inputView = view;
		SC_UIKIT_SET_ATTRIBUTES(view, SCView, inputView);
	}
	
	// inputAccessoryView
	NSDictionary * inputAccessoryView = [dict objectForKey:@"inputAccessoryView"];
	if (inputAccessoryView) {
		SC_UIKIT_DIG_CREATION_INFO(inputAccessoryView); // support ObjectFromFile
		SCView * view = [SCView create:inputAccessoryView];
		NSAssert([view isKindOfClass:[UIView class]], @"inputAccessoryView's definition error: %@", inputAccessoryView);
		textField.inputAccessoryView = view;
		SC_UIKIT_SET_ATTRIBUTES(view, SCView, inputAccessoryView);
	}
	
	SC_SET_ATTRIBUTES_AS_BOOL(textField, dict, clearsOnInsertion);
	
	return YES;
}

@end
