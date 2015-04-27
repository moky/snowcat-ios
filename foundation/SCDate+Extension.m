//
//  SCDate+Extension.m
//  SnowCat
//
//  Created by Moky on 15-1-19.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCDate+Extension.h"

@implementation NSDate (HumanReadable)

- (NSString *) stringWithFormat:(NSString *)format
{
	NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:format];
	NSString * str = [dateFormatter stringFromDate:self];
	[dateFormatter release];
	return str;
}

- (NSString *) humanReadableString
{
	NSDate * now = [[NSDate alloc] init];
	NSTimeInterval ti = [now timeIntervalSinceDate:self];
	[now release];
	
	// now -> 15 seconds
	if (ti < 16) {
		return SCLocalizedString(@"Just now", nil);
	}
	
	// 16 seconds -> 49 seconds
	if (ti < 50) {
		return SCLocalizedString(@"Less than 1 minute", nil);
	}
	// 50 seconds -> 69 minute
	if (ti < 70) {
		return SCLocalizedString(@"About 1 minute", nil);
	}
	// 70 seconds -> 99 seconds
	if (ti < 100) {
		return SCLocalizedString(@"1 minute ago", nil);
	}
	
	// 100 seconds -> 25 minutes
	if (ti < 60 * 25) {
		NSString * format = SCLocalizedString(@"%.0f minutes ago", nil);
		return [NSString stringWithFormat:format, ti / 60.0f];
	}
	// 25 minutes -> 35 minutes
	if (ti < 60 * 35) {
		return SCLocalizedString(@"About half an hour", nil);
	}
	// 35 minutes -> 45 minutes
	if (ti < 60 * 45) {
		return SCLocalizedString(@"Half an hour ago", nil);
	}
	
	// 45 minutes -> 50 minutes
	if (ti < 60 * 50) {
		return SCLocalizedString(@"Less than 1 hour", nil);
	}
	// 50 minutes -> 70 minutes
	if (ti < 60 * 70) {
		return SCLocalizedString(@"About 1 hour", nil);
	}
	// 70 mintes -> 99 minutes
	if (ti < 60 * 100) {
		return SCLocalizedString(@"An hour ago", nil);
	}
	
	NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
	[calendar autorelease];
	NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
	
	NSDateComponents * comps1 = [calendar components:unit fromDate:self];
	NSDateComponents * comps2 = [calendar components:unit fromDate:now];
	
	// today
	if (comps1.day == comps2.day &&
		comps1.month == comps2.month &&
		comps1.year == comps2.year) {
		if (comps1.hour < 12) {
			NSString * format = SCLocalizedString(@"%d:%02d AM", nil);
			return [NSString stringWithFormat:format, comps1.hour, comps1.minute];
		} else if (comps1.hour == 12) {
			return SCLocalizedString(@"Noon", nil);
		} else {
			NSString * format = SCLocalizedString(@"%d:%02d PM", nil);
			return [NSString stringWithFormat:format, comps1.hour - 12, comps1.minute];
		}
	}
	
	// yesterday
	if (ti < 3600 * 24 + comps2.hour * 3600 + comps2.minute * 60 + comps2.second) {
		NSString * pre = SCLocalizedString(@"Yesterday", nil);
		if (comps1.hour < 12) {
			NSString * format = SCLocalizedString(@"%d:%02d AM", nil);
			NSString * str = [NSString stringWithFormat:format, comps1.hour, comps1.minute];
			return [NSString stringWithFormat:@"%@ %@", pre, str];
		} else if (comps1.hour == 12) {
			NSString * str = SCLocalizedString(@"Noon", nil);
			return [NSString stringWithFormat:@"%@ %@", pre, str];
		} else {
			NSString * format = SCLocalizedString(@"%d:%02d PM", nil);
			NSString * str = [NSString stringWithFormat:format, comps1.hour, comps1.minute];
			return [NSString stringWithFormat:@"%@ %@", pre, str];
		}
	}
	
	NSString * dateFormat = nil; // @"yyyy-MM-dd HH:mm:ss"
	if (comps1.year == comps2.year) {
		dateFormat = SCLocalizedString(@"MM-dd", nil);
	} else {
		dateFormat = SCLocalizedString(@"yyyy-MM-dd", nil);
	}
	return [self stringWithFormat:dateFormat];
}

@end
