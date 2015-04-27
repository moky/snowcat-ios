//
//  SCActionActionSheet.m
//  SnowCat
//
//  Created by  root on 14-12-29.
//  Copyright (c) 2014 Ceezy. All rights reserved.
//

#import "SCLog.h"
#import "SCActionSheet.h"
#import "SCActionActionSheet.h"

@implementation SCActionActionSheet

- (BOOL) runWithResponder:(id)responder
{
	NSDictionary * view = [_dict objectForKey:@"view"];
	if (view) {
		SCActionSheetWithDictionary(view, responder);
	} else {
		NSAssert(false, @"action sheet view error: %@", _dict);
		return NO;
	}
	
	return YES;
}

@end
