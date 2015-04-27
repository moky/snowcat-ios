//
//  SCFSMTransition.h
//  SnowCat
//
//  Created by Moky on 14-12-13.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCFSMMachine;

@interface SCFSMTransition : NSObject

@property(nonatomic, readonly) NSString * targetStateName;

- (instancetype) initWithTargetStateName:(NSString *)name;

- (BOOL) evaluate:(SCFSMMachine *)machine;

@end
