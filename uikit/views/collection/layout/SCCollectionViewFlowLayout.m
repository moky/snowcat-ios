//
//  SCCollectionViewFlowLayout.m
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCCollectionViewLayout.h"
#import "SCCollectionViewFlowLayout.h"

//typedef NS_ENUM(NSInteger, UICollectionViewScrollDirection) {
//    UICollectionViewScrollDirectionVertical,
//    UICollectionViewScrollDirectionHorizontal
//};
UICollectionViewScrollDirection UICollectionViewScrollDirectionFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Vertical")
			return UICollectionViewScrollDirectionVertical;
		SC_SWITCH_CASE(string, @"Horizontal")
			return UICollectionViewScrollDirectionHorizontal;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

@implementation SCCollectionViewFlowLayout

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

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UICollectionViewFlowLayout *)collectionViewFlowLayout
{
	if (![SCCollectionViewLayout setAttributes:dict to:collectionViewFlowLayout]) {
		return NO;
	}
	
	// minimumLineSpacing
	id minimumLineSpacing = [dict objectForKey:@"minimumLineSpacing"];
	if (minimumLineSpacing) {
		collectionViewFlowLayout.minimumLineSpacing = [minimumLineSpacing floatValue];
	}
	
	// minimumInteritemSpacing
	id minimumInteritemSpacing = [dict objectForKey:@"minimumInteritemSpacing"];
	if (minimumInteritemSpacing) {
		collectionViewFlowLayout.minimumInteritemSpacing = [minimumInteritemSpacing floatValue];
	}
	
	// itemSize
	NSString * itemSize = [dict objectForKey:@"itemSize"];
	if (itemSize) {
		collectionViewFlowLayout.itemSize = CGSizeFromString(itemSize);
	}
	
	// scrollDirection
	NSString * scrollDirection = [dict objectForKey:@"scrollDirection"];
	if (scrollDirection) {
		collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionFromString(scrollDirection);
	}
	
	// headerReferenceSize
	NSString * headerReferenceSize = [dict objectForKey:@"headerReferenceSize"];
	if (headerReferenceSize) {
		collectionViewFlowLayout.headerReferenceSize = CGSizeFromString(headerReferenceSize);
	}
	
	// footerReferenceSize
	NSString * footerReferenceSize = [dict objectForKey:@"footerReferenceSize"];
	if (footerReferenceSize) {
		collectionViewFlowLayout.footerReferenceSize = CGSizeFromString(footerReferenceSize);
	}
	
	// sectionInset
	NSString * sectionInset = [dict objectForKey:@"sectionInset"];
	if (sectionInset) {
		collectionViewFlowLayout.sectionInset = UIEdgeInsetsFromString(sectionInset);
	}
	
	return YES;
}

@end
