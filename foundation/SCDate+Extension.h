//
//  SCDate+Extension.h
//  SnowCat
//
//  Created by Moky on 15-1-19.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (HumanReadable)

- (NSString *) stringWithFormat:(NSString *)format; // "yyyy-MM-dd HH:mm:ss"
- (NSString *) humanReadableString;

@end
