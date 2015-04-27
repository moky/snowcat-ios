//
//  SCResponder.h
//  SnowCat
//
//  Created by Moky on 14-3-17.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCUIKit.h"

@interface SCResponder : UIResponder<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIResponder *)responder;

+ (void) onCreate:(UIResponder *)responder withDictionary:(NSDictionary *)dict;
+ (void) onDestroy:(UIResponder *)responder;

@end
