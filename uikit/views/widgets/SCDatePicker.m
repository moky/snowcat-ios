//
//  SCDatePicker.m
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCLog.h"
#import "SCNib.h"
#import "SCEventHandler.h"
#import "SCDatePicker.h"

//typedef NS_ENUM(NSInteger, UIDatePickerMode) {
//    UIDatePickerModeTime,           // Displays hour, minute, and optionally AM/PM designation depending on the locale setting (e.g. 6 | 53 | PM)
//    UIDatePickerModeDate,           // Displays month, day, and year depending on the locale setting (e.g. November | 15 | 2007)
//    UIDatePickerModeDateAndTime,    // Displays date, hour, minute, and optionally AM/PM designation depending on the locale setting (e.g. Wed Nov 15 | 6 | 53 | PM)
//    UIDatePickerModeCountDownTimer  // Displays hour and minute (e.g. 1 | 53)
//};
UIDatePickerMode UIDatePickerModeFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Timer")
			return UIDatePickerModeCountDownTimer;
		SC_SWITCH_CASE(string, @"DateAndTime")
			return UIDatePickerModeDateAndTime;
		SC_SWITCH_CASE(string, @"Date")
			return UIDatePickerModeDate;
		SC_SWITCH_CASE(string, @"Time")
			return UIDatePickerModeTime;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

@implementation SCDatePicker

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib

- (void) dealloc
{
	[_nodeFile release];
	
	[self removeTarget:self action:@selector(onChange:) forControlEvents:UIControlEventValueChanged];
	
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCDatePicker
{
	_scTag = 0;
	self.nodeFile = nil;
	
	// Note that the target is not retained, so this assignment won't cause memory leaks
	[self addTarget:self action:@selector(onChange:) forControlEvents:UIControlEventValueChanged];
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCDatePicker];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeSCDatePicker];
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	self = [self initWithFrame:CGRectZero];
	if (self) {
		[self buildHandlers:dict];
	}
	return self;
}

// buildHandlers:
SC_UIKIT_IMELEMENT_BUILD_HANDLERS_FUNCTION()

// awakeFromNib
SC_UIKIT_IMPLEMENT_AWAKE_FUNCTION()

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIDatePicker *)datePicker
{
	if (![SCControl setAttributes:dict to:datePicker]) {
		SCLog(@"failed to set attributes: %@", dict);
		return NO;
	}
	
	// datePickerMode
	NSString * datePickerMode = [dict objectForKey:@"datePickerMode"];
	if (datePickerMode) {
		datePicker.datePickerMode = UIDatePickerModeFromString(datePickerMode);
	}
	
	// locale
	
	// calendar
	
	// timeZone
	
	// date
	
	// minimumDate
	
	// maximumDate
	
	// countDownDuration
	id countDownDuration = [dict objectForKey:@"countDownDuration"];
	if (countDownDuration) {
		datePicker.countDownDuration = [countDownDuration doubleValue];
	}
	
	// minuteInterval
	id minuteInterval = [dict objectForKey:@"minuteInterval"];
	if (minuteInterval) {
		datePicker.minuteInterval = [minuteInterval integerValue];
	}
	
	return YES;
}

#pragma mark - Value Event Interfaces

- (void) onChange:(id)sender
{
	SCLog(@"onChange: %@", sender);
	SCDoEvent(@"onChange", sender);
}

@end
