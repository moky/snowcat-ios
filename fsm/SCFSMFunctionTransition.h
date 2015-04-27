//
//  SCFSMFunctionTransition.h
//  SnowCat
//
//  Created by Moky on 14-12-14.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCFSMTransition.h"

@interface SCFSMFunctionTransition : SCFSMTransition

@property(nonatomic, assign) id delegate;
@property(nonatomic, readwrite) SEL selector;

- (instancetype) initWithTargetStateName:(NSString *)name
								delegate:(id)delegate
								selector:(SEL)selector;

@end
