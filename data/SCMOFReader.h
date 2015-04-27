//
//  SCMOFReader.h
//  SnowCat
//
//  Created by Moky on 14-12-9.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCMOFData.h"

@interface SCMOFReader : SCMOFData

@property(nonatomic, readonly) NSObject * root;

//@protected:
- (void) parseWithFilename:(NSString *)mof; // called by 'loadFromFile:'

@end
