//
//  SCToolbar.m
//  SnowCat
//
//  Created by Moky on 14-4-3.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCLog.h"
#import "SCClient.h"
#import "SCNib.h"
#import "SCEventHandler.h"
#import "SCInterface.h"
#import "SCColor.h"
#import "SCBarButtonItem.h"
#import "SCToolbar.h"

//typedef NS_ENUM(NSInteger, UIToolbarPosition) {
//    UIToolbarPositionAny = 0,
//    UIToolbarPositionBottom = 1,
//    UIToolbarPositionTop = 2,
//};
UIToolbarPosition UIToolbarPositionFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Any")
			return UIToolbarPositionAny;
		SC_SWITCH_CASE(string, @"Bottom")
			return UIToolbarPositionBottom;
		SC_SWITCH_CASE(string, @"Top")
			return UIToolbarPositionTop;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

@implementation SCToolbar

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib

- (void) dealloc
{
	[_nodeFile release];
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		_scTag = 0;
		self.nodeFile = nil;
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		_scTag = 0;
		self.nodeFile = nil;
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	self = [self initWithFrame:CGRectZero];
	if (self) {
		[self buildHandlers:dict];
	}
	return self;
}

// buildHandlers:
SC_UIKIT_IMELEMENT_BUILD_HANDLERS_FUNCTION()

// awakeFromNib
SC_UIKIT_IMPLEMENT_AWAKE_FUNCTION()

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIToolbar *)toolbar
{
	// set general attributes after
	if (![SCView setAttributes:dict to:toolbar]) {
		return NO;
	}
	
	// barStyle
	NSString * barStyle = [dict objectForKey:@"barStyle"];
	if (barStyle) {
		toolbar.barStyle = UIBarStyleFromString(barStyle);
	}
	
	// items(UIBarButtonItem)
	NSArray * items = [dict objectForKey:@"items"];
	if (items) {
		NSUInteger count = [items count];
		NSMutableArray * mArray = [[NSMutableArray alloc] initWithCapacity:count];
		NSEnumerator * enumerator = [items objectEnumerator];
		NSDictionary * item;
		SCBarButtonItem * bbi;
		while (item = [enumerator nextObject]) {
			NSAssert([item isKindOfClass:[NSDictionary class]], @"item must be a dictionary: %@", item);
			NSMutableDictionary * md = [item mutableCopy];
			[md setObject:toolbar forKey:@"target"];
			[md setObject:SCToolbarItemDelegate_clickToolbarItems forKey:@"action"];
			
			bbi = [SCBarButtonItem create:md autorelease:NO];
			NSAssert([bbi isKindOfClass:[UIBarButtonItem class]], @"bar button item's definition error: %@", md);
			if (bbi) {
				SC_UIKIT_SET_ATTRIBUTES(bbi, SCBarButtonItem, md);
				[mArray addObject:bbi];
				[bbi release];
			}
			
			[md release];
		}
		toolbar.items = mArray;
		[mArray release];
	}
	
	// translucent
	id translucent = [dict objectForKey:@"translucent"];
	if (translucent) {
		toolbar.translucent = [translucent boolValue];
	}
	
	// tintColor
	id tintColor = [dict objectForKey:@"tintColor"];
	if (tintColor) {
		SCColor * color = [SCColor create:tintColor autorelease:NO];
		toolbar.tintColor = color;
		[color release];
	}
	
#ifdef __IPHONE_7_0
	
	CGFloat systemVersion = SCSystemVersion();
	if (systemVersion >= 7.0f) {
		
		// barTintColor
		id barTintColor = [dict objectForKey:@"barTintColor"];
		if (barTintColor) {
			SCColor * color = [SCColor create:barTintColor autorelease:NO];
			toolbar.barTintColor = color;
			[color release];
		}
		
	}
	
#endif
	
	return YES;
}

// event: toolbarItems[x].onClick
- (void) clickToolbarItems:(id)sender
{
	NSArray * array = self.items;
	NSUInteger index = array ? [array indexOfObject:sender] : NSNotFound;
	NSAssert(index != NSNotFound, @"no such item: %@", sender);
	
	NSString * event = [[NSString alloc] initWithFormat:@"toolbarItems[%u].onClick", (unsigned int)index];
	SCDoEvent(event, sender);
	[event release];
}

@end
