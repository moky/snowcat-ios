//
//  SCVisualEffectView.m
//  SnowCat
//
//  Created by Moky on 15-1-5.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCNib.h"
#import "SCResponder.h"
#import "SCView.h"
#import "SCVisualEffectView.h"

#ifdef __IPHONE_8_0

//typedef NS_ENUM(NSInteger, UIBlurEffectStyle) {
//	UIBlurEffectStyleExtraLight,
//	UIBlurEffectStyleLight,
//	UIBlurEffectStyleDark
//} NS_ENUM_AVAILABLE_IOS(8_0);
UIBlurEffectStyle UIBlurEffectStyleFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Extra")
			return UIBlurEffectStyleExtraLight;
		SC_SWITCH_CASE(string, @"Light")
			return UIBlurEffectStyleLight;
		SC_SWITCH_CASE(string, @"Dark")
			return UIBlurEffectStyleDark;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

@implementation SCVisualEffect

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	self = [self init];
	if (self) {
	}
	return self;
}

// create:
SC_IMPLEMENT_CREATE_FUNCTION()
+ (id) create:(NSDictionary *)dict autorelease:(BOOL)autorelease
{
	UIVisualEffect * ve = nil;
	
	// get effect style
	NSString * blurEffectStyle = [dict objectForKey:@"blurEffectStyle"];
	if (!blurEffectStyle) {
		blurEffectStyle = [dict objectForKey:@"style"];
	}
	UIBlurEffectStyle stye = UIBlurEffectStyleFromString(blurEffectStyle);
	
	// create effect
	NSString * className = [dict objectForKey:@"Class"];
	if ([className rangeOfString:@"BlurEffect"].location != NSNotFound) {
		ve = [UIBlurEffect effectWithStyle:stye];
	} else if ([className rangeOfString:@"VibrancyEffect"].location != NSNotFound) {
		UIBlurEffect * be = [UIBlurEffect effectWithStyle:stye];
		ve = [UIVibrancyEffect effectForBlurEffect:be];
	}
	
	return autorelease ? ve : [ve retain];
}

@end

#pragma mark -

@implementation SCVisualEffectView

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib

- (void) dealloc
{
	[_nodeFile release];
	
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCVisualEffectView
{
	_scTag = 0;
	self.nodeFile = nil;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCVisualEffectView];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeSCVisualEffectView];
	}
	return self;
}

// NS_DESIGNATED_INITIALIZER
- (instancetype) initWithEffect:(UIVisualEffect *)effect
{
	self = [super initWithEffect:effect];
	if (self) {
		[self _initializeSCVisualEffectView];
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	NSDictionary * effect = [dict objectForKey:@"effect"];
	if (effect) {
		UIVisualEffect * ve = [SCVisualEffect create:effect autorelease:NO];
		self = [self initWithEffect:ve];
		[ve release];
	} else {
		self = [self initWithFrame:CGRectZero];
	}
	
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

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIVisualEffectView *)visualEffectView
{
	if (![SCView setAttributes:dict to:visualEffectView]) {
		return NO;
	}
	
	// contentView
	NSDictionary * contentView = [dict objectForKey:@"contentView"];
	if (contentView) {
		SC_UIKIT_SET_ATTRIBUTES(visualEffectView.contentView, SCView, contentView);
	}
	
	return YES;
}

@end

#endif
