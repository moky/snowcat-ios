//
//  SCActivityIndicatorView.m
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCLog.h"
#import "SCNib.h"
#import "SCColor.h"
#import "SCActivityIndicatorView.h"

//typedef NS_ENUM(NSInteger, UIActivityIndicatorViewStyle) {
//    UIActivityIndicatorViewStyleWhiteLarge,
//    UIActivityIndicatorViewStyleWhite,
//    UIActivityIndicatorViewStyleGray,
//};
UIActivityIndicatorViewStyle UIActivityIndicatorViewStyleFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Large")
			return UIActivityIndicatorViewStyleWhiteLarge;
		SC_SWITCH_CASE(string, @"White")
			return UIActivityIndicatorViewStyleWhite;
		SC_SWITCH_CASE(string, @"Gray")
			return UIActivityIndicatorViewStyleGray;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

@implementation SCActivityIndicatorView

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib

- (void) dealloc
{
	[_nodeFile release];
	
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCActivityIndicatorView
{
	_scTag = 0;
	self.nodeFile = nil;
	
	// default attributes
	self.userInteractionEnabled = NO;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCActivityIndicatorView];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeSCActivityIndicatorView];
	}
	return self;
}

- (instancetype) initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style
{
	self = [super initWithActivityIndicatorStyle:style];
	if (self) {
		[self _initializeSCActivityIndicatorView];
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	// NOTICE: this initializer would NOT call 'initWithFrame:'
	self = [self initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
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

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIActivityIndicatorView *)activityIndicatorView
{
	if (![SCView setAttributes:dict to:activityIndicatorView]) {
		SCLog(@"failed to set attributes: %@", dict);
		return NO;
	}
	
	// activityIndicatorViewStyle
	NSString * style = [dict objectForKey:@"style"];
	if (style) {
		activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleFromString(style);
	}
	
	// hidesWhenStopped
	id hidesWhenStopped = [dict objectForKey:@"hidesWhenStopped"];
	if (hidesWhenStopped) {
		activityIndicatorView.hidesWhenStopped = [hidesWhenStopped boolValue];
	}
	
	// color
	id color = [dict objectForKey:@"color"];
	if (color) {
		color = [SCColor create:color autorelease:NO];
		activityIndicatorView.color = color;
		[color release];
	}
	
	return YES;
}

@end
