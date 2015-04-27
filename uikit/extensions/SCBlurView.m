//
//  SCBlurView.m
//  SnowCat
//
//  Created by Moky on 15-1-5.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCClient.h"
#import "SCVisualEffectView.h"
#import "SCToolbar.h"
#import "SCBlurView.h"

@interface SCBlurView () {
	UIView * _mask;
}

@end

@implementation SCBlurView

- (void) dealloc
{
	[_mask release];
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[_mask release];
		_mask = nil;
	}
	return self;
}

// default initializer
- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[_mask release];
		_mask = nil;
	}
	return self;
}

- (BOOL) setAttributes:(NSDictionary *)dict
{
	if (![super setAttributes:dict]) {
		return NO;
	}
	
	// effect style
	NSString * style = [dict objectForKey:@"style"];
	if (!style) {
		style = @"Light";
	}
	
#ifdef __IPHONE_7_0
	CGFloat systemVersion = SCSystemVersion();
#ifdef __IPHONE_8_0
	if (systemVersion >= 8.0f) {
		// add blur effect
		NSDictionary * vev = [dict objectForKey:@"visualEffectView"];
		if (!vev) {
			vev = @{
					@"Class": @"SCVisualEffectView",
					@"effect": @{
							@"Class": @"SCBlurEffect",
							@"blurEffectStyle": style,
							},
					};
		}
		SCVisualEffectView * view = [SCVisualEffectView create:vev autorelease:NO];
		[self addSubview:view];
		SC_UIKIT_SET_ATTRIBUTES(view, SCVisualEffectView, vev);
		_mask = view;
	} else
#endif // EOF '__IPHONE_8_0'
	if (systemVersion >= 7.0f) {
		// add tool bar
		NSDictionary * tb = [dict objectForKey:@"toolbar"];
		if (!tb) {
			// tintColor by effect style
			if ([style rangeOfString:@"Dark"].location != NSNotFound) {
				tb = @{
					   @"Class" : @"SCToolbar",
					   @"barStyle": @"Black",
					   @"translucent": @"1",
					   };
			} else {
				tb = @{
					   @"Class" : @"SCToolbar",
					   @"barStyle": @"Default",
					   @"translucent": @"1",
					   };
			}
		}
		SCToolbar * view = [SCToolbar create:tb autorelease:NO];
		[self addSubview:view];
		SC_UIKIT_SET_ATTRIBUTES(view, SCToolbar, tb);
		_mask = view;
	} else
#endif // EOF '__IPHONE_7_0'
	
	if (!_mask) {
		// use half-translucent background color instead the effect
		id backgroundColor = [dict objectForKey:@"backgroundColor"];
		if (!backgroundColor) {
			SC_SWITCH_BEGIN(style)
				SC_SWITCH_CASE(style, @"Extra")
					self.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.888f];
					break;
				SC_SWITCH_CASE(style, @"Light")
					self.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.618f];
					break;
				SC_SWITCH_CASE(style, @"Dark")
					self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.618f];
					break;
				SC_SWITCH_DEFAULT
			SC_SWITCH_END
		}
	}
	
	return YES;
}

- (void) layoutSubviews {
	[super layoutSubviews];
	_mask.frame = self.bounds;
}

@end
