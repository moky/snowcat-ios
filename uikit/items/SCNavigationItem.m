//
//  SCNavigationItem.m
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCView.h"
#import "SCBarButtonItem.h"
#import "SCNavigationItem.h"

@implementation SCNavigationItem

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	NSString * title = [dict objectForKey:@"title"];
	if (title) {
		title = SCLocalizedString(title, nil);
	}
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
	
	//
	// because the navigationItem may be readonly,
	// in this case, the '-[initWithDictionary:]' will not be called,
	// so we should set title here...
	//
	// see '<UINavigationController.h:119> : UIViewController (UINavigationControllerItem)'
	//     '<SCViewController.m:291>       : +[_setNavigationControllerAttributes:to:]'
	//
	SC_SET_ATTRIBUTES_AS_LOCALIZED_STRING(navigationItem, dict, title);
	
#if !TARGET_OS_TV
	// backBarButtonItem
	NSDictionary * backBarButtonItem = [dict objectForKey:@"backBarButtonItem"];
	if (backBarButtonItem) {
		NSAssert([backBarButtonItem isKindOfClass:[NSDictionary class]], @"backBarButtonItem must be a dictionary: %@", backBarButtonItem);
		backBarButtonItem = [self _newDictionary:backBarButtonItem withTarget:target withAction:SCNavigationItemDelegate_clickBackBarButtonItem]; // on backBarButtonItem clicked
		
		SCBarButtonItem * bbi = [SCBarButtonItem create:backBarButtonItem];
		NSAssert([bbi isKindOfClass:[UIBarButtonItem class]], @"backBarButtonItem's definition error: %@", backBarButtonItem);
		navigationItem.backBarButtonItem = bbi;
		SC_UIKIT_SET_ATTRIBUTES(bbi, SCBarButtonItem, backBarButtonItem);
		
		[backBarButtonItem release];
	}
#endif
	
	// titleView
	NSDictionary * titleView = [dict objectForKey:@"titleView"];
	if (titleView) {
		NSAssert([titleView isKindOfClass:[NSDictionary class]], @"titleView must be a dictionary: %@", titleView);
		SCView * view = [SCView create:titleView];
		NSAssert([view isKindOfClass:[UIView class]], @"titleView's definition error: %@", titleView);
		navigationItem.titleView = view;
		SC_UIKIT_SET_ATTRIBUTES(view, SCView, titleView);
	}
	
#if !TARGET_OS_TV
	SC_SET_ATTRIBUTES_AS_LOCALIZED_STRING(navigationItem, dict, prompt);
	SC_SET_ATTRIBUTES_AS_BOOL            (navigationItem, dict, hidesBackButton);
#endif
	
	// leftBarButtonItems
	NSArray * leftBarButtonItems = [dict objectForKey:@"leftBarButtonItems"];
	if (leftBarButtonItems) {
		NSAssert([leftBarButtonItems isKindOfClass:[NSArray class]], @"leftBarButtonItems must be an array: %@", leftBarButtonItems);
		NSUInteger count = [leftBarButtonItems count];
		NSMutableArray * mArray = [[NSMutableArray alloc] initWithCapacity:count];
		
		NSDictionary * item;
		SCBarButtonItem * bbi;
		SC_FOR_EACH(item, leftBarButtonItems) {
			NSAssert([item isKindOfClass:[NSDictionary class]], @"leftBarButtonItems's item must be a dictionary: %@", item);
			item = [self _newDictionary:item withTarget:target withAction:SCNavigationItemDelegate_clickLeftBarButtonItems]; // on leftBarButtonItems clicked
			
			bbi = [SCBarButtonItem create:item];
			NSAssert([bbi isKindOfClass:[UIBarButtonItem class]], @"leftBarButtonItems item's definition error: %@", item);
			SC_UIKIT_SET_ATTRIBUTES(bbi, SCBarButtonItem, item);
			SCArrayAddObject(mArray, bbi);
			
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
		
		NSDictionary * item;
		SCBarButtonItem * bbi;
		SC_FOR_EACH(item, rightBarButtonItems) {
			NSAssert([item isKindOfClass:[NSDictionary class]], @"rightBarButtonItems's item must be a dictionary: %@", item);
			item = [self _newDictionary:item withTarget:target withAction:SCNavigationItemDelegate_clickRightBarButtonItems]; // on rightBarButtonItems clicked
			
			bbi = [SCBarButtonItem create:item];
			NSAssert([bbi isKindOfClass:[UIBarButtonItem class]], @"rightBarButtonItems item's definition error: %@", item);
			SC_UIKIT_SET_ATTRIBUTES(bbi, SCBarButtonItem, item);
			SCArrayAddObject(mArray, bbi);
			
			[item release];
		}
		
		navigationItem.rightBarButtonItems = mArray;
		[mArray release];
	}
	
#if !TARGET_OS_TV
	SC_SET_ATTRIBUTES_AS_BOOL(navigationItem, dict, leftItemsSupplementBackButton);
#endif
	
	// leftBarButtonItem
	NSDictionary * leftBarButtonItem = [dict objectForKey:@"leftBarButtonItem"];
	if (leftBarButtonItem) {
		NSAssert([leftBarButtonItem isKindOfClass:[NSDictionary class]], @"leftBarButtonItem must be a dictionary: %@", leftBarButtonItem);
		leftBarButtonItem = [self _newDictionary:leftBarButtonItem withTarget:target withAction:SCNavigationItemDelegate_clickLeftBarButtonItem]; // on leftBarButtonItem clicked
		
		SCBarButtonItem * bbi = [SCBarButtonItem create:leftBarButtonItem];
		NSAssert([bbi isKindOfClass:[UIBarButtonItem class]], @"leftBarButtonItem's definition error: %@", leftBarButtonItem);
		navigationItem.leftBarButtonItem = bbi;
		SC_UIKIT_SET_ATTRIBUTES(bbi, SCBarButtonItem, leftBarButtonItem);
		
		[leftBarButtonItem release];
	}
	
	// rightBarButtonItem
	NSDictionary * rightBarButtonItem = [dict objectForKey:@"rightBarButtonItem"];
	if (rightBarButtonItem) {
		NSAssert([rightBarButtonItem isKindOfClass:[NSDictionary class]], @"rightBarButtonItem must be a dictionary: %@", rightBarButtonItem);
		rightBarButtonItem = [self _newDictionary:rightBarButtonItem withTarget:target withAction:SCNavigationItemDelegate_clickRightBarButtonItem]; // on rightBarButtonItem clicked
		
		SCBarButtonItem * bbi = [SCBarButtonItem create:rightBarButtonItem];
		NSAssert([bbi isKindOfClass:[UIBarButtonItem class]], @"rightBarButtonItem's definition error: %@", rightBarButtonItem);
		navigationItem.rightBarButtonItem = bbi;
		SC_UIKIT_SET_ATTRIBUTES(bbi, SCBarButtonItem, rightBarButtonItem);
		
		[rightBarButtonItem release];
	}
	
	return YES;
}

@end
