//
//  SCViewController+Callback.m
//  SnowCat
//
//  Created by Moky on 14-6-5.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCEventHandler.h"
#import "SCViewController.h"

@implementation UIViewController (SCNavigationItemDelegate)

// event: backBarButtonItem.onClick
- (void) clickBackBarButtonItem:(id)sender
{
	NSString * event = @"backBarButtonItem.onClick";
	SCLog(@"%@: %@", event, sender);
	
	id<SCEventDelegate> delegate = [SCEventHandler delegateForResponder:self];
	if (delegate) {
		[delegate doEvent:event withResponder:self];
	}
}

// event: leftBarButtonItems[x].onClick
- (void) clickLeftBarButtonItems:(id)sender
{
	NSArray * array = self.navigationItem.leftBarButtonItems;
	NSUInteger index = array ? [array indexOfObject:sender] : NSNotFound;
	NSAssert(index != NSNotFound, @"no such item: %@", sender);
	
	NSString * event = [[NSString alloc] initWithFormat:@"leftBarButtonItems[%u].onClick", (unsigned int)index];
	SCLog(@"%@: %@", event, sender);
	
	id<SCEventDelegate> delegate = [SCEventHandler delegateForResponder:self];
	if (delegate) {
		[delegate doEvent:event withResponder:self];
	}
	
	[event release];
}

// event: rightBarButtonItems[x].onClick
- (void) clickRightBarButtonItems:(id)sender
{
	NSArray * array = self.navigationItem.rightBarButtonItems;
	NSUInteger index = array ? [array indexOfObject:sender] : NSNotFound;
	NSAssert(index != NSNotFound, @"no such item: %@", sender);
	
	NSString * event = [[NSString alloc] initWithFormat:@"rightBarButtonItems[%u].onClick", (unsigned int)index];
	SCLog(@"%@: %@", event, sender);
	
	id<SCEventDelegate> delegate = [SCEventHandler delegateForResponder:self];
	if (delegate) {
		[delegate doEvent:event withResponder:self];
	}
	
	[event release];
}

// event: leftBarButtonItem.onClick
- (void) clickLeftBarButtonItem:(id)sender
{
	NSString * event = @"leftBarButtonItem.onClick";
	SCLog(@"%@: %@", event, sender);
	
	id<SCEventDelegate> delegate = [SCEventHandler delegateForResponder:self];
	if (delegate) {
		[delegate doEvent:event withResponder:self];
	}
}

// event: rightBarButtonItem.onClick
- (void) clickRightBarButtonItem:(id)sender
{
	NSString * event = @"rightBarButtonItem.onClick";
	SCLog(@"%@: %@", event, sender);
	
	id<SCEventDelegate> delegate = [SCEventHandler delegateForResponder:self];
	if (delegate) {
		[delegate doEvent:event withResponder:self];
	}
}

@end

@implementation UIViewController (SCToolbarItemDelegate)

// event: toolbarItems[x].onClick
- (void) clickToolbarItems:(id)sender
{
	NSArray * array = self.toolbarItems;
	NSUInteger index = array ? [array indexOfObject:sender] : NSNotFound;
	NSAssert(index != NSNotFound, @"no such item: %@", sender);
	
	NSString * event = [[NSString alloc] initWithFormat:@"toolbarItems[%u].onClick", (unsigned int)index];
	SCLog(@"%@: %@", event, sender);
	
	id<SCEventDelegate> delegate = [SCEventHandler delegateForResponder:self];
	if (delegate) {
		[delegate doEvent:event withResponder:self];
	}
	
	[event release];
}

@end
