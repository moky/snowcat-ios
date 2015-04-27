//
//  SCAnimationView.h
//  SnowCat
//
//  Created by Moky on 14-7-16.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCImageView.h"

@interface SCAnimationView : SCImageView

- (void) startAnimating:(NSString *)name;

//  params:
//      name        (required)
//      duration    (optional)
//      repeatCount (optional)
- (void) startAnimation:(NSDictionary *)dict;

@end
