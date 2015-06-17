//
//  SCString+DeviceSuffix.h
//  SnowCat
//
//  Created by Moky on 15-6-17.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DeviceSuffix)

// append suffix like "@2x", "~ipad", "~iphone", "-568h@2x", ...
- (NSString *) appendDeviceSuffix;

@end
