//
//  SCIndexPath.m
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SCObject.h"
#import "SCIndexPath.h"

@implementation SCIndexPath

// create:
SC_IMPLEMENT_CREATE_FUNCTION()
+ (id) create:(NSDictionary *)dict autorelease:(BOOL)autorelease
{
	NSIndexPath * indexPath = nil;
	
	do {
		// initWithIndex:
		id index = [dict objectForKey:@"index"];
		if (index) {
			indexPath = [[NSIndexPath alloc] initWithIndex:[index integerValue]];
			break;
		}
		
		// initWithIndex:length:
		NSArray * indexes = [dict objectForKey:@"indexes"];
		if (indexes) {
			NSUInteger count = [indexes count];
			NSUInteger array[count];
			for (NSUInteger i = 0; i < count; ++i) {
				array[i] = [[indexes objectAtIndex:i] integerValue];
			}
			indexPath = [[NSIndexPath alloc] initWithIndexes:array length:count];
			break;
		}
		
		// indexPathForRow:inSection:
		id row = [dict objectForKey:@"row"];
		id section = [dict objectForKey:@"section"];
		if (row && section) {
			indexPath = [NSIndexPath indexPathForRow:[row integerValue] inSection:[section interfaceOrientation]];
			[indexPath retain];
			break;
		}
		
		// indexPathForItem:inSection:
		id item = [dict objectForKey:@"item"];
		if (item && section) {
			indexPath = [NSIndexPath indexPathForItem:[item integerValue] inSection:[section integerValue]];
			[indexPath retain];
			break;
		}
		
		break;
	} while (YES);
	
	if (autorelease) {
		return [indexPath autorelease];
	} else {
		return indexPath;
	}
}

@end
