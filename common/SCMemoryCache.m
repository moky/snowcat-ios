//
//  SCMemoryCache.m
//  SnowCat
//
//  Created by Moky on 14-3-19.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCMemoryCache.h"

@interface SCMemoryCache ()

@property(nonatomic, retain) NSMutableDictionary * dataPool;

@end

@implementation SCMemoryCache

@synthesize dataPool = _dataPool;

- (void) dealloc
{
	[_dataPool release];
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		self.dataPool = [NSMutableDictionary dictionaryWithCapacity:256];
	}
	return self;
}

// singleton implementations
SC_IMPLEMENT_SINGLETON_FUNCTIONS(getInstance)

- (void) setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
	if (!anObject) {
		// if the object is nil, remove the old object for key
		[self removeObjectForKey:aKey];
		return;
	}
	
	@synchronized(self) {
		[_dataPool setObject:anObject forKey:aKey];
	}
}

- (id) objectForKey:(id)aKey
{
	@synchronized(self) {
		return [[[_dataPool objectForKey:aKey] retain] autorelease];
	}
}

- (id) retainObjectForKey:(id<NSCopying>)aKey
{
	@synchronized(self) {
		return [[_dataPool objectForKey:aKey] retain];
	}
}

- (void) releaseObjectForKey:(id<NSCopying>)aKey
{
	@synchronized(self) {
		[[_dataPool objectForKey:aKey] release];
	}
}

- (void) removeObjectForKey:(id)aKey
{
	@synchronized(self) {
		[_dataPool removeObjectForKey:aKey];
	}
}

- (NSData *) getFileData:(NSString *)filename
{
	// try from cache
	NSData * data = [self objectForKey:filename];
	if (data) {
		return data;
	}
	
	// try from file
	data = [[NSData alloc] initWithContentsOfFile:filename];
	NSAssert(data, @"error: failed to get data from file: %@", filename);
	SCLog(@"**** I/O **** filename: %@", filename);
	
	[self setObject:data forKey:filename];
	[data release];
	
	return data;
}

//
//  The method 'allKeysForObject:' of NSDictionary
//  sends 'isEquals:' message to determine if the two objects are equal,
//  it's not what I want, so use this method instead.
//
- (NSArray *) _allKeysForObject:(id)anObject
{
	NSMutableArray * mArray = [[NSMutableArray alloc] initWithCapacity:2];
	
	NSEnumerator * keyEnumerator = [_dataPool keyEnumerator];
	id<NSCopying> key;
	id object;
	while (key = [keyEnumerator nextObject]) {
		object = [_dataPool objectForKey:key];
		if (object == anObject) { // compare exactly, and faster
			[mArray addObject:key];
		}
	}
	
	return [mArray autorelease];
}

- (CGFloat) purgeDataCache
{
	NSUInteger count, total;
	
	@synchronized(self) {
		total = [_dataPool count];
		count = 0;
		if (total > 0) {
			NSMutableArray * keysToRemove = [[NSMutableArray alloc] initWithCapacity:total];
			
			NSEnumerator * objectEnumerator = [_dataPool objectEnumerator];
			NSArray * keys;
			id object;
			while (object = [objectEnumerator nextObject]) {
				keys = [self _allKeysForObject:object];
				NSAssert([keys count] > 0 && [object retainCount] >= [keys count],
						 @"retain count: %u, keys count: %u", (unsigned int)[object retainCount], (unsigned int)[keys count]);
				if ([object retainCount] == [keys count]) {
					// nobody is retaining this object excepts the memory cache
					[keysToRemove addObjectsFromArray:keys];
					count += [keys count];
				}
			}
			
			[_dataPool removeObjectsForKeys:keysToRemove];
			[keysToRemove release];
		}
	}
	
	if (total == 0) {
		SCLog(@"no cache");
		return 1.0f;
	} else {
		SCLog(@"%u/%u memory item(s) has been clean.", (unsigned int)count, (unsigned int)total);
		return (CGFloat)count / total;
	}
}

@end
