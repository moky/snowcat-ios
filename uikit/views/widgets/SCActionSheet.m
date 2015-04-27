//
//  SCActionSheet.m
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCLog.h"
#import "SCClient.h"
#import "SCNib.h"
#import "SCEventHandler.h"
#import "SCAlertController.h"
#import "SCActionSheetDelegate.h"
#import "SCActionSheet.h"

//typedef NS_ENUM(NSInteger, UIActionSheetStyle) {
//    UIActionSheetStyleAutomatic        = -1,       // take appearance from toolbar style otherwise uses 'default'
//    UIActionSheetStyleDefault          = UIBarStyleDefault,
//    UIActionSheetStyleBlackTranslucent = UIBarStyleBlackTranslucent,
//    UIActionSheetStyleBlackOpaque      = UIBarStyleBlackOpaque,
//};
UIActionSheetStyle UIActionSheetStyleFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Auto")
			return UIActionSheetStyleAutomatic;
		SC_SWITCH_CASE(string, @"Translucent")
			return UIActionSheetStyleBlackTranslucent;
		SC_SWITCH_CASE(string, @"Opaque")
			return UIActionSheetStyleBlackOpaque;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return UIActionSheetStyleDefault;
}

@interface SCActionSheet ()

@property(nonatomic, retain) id<SCActionSheetDelegate> actionSheetDelegate;

@end

@implementation SCActionSheet

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib
@synthesize actionSheetDelegate = _actionSheetDelegate;

- (void) dealloc
{
	[_actionSheetDelegate release];
	[_nodeFile release];
	
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCActionSheet
{
	_scTag = 0;
	self.nodeFile = nil;
	
	self.actionSheetDelegate = nil;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCActionSheet];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeSCActionSheet];
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	NSString * cancelButtonTitle = [dict objectForKey:@"cancelButtonTitle"];
	NSString * destructiveButtonTitle = [dict objectForKey:@"destructiveButtonTitle"];
	
	if (!cancelButtonTitle) {
		cancelButtonTitle = [dict objectForKey:@"cancel"];
	}
	if (!destructiveButtonTitle) {
		destructiveButtonTitle = [dict objectForKey:@"confirm"];
	}
	
	if (!cancelButtonTitle) {
		cancelButtonTitle = @"Cancel";
	}
	cancelButtonTitle = SCLocalizedString(cancelButtonTitle, nil);
	destructiveButtonTitle = SCLocalizedString(destructiveButtonTitle, nil);
	
	self = [super initWithTitle:nil
					   delegate:nil
			  cancelButtonTitle:cancelButtonTitle
		 destructiveButtonTitle:destructiveButtonTitle
			  otherButtonTitles:nil];
	
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
		self.actionSheetDelegate = [SCActionSheetDelegate create:delegate];
		// self.delegate only assign but won't retain the action delegate,
		// so don't release it now
		self.delegate = _actionSheetDelegate;
	//}
}

// awakeFromNib
SC_UIKIT_IMPLEMENT_AWAKE_FUNCTION()

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIActionSheet *)actionSheet
{
	if (![SCView setAttributes:dict to:actionSheet]) {
		SCLog(@"failed to set attributes: %@", dict);
		return NO;
	}
	
	// title
	NSString * title = [dict objectForKey:@"title"];
	if (title) {
		title = SCLocalizedString(title, nil);
		actionSheet.title = title;
	}
	
	// actionSheetStyle
	NSString * actionSheetStyle = [dict objectForKey:@"actionSheetStyle"];
	if (actionSheetStyle) {
		actionSheet.actionSheetStyle = UIActionSheetStyleFromString(actionSheetStyle);
	}
	
	// otherButtonTitles
	NSArray * otherButtonTitles = [dict objectForKey:@"otherButtons"];
	if (otherButtonTitles) {
		NSEnumerator * enumerator = [otherButtonTitles objectEnumerator];
		while (title = [enumerator nextObject]) {
			title = SCLocalizedString(title, nil);
			[actionSheet addButtonWithTitle:title];
		}
	}
	
	return YES;
}

@end

#pragma mark - Convenient interface

void SCActionSheetWithDictionary(NSDictionary * dict, UIView * sourceView)
{
#ifdef __IPHONE_8_0
	
	CGFloat systemVersion = SCSystemVersion();
	if (systemVersion >= 8.0f) {
		
		NSMutableDictionary * mDict = nil;
		if (![dict objectForKey:@"preferredStyle"]) {
			mDict = [dict mutableCopy];
			[mDict setObject:@"ActionSheet" forKey:@"preferredStyle"];
			dict = mDict;
		}
		
		SCAlertController * alertController = [SCAlertController create:dict];
		UIPopoverPresentationController * popover = alertController.popoverPresentationController;
		if (popover && sourceView) {
			popover.sourceView = sourceView;
			popover.sourceRect = sourceView.bounds;
			popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
		}
		SC_UIKIT_SET_ATTRIBUTES(alertController, SCAlertController, dict);
		SCAlertControllerShow(alertController);
		
		[mDict release];
		return;
	}
	
#endif
	
	SCActionSheet * actionSheet = [SCActionSheet create:dict autorelease:NO];
	SC_UIKIT_SET_ATTRIBUTES(actionSheet, SCActionSheet, dict);
	SCActionSheetShow(actionSheet);
	[actionSheet release];
}

void SCActionSheetShow(UIActionSheet * actionSheet)
{
	UIApplication * application = [UIApplication sharedApplication];
	UIWindow * window = [application keyWindow];
	UIViewController * rootViewController = [window rootViewController];
	UIView * view = rootViewController.view;
	[actionSheet showInView:view];
}
