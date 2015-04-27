//
//  SCFSMPropertyMachine.h
//  SnowCat
//
//  Created by Moky on 14-12-14.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCFSMAutoMachine.h"

@interface SCFSMPropertyMachine : SCFSMAutoMachine

- (id) propertyForKey:(id)aKey;

- (void) removePropertyForKey:(id)aKey;
- (void) setProperty:(id)anObject forKey:(id<NSCopying>)aKey;

@end
