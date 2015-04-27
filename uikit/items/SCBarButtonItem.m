//
//  SCBarButtonItem.m
//  SnowCat
//
//  Created by Moky on 14-3-26.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCImage.h"
#import "SCView.h"
#import "SCBarButtonItem.h"

//typedef NS_ENUM(NSInteger, UIBarMetrics) {
//    UIBarMetricsDefault,
//    UIBarMetricsLandscapePhone,
//};
UIBarMetrics UIBarMetricsFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Default")
			return UIBarMetricsDefault;
		SC_SWITCH_CASE(string, @"Phone")
			return UIBarMetricsLandscapePhone;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

//typedef NS_ENUM(NSInteger, UIBarButtonItemStyle) {
//    UIBarButtonItemStylePlain,    // shows glow when pressed
//    UIBarButtonItemStyleBordered,
//    UIBarButtonItemStyleDone,
//};
UIBarButtonItemStyle UIBarButtonItemStyleFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Plain")
			return UIBarButtonItemStylePlain;
		SC_SWITCH_CASE(string, @"Border")
			return UIBarButtonItemStyleBordered;
		SC_SWITCH_CASE(string, @"Done")
			return UIBarButtonItemStyleDone;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

//typedef NS_ENUM(NSInteger, UIBarButtonSystemItem) {
//    UIBarButtonSystemItemDone,
//    UIBarButtonSystemItemCancel,
//    UIBarButtonSystemItemEdit,
//    UIBarButtonSystemItemSave,
//    UIBarButtonSystemItemAdd,
//    UIBarButtonSystemItemFlexibleSpace,
//    UIBarButtonSystemItemFixedSpace,
//    UIBarButtonSystemItemCompose,
//    UIBarButtonSystemItemReply,
//    UIBarButtonSystemItemAction,
//    UIBarButtonSystemItemOrganize,
//    UIBarButtonSystemItemBookmarks,
//    UIBarButtonSystemItemSearch,
//    UIBarButtonSystemItemRefresh,
//    UIBarButtonSystemItemStop,
//    UIBarButtonSystemItemCamera,
//    UIBarButtonSystemItemTrash,
//    UIBarButtonSystemItemPlay,
//    UIBarButtonSystemItemPause,
//    UIBarButtonSystemItemRewind,
//    UIBarButtonSystemItemFastForward,
//#if __IPHONE_3_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED
//    UIBarButtonSystemItemUndo,
//    UIBarButtonSystemItemRedo,
//#endif
//#if __IPHONE_4_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED
//    UIBarButtonSystemItemPageCurl,
//#endif
//};
UIBarButtonSystemItem UIBarButtonSystemItemFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Done")
			return UIBarButtonSystemItemDone;
		SC_SWITCH_CASE(string, @"Cancel")
			return UIBarButtonSystemItemCancel;
		SC_SWITCH_CASE(string, @"Edit")
			return UIBarButtonSystemItemEdit;
		SC_SWITCH_CASE(string, @"Save")
			return UIBarButtonSystemItemSave;
		SC_SWITCH_CASE(string, @"Add")
			return UIBarButtonSystemItemAdd;
		SC_SWITCH_CASE(string, @"Flexible")
			return UIBarButtonSystemItemFlexibleSpace;
		SC_SWITCH_CASE(string, @"Fixed")
			return UIBarButtonSystemItemFixedSpace;
		SC_SWITCH_CASE(string, @"Compose")
			return UIBarButtonSystemItemCompose;
		SC_SWITCH_CASE(string, @"Reply")
			return UIBarButtonSystemItemReply;
		SC_SWITCH_CASE(string, @"Action")
			return UIBarButtonSystemItemAction;
		SC_SWITCH_CASE(string, @"Organize")
			return UIBarButtonSystemItemOrganize;
		SC_SWITCH_CASE(string, @"Book")
			return UIBarButtonSystemItemBookmarks;
		SC_SWITCH_CASE(string, @"Search")
			return UIBarButtonSystemItemSearch;
		SC_SWITCH_CASE(string, @"Refresh")
			return UIBarButtonSystemItemRefresh;
		SC_SWITCH_CASE(string, @"Stop")
			return UIBarButtonSystemItemStop;
		SC_SWITCH_CASE(string, @"Camera")
			return UIBarButtonSystemItemCamera;
		SC_SWITCH_CASE(string, @"Trash")
			return UIBarButtonSystemItemTrash;
		SC_SWITCH_CASE(string, @"Play")
			return UIBarButtonSystemItemPlay;
		SC_SWITCH_CASE(string, @"Pause")
			return UIBarButtonSystemItemPause;
		SC_SWITCH_CASE(string, @"Rewind")
			return UIBarButtonSystemItemRewind;
		SC_SWITCH_CASE(string, @"FastForward")
			return UIBarButtonSystemItemFastForward;
