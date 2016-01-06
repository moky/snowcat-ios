//
//  SCFSMPropertyMachine.m
//  SnowCat
//
//  Created by Moky on 14-12-14.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
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

/* designated initializer */
- (instancetype) initWithDefaultStateName:(NSString *)name capacity:(NSUInteger)capacity interval:(NSTimeInterval)interval
{
	self = [super initWithDefaultStateName:name capacity:capacity interval:interval];
	if (self) {
		NSMutableDictionary * mDict = [[NSMutableDictionary alloc] initWithCapacity:capacity];
		self.properties = mDict;
		[mDict release];
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
