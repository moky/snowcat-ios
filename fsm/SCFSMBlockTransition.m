//
//  SCFSMBlockTransition.m
//  SnowCat
//
//  Created by Moky on 15-1-9.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "SCFSMBlockTransition.h"

@implementation SCFSMBlockTransition

@synthesize block = _block;

- (instancetype) initWithTargetStateName:(NSString *)name block:(SCFSMBlock)block
{
	self = [self initWithTargetStateName:name];
	if (self) {
		self.block = block;
	}
	return self;
}

- (BOOL) evaluate:(SCFSMMachine *)machine
{
	NSAssert(_block, @"error");
	return _block ? _block(machine, self) : NO;
}

@end
