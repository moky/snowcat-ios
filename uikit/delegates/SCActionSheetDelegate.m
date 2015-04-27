//
//  SCActionSheetDelegate.m
//  SnowCat
//
//  Created by Moky on 14-4-3.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCEventHandler.h"
#import "SCActionSheetDelegate.h"

@implementation SCActionSheetDelegate

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

#pragma mark - UIActionSheetDelegate

//@optional

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// onCancel
	if (buttonIndex == actionSheet.cancelButtonIndex) {
		SCDoEvent(@"onCancel", actionSheet);
		return;
	}
	
	// onConfirm
	if (buttonIndex == actionSheet.destructiveButtonIndex) {
		SCDoEvent(@"onConfirm", actionSheet);
		return;
	}
	
	if (actionSheet.firstOtherButtonIndex != -1) {
		buttonIndex -= actionSheet.firstOtherButtonIndex;
	} else {
		// here is a bug in UIKit, fix it
		if (actionSheet.cancelButtonIndex != -1) {
			--buttonIndex;
		}
		if (actionSheet.destructiveButtonIndex != -1) {
			--buttonIndex;
		}
	}
	NSAssert(buttonIndex >= 0, @"error: %d", (int)buttonIndex);
	
	// onClick:N
	NSString * actionName = [[NSString alloc] initWithFormat:@"onClick:%d", (int)buttonIndex];
	SCDoEvent(actionName, actionSheet);
	[actionName release];
}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void) actionSheetCancel:(UIActionSheet *)actionSheet
{
	SCDoEvent(@"onCancel", actionSheet);
}

//- (void)willPresentActionSheet:(UIActionSheet *)actionSheet;  // before animation and showing view
//- (void)didPresentActionSheet:(UIActionSheet *)actionSheet;  // after animation
//
//- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex; // before animation and hiding view
//- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation

@end
