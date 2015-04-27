//
//  SCAlertView.m
//  SnowCat
//
//  Created by Moky on 14-3-24.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCLog.h"
#import "SCClient.h"
#import "SCNib.h"
#import "SCEventHandler.h"
#import "SCAlertController.h"
#import "SCAlertViewDelegate.h"
#import "SCAlertView.h"

//typedef NS_ENUM(NSInteger, UIAlertViewStyle) {
//    UIAlertViewStyleDefault = 0,
//    UIAlertViewStyleSecureTextInput,
//    UIAlertViewStylePlainTextInput,
//    UIAlertViewStyleLoginAndPasswordInput
//};
UIAlertViewStyle UIAlertViewStyleFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Secure")
			return UIAlertViewStyleSecureTextInput;
		SC_SWITCH_CASE(string, @"Plain")
			return UIAlertViewStylePlainTextInput;
		SC_SWITCH_CASE(string, @"Login")
			return UIAlertViewStyleLoginAndPasswordInput;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return UIAlertViewStyleDefault;
}

@interface SCAlertView ()

@property(nonatomic, retain) id<SCAlertViewDelegate> alertViewDelegate;

@end

@implementation SCAlertView

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib
@synthesize alertViewDelegate = _alertViewDelegate;

- (void) dealloc
{
	[_alertViewDelegate release];
	[_nodeFile release];
	
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCAlertView
{
	_scTag = 0;
	self.nodeFile = nil;
	
	self.alertViewDelegate = nil;
	
//	self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCAlertView];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeSCAlertView];
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	NSString * cancel = [dict objectForKey:@"cancel"];
	NSString * confirm = [dict objectForKey:@"confirm"];
	
	if (!cancel) {
		if (confirm) {
			cancel = confirm;
			confirm = nil;
		} else {
			cancel = [dict objectForKey:@"ok"];
			if (!cancel) {
				cancel = @"OK";
			}
		}
	}
	cancel = SCLocalizedString(cancel, nil);
	confirm = SCLocalizedString(confirm, nil);
	
	self = [self initWithTitle:nil message:nil delegate:nil cancelButtonTitle:cancel otherButtonTitles:confirm, nil];
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
	//if (delegate) {
		self.alertViewDelegate = [SCAlertViewDelegate create:delegate];
		// self.delegate only assign but won't retain the action delegate,
		// so don't release it now
		self.delegate = _alertViewDelegate;
	//}
}

// awakeFromNib
SC_UIKIT_IMPLEMENT_AWAKE_FUNCTION()

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIAlertView *)alertView
{
	if (![SCView setAttributes:dict to:alertView]) {
		SCLog(@"failed to set attributes: %@", dict);
		return NO;
	}
	
	// title
	NSString * title = [dict objectForKey:@"title"];
	if (title) {
		title = SCLocalizedString(title, nil);
		alertView.title = title;
	}
	
	// message
	NSString * message = [dict objectForKey:@"message"];
	if (message) {
		message = SCLocalizedString(message, nil);
		alertView.message = message;
	}
	
	// otherButtonTitles
	NSArray * otherButtonTitles = [dict objectForKey:@"otherButtons"];
	if (otherButtonTitles) {
		NSEnumerator * enumerator = [otherButtonTitles objectEnumerator];
		while (title = [enumerator nextObject]) {
			title = SCLocalizedString(title, nil);
			[alertView addButtonWithTitle:title];
		}
	}
	
	// alertViewStyle
	NSString * alertViewStyle = [dict objectForKey:@"alertViewStyle"];
	if (alertViewStyle) {
		alertView.alertViewStyle = UIAlertViewStyleFromString(alertViewStyle);
	}
	
	return YES;
}

@end

#pragma mark - Convenient interface

void SCAlertWithDictionary(NSDictionary * dict)
{
#ifdef __IPHONE_8_0
	
	CGFloat systemVersion = SCSystemVersion();
	if (systemVersion >= 8.0f) {
		
		NSMutableDictionary * mDict = nil;
		if (![dict objectForKey:@"preferredStyle"]) {
			mDict = [dict mutableCopy];
			[mDict setObject:@"Alert" forKey:@"preferredStyle"];
			dict = mDict;
		}
		
		SCAlertController * alertController = [SCAlertController create:dict];
		SC_UIKIT_SET_ATTRIBUTES(alertController, SCAlertController, dict);
		SCAlertControllerShow(alertController);
		
		[mDict release];
		return;
	}
	
#endif
	
	SCAlertView * alertView = [SCAlertView create:dict autorelease:NO];
	SC_UIKIT_SET_ATTRIBUTES(alertView, SCAlertView, dict);
	[alertView show];
	[alertView release];
}

void SCAlert(NSString * title, NSString * message, NSString * ok)
{
	if (!ok) {
		ok = @"OK";
	}
	
	NSMutableDictionary * mDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
								   @"Alert", @"preferredStyle",
								   ok, @"ok",
								   nil];
	if (title) {
		[mDict setObject:title forKey:@"title"];
	}
	if (message) {
		[mDict setObject:message forKey:@"message"];
	}
	
	SCAlertWithDictionary(mDict);
	
	[mDict release];
}
