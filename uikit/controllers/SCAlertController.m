//
//  SCAlertController.m
//  SnowCat
//
//  Created by Moky on 15-1-14.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCDevice.h"
#import "SCApplication.h"
#import "SCNib.h"
#import "SCEventHandler.h"
#import "SCAlertController.h"

#ifdef __IPHONE_8_0

//typedef NS_ENUM(NSInteger, UIAlertControllerStyle) {
//	UIAlertControllerStyleActionSheet = 0,
//	UIAlertControllerStyleAlert
//} NS_ENUM_AVAILABLE_IOS(8_0);
UIAlertControllerStyle UIAlertControllerStyleFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Sheet")
			return UIAlertControllerStyleActionSheet;
		SC_SWITCH_CASE(string, @"Alert")
			return UIAlertControllerStyleAlert;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

@interface SCAlertController () {
	
	NSUInteger _supportedInterfaceOrientations;
}

@end

@implementation SCAlertController

@synthesize scTag = _scTag;

- (void) dealloc
{
	[SCResponder onDestroy:self.view];
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCAlertController
{
	_scTag = 0;
	_supportedInterfaceOrientations = SC_UIKIT_DEFAULT_SUPPORTED_INTERFACE_ORIENTATIONS;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCAlertController];
	}
	return self;
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		[self _initializeSCAlertController];
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	// initWithNibName:bundle:
	NSString * nibName = [SCNib nibNameFromDictionary:dict];
	
	NSBundle * bundle = [SCNib bundleFromDictionary:dict autorelease:NO];
	self = [self initWithNibName:nibName bundle:bundle];
	[bundle release];
	
	if (self) {
		[self buildHandlers:dict];
	}
	return self;
}

// buildHandlers:
SC_UIKIT_IMELEMENT_BUILD_HANDLERS_FUNCTION()

// create:
SC_IMPLEMENT_CREATE_FUNCTION()
+ (id) create:(NSDictionary *)dict autorelease:(BOOL)autorelease
{
	NSAssert([dict isKindOfClass:[NSDictionary class]], @"definition error: %@", dict);
	
	// title
	NSString * title = [dict objectForKey:@"title"];
	title = SCLocalizedString(title, nil);
	
	// message
	NSString * message = [dict objectForKey:@"message"];
	message = SCLocalizedString(message, nil);
	
	// preferredStyle
	NSString * preferredStyle = [dict objectForKey:@"preferredStyle"];
	UIAlertControllerStyle style = UIAlertControllerStyleFromString(preferredStyle);
	
	UIAlertController * ac = [UIAlertController alertControllerWithTitle:title
																 message:message
														  preferredStyle:style];
	
	return autorelease ? ac : [ac retain];
}

// setAttributes:
SC_UIKIT_VIEW_CONTROLLER_IMPLEMENT_SET_ATTRIBUTES_WITH_ORIENTATIONS(_supportedInterfaceOrientations, @"supportedInterfaceOrientations")

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIAlertController *)alertController
{
	NSMutableDictionary * mDict = nil;
	
	// because the "[SCResponder onDestroy:]" wouldn't be called, we cannot release the event handler automatically,
	// so we use a ghost view to handle events here
	NSDictionary * events = [dict objectForKey:@"events"];
	if (events) {
		NSMutableDictionary * ghostDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:events, @"events", nil];
		// actions
		NSDictionary * actions = [dict objectForKey:@"actions"];
		if (actions) {
			[ghostDict setObject:actions forKey:@"actions"];
		}
		// notifications
		NSArray * notifications = [dict objectForKey:@"notifications"];
		if (notifications) {
			[ghostDict setObject:notifications forKey:@"notifications"];
		}
		
		SCView * ghostView = [SCView create:ghostDict autorelease:NO];
		ghostView.tag = 9527;
		ghostView.userInteractionEnabled = NO;
		ghostView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[alertController.view addSubview:ghostView];
		SC_SET_ATTRIBUTES(ghostView, SCView, ghostDict);
		[ghostView release];
		[ghostDict release];
		
		// prevent building handlers for the UIAlertController
		mDict = [dict mutableCopy];
		[mDict removeObjectForKey:@"events"];
		dict = mDict;
	}
	
	if (![SCViewController setAttributes:dict to:alertController]) {
		SCLog(@"failed to set attributes: %@", dict);
		[mDict release];
		return NO;
	}
	
	// actions
	// textFields
	
	// title
	
	// message
	
	// preferredStyle
	
	//-- buttons
	
	__block UIView * ghostView = [alertController.view viewWithTag:9527];
	__block id<SCEventDelegate> delegate = ghostView ? [SCEventHandler delegateForResponder:ghostView] : nil;
	
	NSString * cancel = [dict objectForKey:@"cancel"];
	NSString * confirm = [dict objectForKey:@"confirm"];
	
	if (!cancel) {
		cancel = [dict objectForKey:@"cancelButtonTitle"];
	}
	if (!confirm) {
		confirm = [dict objectForKey:@"destructiveButtonTitle"];
	}
	
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
	
	// cancel
	if (cancel) {
		UIAlertAction * aa = [UIAlertAction actionWithTitle:cancel
													  style:UIAlertActionStyleCancel
													handler:^(UIAlertAction *action) {
														SCLog(@"cancel: %@", cancel);
														[delegate doEvent:@"onCancel" withResponder:ghostView];
													}];
		[alertController addAction:aa];
	}
	
	// confirm
	if (confirm) {
		UIAlertAction * aa = [UIAlertAction actionWithTitle:confirm
													  style:UIAlertActionStyleDestructive
													handler:^(UIAlertAction *action) {
														SCLog(@"confirm: %@", confirm);
														[delegate doEvent:@"onConfirm" withResponder:ghostView];
													}];
		[alertController addAction:aa];
	}
	
	// otherButtonTitles
	NSArray * otherButtonTitles = [dict objectForKey:@"otherButtons"];
	if (otherButtonTitles) {
		NSInteger buttonIndex = -1;
		
		UIAlertAction * aa;
		NSEnumerator * enumerator = [otherButtonTitles objectEnumerator];
		NSString * title;
		
		while (title = [enumerator nextObject]) {
			NSString * event = [NSString stringWithFormat:@"onClick:%d", (int)++buttonIndex];
			title = SCLocalizedString(title, nil);
			aa = [UIAlertAction actionWithTitle:title
										  style:UIAlertActionStyleDefault
										handler:^(UIAlertAction *action) {
											SCLog(@"other: %@, %@", title, event);
											[delegate doEvent:event withResponder:ghostView];
										}];
			[alertController addAction:aa];
		}
	}
	
	[mDict release];
	
	return YES;
}

// view loading functions
SC_UIKIT_VIEW_CONTROLLER_IMPLEMENT_LOAD_VIEW_FUNCTIONS()

// Autorotate
SC_UIKIT_IMPLEMENT_AUTOROTATE_FUNCTIONS_WITH_PROPERTY(_supportedInterfaceOrientations)

@end

void SCAlertControllerShow(UIAlertController * alertController)
{
	UIApplication * application = [UIApplication sharedApplication];
	UIWindow * window = [application keyWindow];
	UIViewController * rootViewController = [window rootViewController];
	[rootViewController presentViewController:alertController animated:YES completion:NULL];
}

#endif // EOF '__IPHONE_8_0'
