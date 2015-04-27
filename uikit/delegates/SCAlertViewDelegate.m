//
//  SCAlertViewDelegate.m
//  SnowCat
//
//  Created by Moky on 14-4-3.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCEventHandler.h"
#import "SCAlertViewDelegate.h"

@implementation SCAlertViewDelegate

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	self = [self init];
	if (self) {
		// TODO: set attributes here
	}
	return self;
}

#pragma mark - UIAlertViewDelegate

//@optional

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// onCancel
	if (buttonIndex == alertView.cancelButtonIndex) {
		SCDoEvent(@"onCancel", alertView);
		return;
	}
	
	if (alertView.firstOtherButtonIndex != -1) {
		buttonIndex -= alertView.firstOtherButtonIndex;
	} else {
		// here is a bug in UIKit, fix it
		if (alertView.cancelButtonIndex != -1) {
			--buttonIndex;
		}
	}
	NSAssert(buttonIndex >= 0, @"error: %d", (int)buttonIndex);
	
	// onConfirm
	if (buttonIndex == 0) {
		SCDoEvent(@"onConfirm", alertView);
		return;
	}
	--buttonIndex; // remove "otherButtons[0]", because it was token by "confirm"
	
	// onClick:N
	NSString * actionName = [[NSString alloc] initWithFormat:@"onClick:%d", (int)buttonIndex];
	SCDoEvent(actionName, alertView);
	[actionName release];
}

//
//// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
//// If not defined in the delegate, we simulate a click in the cancel button
//- (void)alertViewCancel:(UIAlertView *)alertView;
//
//- (void)willPresentAlertView:(UIAlertView *)alertView;  // before animation and showing view
//- (void)didPresentAlertView:(UIAlertView *)alertView;  // after animation
//
//- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex; // before animation and hiding view
//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation
//
//// Called after edits in any of the default fields added by the style
//- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView;

@end
