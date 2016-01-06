//
//  SCCollectionViewLayoutAttributes.m
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCIndexPath.h"
#import "SCCollectionViewLayoutAttributes.h"

@implementation SCCollectionViewLayoutAttributes

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

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UICollectionViewLayoutAttributes *)collectionViewLayoutAttributes
{
	NSAssert([dict isKindOfClass:[NSDictionary class]], @"parameters error: %@", dict);
	
	// frame
	NSString * frame = [dict objectForKey:@"frame"];
	if (frame) {
		collectionViewLayoutAttributes.frame = CGRectFromString(frame);
	}
	
	// center
	NSString * center = [dict objectForKey:@"center"];
	if (center) {
		collectionViewLayoutAttributes.center = CGPointFromString(center);
	}
	
	// size
	NSString * size = [dict objectForKey:@"size"];
	if (size) {
		collectionViewLayoutAttributes.size = CGSizeFromString(size);
	}
	
	// transform3D
	
	SC_SET_ATTRIBUTES_AS_FLOAT  (collectionViewLayoutAttributes, dict, alpha);
	SC_SET_ATTRIBUTES_AS_INTEGER(collectionViewLayoutAttributes, dict, zIndex);
	SC_SET_ATTRIBUTES_AS_BOOL   (collectionViewLayoutAttributes, dict, hidden);
	
	// indexPath
	NSDictionary * indexPath = [dict objectForKey:@"indexPath"];
	if (indexPath) {
		NSIndexPath * ip = [SCIndexPath create:indexPath];
		NSAssert([ip isKindOfClass:[NSIndexPath class]], @"indexPath's definition error: %@", indexPath);
		collectionViewLayoutAttributes.indexPath = ip;
	}
	
	return YES;
}

@end
