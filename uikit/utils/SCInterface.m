//
//  SCInterface.m
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCInterface.h"

//typedef NS_ENUM(NSInteger, UIBarStyle) {
//    UIBarStyleDefault          = 0,
//    UIBarStyleBlack            = 1,
//    
//    UIBarStyleBlackOpaque      = 1, // Deprecated. Use UIBarStyleBlack
//    UIBarStyleBlackTranslucent = 2, // Deprecated. Use UIBarStyleBlack and set the translucent property to YES
//};
UIBarStyle UIBarStyleFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Translucent")
			return UIBarStyleBlackTranslucent;
		SC_SWITCH_CASE(string, @"Opaque")
			return UIBarStyleBlackOpaque;
		SC_SWITCH_CASE(string, @"Black")
			return UIBarStyleBlack;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return UIBarStyleDefault;
}
