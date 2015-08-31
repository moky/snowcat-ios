//
//  SCString.m
//  SnowCat
//
//  Created by Moky on 14-3-19.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scMacros.h"

#import "SCString.h"

@implementation SCString

+ (NSObject *) objectFromJsonString:(NSString *)jsonString
{
	return NSObjectFromJSONString(jsonString);
}

@end