#if __IPHONE_3_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED
		SC_SWITCH_CASE(string, @"Undo")
			return UIBarButtonSystemItemUndo;
		SC_SWITCH_CASE(string, @"Redo")
			return UIBarButtonSystemItemRedo;
#endif
#if __IPHONE_4_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED
		SC_SWITCH_CASE(string, @"Page")
			return UIBarButtonSystemItemPageCurl;
#endif
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

@implementation SCBarButtonItem

//- (id)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;
//- (id)initWithImage:(UIImage *)image landscapeImagePhone:(UIImage *)landscapeImagePhone style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action NS_AVAILABLE_IOS(5_0); // landscapeImagePhone will be used for the bar button image in landscape bars in UIUserInterfaceIdiomPhone only
//- (id)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;
//- (id)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem target:(id)target action:(SEL)action;
//- (id)initWithCustomView:(UIView *)customView;

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	UIResponder * target = [dict objectForKey:@"target"];
	NSString * action = [dict objectForKey:@"action"];
	SEL selector = action ? NSSelectorFromString(action) : nil;
	if (![target respondsToSelector:selector]) {
		selector = NULL;
	}
	
	// initWithImage:style:target:action:
	id image = [dict objectForKey:@"image"];
	if (image) {
		image = [SCImage create:image autorelease:NO];
	}
	UIBarButtonItemStyle style = UIBarButtonItemStyleFromString([dict objectForKey:@"style"]);
	
	// initWithImage:landscapeImagePhone:style:target:action:
	id landscapeImagePhone = [dict objectForKey:@"landscapeImagePhone"];
	if (landscapeImagePhone) {
		landscapeImagePhone = [SCImage create:landscapeImagePhone autorelease:NO];
	}
	
	// initWithTitle:style:target:action:
	NSString * title = [dict objectForKey:@"title"];
	
	// initWithCustomView:
	NSDictionary * customView = [dict objectForKey:@"customView"];
	
	if (landscapeImagePhone) {
		self = [self initWithImage:image landscapeImagePhone:landscapeImagePhone style:style target:target action:selector];
	} else if (image) {
		self = [self initWithImage:image style:style target:target action:selector];
	} else if (title) {
		title = SCLocalizedString(title, nil);
		self = [self initWithTitle:title style:style target:target action:selector];
	} else if (customView) {
		SCView * view = [SCView create:customView autorelease:NO];
		self = [self initWithCustomView:view];
		SC_UIKIT_SET_ATTRIBUTES(view, SCView, customView);
		[view release];
	} else {
		NSString * barButtonSystemItem = [dict objectForKey:@"barButtonSystemItem"];
		UIBarButtonSystemItem item = UIBarButtonSystemItemFromString(barButtonSystemItem);
		self = [self initWithBarButtonSystemItem:item target:target action:selector];
	}
	
	[image release];
	[landscapeImagePhone release];
	
	if (self) {
	}
	return self;
}

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIBarButtonItem *)barButtonItem
{
	if (![SCBarItem setAttributes:dict to:barButtonItem]) {
		return NO;
	}
	
	// style (init..)
	
	// width
	id width = [dict objectForKey:@"width"];
	if (width) {
		barButtonItem.width = [width floatValue];
	}
	
	// possibleTitles
	
	// customView (init..)
	
	// action (init..)
	
	// target (init..)
	
	// setBackgroundImage:forState:...
	
	return YES;
}

@end
