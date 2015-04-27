//
//  SCFSMSequence.h
//  SnowCat
//
//  Created by Moky on 14-12-14.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCFSMTransition.h"

//
//  class for sequence transitions
//
@interface SCFSMSequence : SCFSMTransition

- (instancetype) initWithTargetStateName:(NSString *)name transitions:(SCFSMTransition *)first, ... NS_REQUIRES_NIL_TERMINATION;

@end
