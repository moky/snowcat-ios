//
//  SCTextViewDelegate.m
//  SnowCat
//
//  Created by Moky on 14-4-3.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCEventHandler.h"
#import "SCTextViewDelegate.h"

@implementation SCTextViewDelegate

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

#pragma mark - UITextViewDelegate

//@optional
//
//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
//- (BOOL)textViewShouldEndEditing:(UITextView *)textView;
//
//- (void)textViewDidBeginEditing:(UITextView *)textView;
//- (void)textViewDidEndEditing:(UITextView *)textView;
//
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

- (void) textViewDidChange:(UITextView *)textView
{
	SCLog(@"textViewDidChange: %@", textView);
	SCDoEvent(@"onChange", textView);
}

//
//- (void)textViewDidChangeSelection:(UITextView *)textView;

@end
