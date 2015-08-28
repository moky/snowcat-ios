//
//  SCFSMAutoMachine.h
//  SnowCat
//
//  Created by Moky on 15-1-9.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "SCFSMProtocol.h"

@interface SCFSMAutoMachine : SCFSMMachine

@property(nonatomic, readwrite) NSTimeInterval interval; // default is 1.0/12.0

@end
