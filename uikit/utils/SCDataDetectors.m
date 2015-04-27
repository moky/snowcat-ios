//
//  SCDataDetectors.m
//  SnowCat
//
//  Created by Moky on 14-4-3.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCDataDetectors.h"

//typedef NS_OPTIONS(NSUInteger, UIDataDetectorTypes) {
//    UIDataDetectorTypePhoneNumber   = 1 << 0,          // Phone number detection
//    UIDataDetectorTypeLink          = 1 << 1,          // URL detection
//#if __IPHONE_4_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED
//    UIDataDetectorTypeAddress       = 1 << 2,          // Street address detection
//    UIDataDetectorTypeCalendarEvent = 1 << 3,          // Event detection
//#endif
//	
//    UIDataDetectorTypeNone          = 0,               // No detection at all
//    UIDataDetectorTypeAll           = NSUIntegerMax    // All types
//};
UIDataDetectorTypes UIDataDetectorTypesFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Phone")
			return UIDataDetectorTypePhoneNumber;
		SC_SWITCH_CASE(string, @"Link")
			return UIDataDetectorTypeLink;
#if __IPHONE_4_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED
		SC_SWITCH_CASE(string, @"Addr")
			return UIDataDetectorTypeAddress;
		SC_SWITCH_CASE(string, @"Calendar")
			return UIDataDetectorTypeCalendarEvent;
#endif
		SC_SWITCH_CASE(string, @"None")
			return UIDataDetectorTypeNone;
		SC_SWITCH_CASE(string, @"All")
			return UIDataDetectorTypeAll;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}
