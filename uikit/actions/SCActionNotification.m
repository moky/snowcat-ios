//
//  SCActionNotification.m
//  SnowCat
//
//  Created by Moky on 14-3-24.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCActionNotification.h"

@implementation SCActionNotification

- (BOOL) runWithResponder:(id)responder
{
	NSString * event = [_dict objectForKey:@"event"];
	NSAssert([event length] > 0, @"event name cannot be empty: %@", _dict);
	SCLog(@"event: %@", _dict);
	
	NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:event object:responder userInfo:_dict];
	return YES;
}

@end
