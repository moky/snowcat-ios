//
//  SCRefreshControl.m
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCAttributedString.h"
#import "SCColor.h"
#import "SCEventHandler.h"
#import "SCRefreshControl.h"

@implementation SCRefreshControl

- (void) dealloc
{
	[self removeTarget:self action:@selector(onChange:) forControlEvents:UIControlEventValueChanged];
	
	[SCResponder onDestroy:self];
	[super dealloc];
}

/* The designated initializer
 * This initializes a UIRefreshControl with a default height and width.
 * Once assigned to a UITableViewController, the frame of the control is managed automatically.
 * When a user has pulled-to-refresh, the UIRefreshControl fires its UIControlEventValueChanged event.
 */
- (instancetype) init
{
	self = [super init];
	if (self) {
		// Note that the target is not retained.
		[self addTarget:self action:@selector(onChange:) forControlEvents:UIControlEventValueChanged];
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	self = [self init];
	if (self) {
		[self buildHandlers:dict];
	}
	return self;
}

// buildHandlers:
SC_UIKIT_IMELEMENT_BUILD_HANDLERS_FUNCTION()

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIRefreshControl *)refreshControl
{
	if (![SCControl setAttributes:dict to:refreshControl]) {
		return NO;
	}
	
	// tintColor
	NSDictionary * tintColor = [dict objectForKey:@"tintColor"];
	if (tintColor) {
		SCColor * color = [SCColor create:tintColor autorelease:NO];
		refreshControl.tintColor = color;
		[color release];
	}
	
	// attributedTitle
	NSDictionary * attributedTitle = [dict objectForKey:@"attributedTitle"];
	if (attributedTitle) {
		NSAttributedString * as = [SCAttributedString create:attributedTitle autorelease:NO];
		NSAssert([as isKindOfClass:[NSAttributedString class]], @"error attributed title: %@", attributedTitle);
		refreshControl.attributedTitle = as;
		[as release];
	}
	
	return YES;
}

#pragma mark - Value Event Interfaces

- (void) onChange:(id)sender
{
	SCLog(@"onChange: %@", sender);
	SCDoEvent(@"onChange", sender);
}

@end
