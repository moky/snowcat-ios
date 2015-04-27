//
//  SCFSMBlockTransition.h
//  SnowCat
//
//  Created by Moky on 15-1-9.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "SCFSMTransition.h"

typedef BOOL (^SCFSMBlock)(SCFSMMachine * machine, SCFSMTransition * transition);

@interface SCFSMBlockTransition : SCFSMTransition

@property(nonatomic, readwrite) SCFSMBlock block;

- (instancetype) initWithTargetStateName:(NSString *)name block:(SCFSMBlock)block;

@end
