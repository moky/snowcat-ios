//
//  SCCollectionViewLayout.m
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCCollectionViewLayout.h"

//typedef NS_ENUM(NSUInteger, UICollectionElementCategory) {
//    UICollectionElementCategoryCell,
//    UICollectionElementCategorySupplementaryView,
//    UICollectionElementCategoryDecorationView
//};
UICollectionElementCategory UICollectionElementCategoryFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Cell")
			return UICollectionElementCategoryCell;
		SC_SWITCH_CASE(string, @"Supplementary")
			return UICollectionElementCategorySupplementaryView;
		SC_SWITCH_CASE(string, @"Decoration")
			return UICollectionElementCategoryDecorationView;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

//typedef NS_ENUM(NSInteger, UICollectionUpdateAction) {
//    UICollectionUpdateActionInsert,
//    UICollectionUpdateActionDelete,
//    UICollectionUpdateActionReload,
//    UICollectionUpdateActionMove,
//    UICollectionUpdateActionNone
//};
UICollectionUpdateAction UICollectionUpdateActionFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Insert")
			return UICollectionUpdateActionInsert;
		SC_SWITCH_CASE(string, @"Delete")
			return UICollectionUpdateActionDelete;
		SC_SWITCH_CASE(string, @"Reload")
			return UICollectionUpdateActionReload;
		SC_SWITCH_CASE(string, @"Move")
			return UICollectionUpdateActionMove;
		SC_SWITCH_CASE(string, @"None")
			return UICollectionUpdateActionNone;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

@implementation SCCollectionViewLayout

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	self = [self init];
	if (self) {
	}
	return self;
}

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UICollectionViewLayout *)collectionViewLayout
{
	NSAssert([dict isKindOfClass:[NSDictionary class]], @"parameters error: %@", dict);
	
	return YES;
}

@end
