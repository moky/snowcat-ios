//
//  SCCollectionViewFlowLayout.m
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
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
	
	SC_SET_ATTRIBUTES_AS_FLOAT(collectionViewFlowLayout, dict, minimumLineSpacing);
	SC_SET_ATTRIBUTES_AS_FLOAT(collectionViewFlowLayout, dict, minimumInteritemSpacing);
	
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
	
	SC_SET_ATTRIBUTES_AS_UIEDGEINSETS(collectionViewFlowLayout, dict, sectionInset);
	
	return YES;
}

@end
