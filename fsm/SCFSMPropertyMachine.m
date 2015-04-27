//
//  SCFSMPropertyMachine.m
//  SnowCat
//
//  Created by Moky on 14-12-14.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCFSMPropertyMachine.h"

@interface SCFSMPropertyMachine ()

@property(nonatomic, retain) NSMutableDictionary * properties;

@end

@implementation SCFSMPropertyMachine

@synthesize properties = _properties;

- (void) dealloc
{
	self.properties = nil;
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		[_properties release];
		_properties = [[NSMutableDictionary alloc] initWithCapacity:16];
	}
	return self;
}

- (id) propertyForKey:(id)aKey
{
	@synchronized(self) {
		NSAssert(aKey, @"property key cannot be empty");
		return [_properties objectForKey:aKey];
	}
}

- (void) removePropertyForKey:(id)aKey
{
	@synchronized(self) {
		NSAssert(aKey, @"property key cannot be empty");
		[_properties removeObjectForKey:aKey];
	}
}

- (void) setProperty:(id)anObject forKey:(id<NSCopying>)aKey
{
	@synchronized(self) {
		NSAssert(aKey, @"property key cannot be empty");
		if (anObject) {
			[_properties setObject:anObject forKey:aKey];
		} else {
			[_properties removeObjectForKey:aKey];
		}
	}
}

@end
