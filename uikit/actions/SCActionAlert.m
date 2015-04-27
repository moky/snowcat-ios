//
//  SCActionAlert.m
//  SnowCat
//
//  Created by Moky on 14-3-24.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCAlertView.h"
#import "SCActionAlert.h"

@implementation SCActionAlert

- (BOOL) runWithResponder:(id)responder
{
	NSDictionary * view = [_dict objectForKey:@"view"];
	if (view) {
		SCAlertWithDictionary(view);
	} else {
		NSString * title = [_dict objectForKey:@"title"];
		NSString * message = [_dict objectForKey:@"message"];
		NSString * ok = [_dict objectForKey:@"ok"];
		SCAlert(title, message, ok);
	}
	
	return YES;
}

@end
