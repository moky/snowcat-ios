//
//  SCStepper.h
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCControl.h"

@interface SCStepper : UIStepper<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIStepper *)stepper;

// Value Event Interfaces
- (void) onChange:(id)sender;

@end
