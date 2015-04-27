//
//  SCStringDrawing.m
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCStringDrawing.h"

//typedef NS_ENUM(NSInteger, UIBaselineAdjustment) {
//    UIBaselineAdjustmentAlignBaselines = 0, // default. used when shrinking text to position based on the original baseline
//    UIBaselineAdjustmentAlignCenters,
//    UIBaselineAdjustmentNone,
//};
UIBaselineAdjustment UIBaselineAdjustmentFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Center")
			return UIBaselineAdjustmentAlignCenters;
		SC_SWITCH_CASE(string, @"None")
			return UIBaselineAdjustmentNone;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return UIBaselineAdjustmentAlignBaselines;
}
