//
//  SCTime.m
//  SnowCat
//
//  Created by Moky on 15-5-11.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#include <sys/time.h>
#include <sys/timeb.h>
//#include <sys/_types/_timespec.h>

#import "SCTime.h"

@interface SCTime ()

@property(nonatomic, readwrite) time_t second;
@property(nonatomic, readwrite) int microsecond;

@end

@implementation SCTime

@synthesize second = _second;
@synthesize microsecond = _microsecond;

- (instancetype) init
{
	self = [super init];
	if (self) {
		struct timeval time;
		gettimeofday(&time, NULL);
		_second = time.tv_sec;
		_microsecond = time.tv_usec;
	}
	return self;
}

- (int) nanosecond
{
	return _microsecond * 1000;
}

- (NSString *) description
{
	return [NSString stringWithFormat:@"%ld.%06d sec", _second, _microsecond];
}

@end

@implementation SCTime (Convenient)

+ (SCTimeValue) second
{
	return time(NULL);
}

+ (SCTimeValue) millisecond
{
	struct timeb time;
	ftime(&time);
	SCTimeValue tv = time.time;
	return tv * 1000 + time.millitm;
}

+ (SCTimeValue) microsecond
{
	struct timeval time;
	gettimeofday(&time, NULL);
	SCTimeValue tv = time.tv_sec;
	return tv * 1000000 + time.tv_usec;
}

+ (SCTimeValue) nanosecond
{
	return [self microsecond] * 1000;
//	struct timespec time;
//	gethrestime();
//	return time.tv_sec * 1000000000 + time.tv_nsec;
}

@end