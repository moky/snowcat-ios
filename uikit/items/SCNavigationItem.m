//
//  SCNavigationItem.m
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCView.h"
#import "SCBarButtonItem.h"
#import "SCNavigationItem.h"

@implementation SCNavigationItem

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	NSString * title = [dict objectForKey:@"title"];
	title = SCLocalizedString(title, nil);
	self = [self initWithTitle:title];
	if (self) {
	}
	return self;
}

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (NSDictionary *) _newDictionary:(NSDictionary *)dict withTarget:(UIResponder *)target withAction:(NSString *)action
{
	if (!target || !action) {
		return [dict retain];
	}
	NSMutableDictionary * md = [dict mutableCopy];
	[md setObject:target forKey:@"target"];
	[md setObject:action forKey:@"action"];
	return md;
}

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UINavigationItem *)navigationItem
{
	NSAssert([dict isKindOfClass:[NSDictionary class]], @"parameters error: %@", dict);
	
	UIResponder * target = [dict objectForKey:@"target"];
	
	// title (init..)
	
	// backBarButtonItem
	NSDictionary * backBarButtonItem = [dict objectForKey:@"backBarButtonItem"];
	if (backBarButtonItem) {
		NSAssert([backBarButtonItem isKindOfClass:[NSDictionary class]], @"backBarButtonItem must be a dictionary: %@", backBarButtonItem);
		backBarButtonItem = [self _newDictionary:backBarButtonItem withTarget:target withAction:SCNavigationItemDelegate_clickBackBarButtonItem]; // on backBarButtonItem clicked
		
		SCBarButtonItem * bbi = [SCBarButtonItem create:backBarButtonItem autorelease:NO];
		NSAssert([bbi isKindOfClass:[UIBarButtonItem class]], @"backBarButtonItem's definition error: %@", backBarButtonItem);
		navigationItem.backBarButtonItem = bbi;
		SC_UIKIT_SET_ATTRIBUTES(bbi, SCBarButtonItem, backBarButtonItem);
		[bbi release];
		
		[backBarButtonItem release];
	}
	
	// titleView
	NSDictionary * titleView = [dict objectForKey:@"titleView"];
	if (titleView) {
		NSAssert([titleView isKindOfClass:[NSDictionary class]], @"titleView must be a dictionary: %@", titleView);
		SCView * view = [SCView create:titleView autorelease:NO];
		NSAssert([view isKindOfClass:[UIView class]], @"titleView's definition error: %@", titleView);
		navigationItem.titleView = view;
		SC_UIKIT_SET_ATTRIBUTES(view, SCView, titleView);
		[view release];
	}
	
	// prompt
	NSString * prompt = [dict objectForKey:@"prompt"];
	if (prompt) {
		prompt = SCLocalizedString(prompt, nil);
		navigationItem.prompt = prompt;
	}
	
	// hidesBackButton
	id hidesBackButton = [dict objectForKey:@"hidesBackButton"];
	if (hidesBackButton) {
		navigationItem.hidesBackButton = [hidesBackButton boolValue];
	}
	
	// leftBarButtonItems
	NSArray * leftBarButtonItems = [dict objectForKey:@"leftBarButtonItems"];
	if (leftBarButtonItems) {
		NSAssert([leftBarButtonItems isKindOfClass:[NSArray class]], @"leftBarButtonItems must be an array: %@", leftBarButtonItems);
		NSUInteger count = [leftBarButtonItems count];
		NSMutableArray * mArray = [[NSMutableArray alloc] initWithCapacity:count];
		
		NSEnumerator * enumerator = [leftBarButtonItems objectEnumerator];
		NSDictionary * item;
		SCBarButtonItem * bbi;
		while (item = [enumerator nextObject]) {
			NSAssert([item isKindOfClass:[NSDictionary class]], @"leftBarButtonItems's item must be a dictionary: %@", item);
			item = [self _newDictionary:item withTarget:target withAction:SCNavigationItemDelegate_clickLeftBarButtonItems]; // on leftBarButtonItems clicked
			bbi = [SCBarButtonItem create:item autorelease:NO];
			NSAssert([bbi isKindOfClass:[UIBarButtonItem class]], @"leftBarButtonItems item's definition error: %@", item);
			if (bbi) {
				SC_UIKIT_SET_ATTRIBUTES(bbi, SCBarButtonItem, item);
				[mArray addObject:bbi];
				[bbi release];
			}
			[item release];
		}
		
		navigationItem.leftBarButtonItems = mArray;
		[mArray release];
	}
	
	// rightBarButtonItems
	NSArray * rightBarButtonItems = [dict objectForKey:@"rightBarButtonItems"];
	if (rightBarButtonItems) {
		NSAssert([rightBarButtonItems isKindOfClass:[NSArray class]], @"rightBarButtonItems must be an array: %@", rightBarButtonItems);
		NSUInteger count = [rightBarButtonItems count];
		NSMutableArray * mArray = [[NSMutableArray alloc] initWithCapacity:count];
		
		NSEnumerator * enumerator = [rightBarButtonItems objectEnumerator];
		NSDictionary * item;
		SCBarButtonItem * bbi;
		while (item = [enumerator nextObject]) {
			NSAssert([item isKindOfClass:[NSDictionary class]], @"rightBarButtonItems's item must be a dictionary: %@", item);
			item = [self _newDictionary:item withTarget:target withAction:SCNavigationItemDelegate_clickRightBarButtonItems]; // on rightBarButtonItems clicked
			bbi = [SCBarButtonItem create:item autorelease:NO];
			NSAssert([bbi isKindOfClass:[UIBarButtonItem class]], @"rightBarButtonItems item's definition error: %@", item);
			if (bbi) {
				SC_UIKIT_SET_ATTRIBUTES(bbi, SCBarButtonItem, item);
				[mArray addObject:bbi];
				[bbi release];
			}
			[item release];
		}
		
		navigationItem.rightBarButtonItems = mArray;
		[mArray release];
	}
	
	// leftItemsSupplementBackButton
	id leftItemsSupplementBackButton = [dict objectForKey:@"leftItemsSupplementBackButton"];
	if (leftItemsSupplementBackButton) {
		navigationItem.leftItemsSupplementBackButton = [leftItemsSupplementBackButton boolValue];
	}
	
	// leftBarButtonItem
	NSDictionary * leftBarButtonItem = [dict objectForKey:@"leftBarButtonItem"];
	if (leftBarButtonItem) {
		NSAssert([leftBarButtonItem isKindOfClass:[NSDictionary class]], @"leftBarButtonItem must be a dictionary: %@", leftBarButtonItem);
		leftBarButtonItem = [self _newDictionary:leftBarButtonItem withTarget:target withAction:SCNavigationItemDelegate_clickLeftBarButtonItem]; // on leftBarButtonItem clicked
		
		SCBarButtonItem * bbi = [SCBarButtonItem create:leftBarButtonItem autorelease:NO];
		NSAssert([bbi isKindOfClass:[UIBarButtonItem class]], @"leftBarButtonItem's definition error: %@", leftBarButtonItem);
		navigationItem.leftBarButtonItem = bbi;
		SC_UIKIT_SET_ATTRIBUTES(bbi, SCBarButtonItem, leftBarButtonItem);
		[bbi release];
		
		[leftBarButtonItem release];
	}
	
	// rightBarButtonItem
	NSDictionary * rightBarButtonItem = [dict objectForKey:@"rightBarButtonItem"];
	if (rightBarButtonItem) {
		NSAssert([rightBarButtonItem isKindOfClass:[NSDictionary class]], @"rightBarButtonItem must be a dictionary: %@", rightBarButtonItem);
		rightBarButtonItem = [self _newDictionary:rightBarButtonItem withTarget:target withAction:SCNavigationItemDelegate_clickRightBarButtonItem]; // on rightBarButtonItem clicked
		
		SCBarButtonItem * bbi = [SCBarButtonItem create:rightBarButtonItem autorelease:NO];
		NSAssert([bbi isKindOfClass:[UIBarButtonItem class]], @"rightBarButtonItem's definition error: %@", rightBarButtonItem);
		navigationItem.rightBarButtonItem = bbi;
		SC_UIKIT_SET_ATTRIBUTES(bbi, SCBarButtonItem, rightBarButtonItem);
		[bbi release];
		
		[rightBarButtonItem release];
	}
	
	return YES;
}

@end
