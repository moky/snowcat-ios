//
//  SCView+Function.m
//  SnowCat
//
//  Created by Moky on 14-11-11.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCView.h"

//typedef NS_ENUM(NSInteger, UIViewAnimationCurve) {
//    UIViewAnimationCurveEaseInOut,         // slow at beginning and end
//    UIViewAnimationCurveEaseIn,            // slow at beginning
//    UIViewAnimationCurveEaseOut,           // slow at end
//    UIViewAnimationCurveLinear
//};
UIViewAnimationCurve UIViewAnimationCurveFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"EaseInOut")
			return UIViewAnimationCurveEaseInOut;
		SC_SWITCH_CASE(string, @"EaseIn")
			return UIViewAnimationCurveEaseIn;
		SC_SWITCH_CASE(string, @"EaseOut")
			return UIViewAnimationCurveEaseOut;
		SC_SWITCH_CASE(string, @"Linear")
			return UIViewAnimationCurveLinear;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

//typedef NS_ENUM(NSInteger, UIViewContentMode) {
//    UIViewContentModeScaleToFill,
//    UIViewContentModeScaleAspectFit,      // contents scaled to fit with fixed aspect. remainder is transparent
//    UIViewContentModeScaleAspectFill,     // contents scaled to fill with fixed aspect. some portion of content may be clipped.
//    UIViewContentModeRedraw,              // redraw on bounds change (calls -setNeedsDisplay)
//    UIViewContentModeCenter,              // contents remain same size. positioned adjusted.
//    UIViewContentModeTop,
//    UIViewContentModeBottom,
//    UIViewContentModeLeft,
//    UIViewContentModeRight,
//    UIViewContentModeTopLeft,
//    UIViewContentModeTopRight,
//    UIViewContentModeBottomLeft,
//    UIViewContentModeBottomRight,
//};
UIViewContentMode UIViewContentModeFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"BottomRight")
			return UIViewContentModeBottomRight;
		SC_SWITCH_CASE(string, @"BottomLeft")
			return UIViewContentModeBottomLeft;
		SC_SWITCH_CASE(string, @"TopRight")
			return UIViewContentModeTopRight;
		SC_SWITCH_CASE(string, @"TopLeft")
			return UIViewContentModeTopLeft;
		SC_SWITCH_CASE(string, @"Right")
			return UIViewContentModeRight;
		SC_SWITCH_CASE(string, @"Left")
			return UIViewContentModeLeft;
		SC_SWITCH_CASE(string, @"Bottom")
			return UIViewContentModeBottom;
		SC_SWITCH_CASE(string, @"Top")
			return UIViewContentModeTop;
		SC_SWITCH_CASE(string, @"Center")
			return UIViewContentModeCenter;
		SC_SWITCH_CASE(string, @"Redraw")
			return UIViewContentModeRedraw;
		SC_SWITCH_CASE(string, @"AspectFill")
			return UIViewContentModeScaleAspectFill;
		SC_SWITCH_CASE(string, @"AspectFit")
			return UIViewContentModeScaleAspectFit;
		SC_SWITCH_CASE(string, @"ToFill")
			return UIViewContentModeScaleToFill;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

//typedef NS_ENUM(NSInteger, UIViewAnimationTransition) {
//    UIViewAnimationTransitionNone,
//    UIViewAnimationTransitionFlipFromLeft,
//    UIViewAnimationTransitionFlipFromRight,
//    UIViewAnimationTransitionCurlUp,
//    UIViewAnimationTransitionCurlDown,
//};
UIViewAnimationTransition UIViewAnimationTransitionFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"None")
			return UIViewAnimationTransitionNone;
		SC_SWITCH_CASE(string, @"FlipFromLeft")
			return UIViewAnimationTransitionFlipFromLeft;
		SC_SWITCH_CASE(string, @"FlipFromRight")
			return UIViewAnimationTransitionFlipFromRight;
		SC_SWITCH_CASE(string, @"CurlUp")
			return UIViewAnimationTransitionCurlUp;
		SC_SWITCH_CASE(string, @"CurlDown")
			return UIViewAnimationTransitionCurlDown;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

//typedef NS_OPTIONS(NSUInteger, UIViewAutoresizing) {
//    UIViewAutoresizingNone                 = 0,
//    UIViewAutoresizingFlexibleLeftMargin   = 1 << 0,
//    UIViewAutoresizingFlexibleWidth        = 1 << 1,
//    UIViewAutoresizingFlexibleRightMargin  = 1 << 2,
//    UIViewAutoresizingFlexibleTopMargin    = 1 << 3,
//    UIViewAutoresizingFlexibleHeight       = 1 << 4,
//    UIViewAutoresizingFlexibleBottomMargin = 1 << 5
//};
UIViewAutoresizing UIViewAutoresizingFromString(NSString * string)
{
	UIViewAutoresizing mask = [string integerValue];
	
	if (mask > 0) {
		return mask;
	}
	
	if ([string rangeOfString:@"None"].location != NSNotFound) {
		return mask;
	}
	
	// left
	if ([string rangeOfString:@"Left"].location != NSNotFound) {
		mask |= UIViewAutoresizingFlexibleLeftMargin;
	}
	// right
	if ([string rangeOfString:@"Right"].location != NSNotFound) {
		mask |= UIViewAutoresizingFlexibleRightMargin;
	}
	// top
	if ([string rangeOfString:@"Top"].location != NSNotFound) {
		mask |= UIViewAutoresizingFlexibleTopMargin;
	}
	// bottom
	if ([string rangeOfString:@"Bottom"].location != NSNotFound) {
		mask |= UIViewAutoresizingFlexibleBottomMargin;
	}
	// width
	if ([string rangeOfString:@"Width"].location != NSNotFound) {
		mask |= UIViewAutoresizingFlexibleWidth;
	}
	// height
	if ([string rangeOfString:@"Height"].location != NSNotFound) {
		mask |= UIViewAutoresizingFlexibleHeight;
	}
	
	return mask;
}

//typedef NS_ENUM(NSInteger, UILayoutConstraintAxis) {
//    UILayoutConstraintAxisHorizontal = 0,
//    UILayoutConstraintAxisVertical = 1
//};
UILayoutConstraintAxis UILayoutConstraintAxisFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Horizontal")
			return UILayoutConstraintAxisHorizontal;
		SC_SWITCH_CASE(string, @"Vertical")
			return UILayoutConstraintAxisVertical;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

#pragma mark - Convenient interface

UIImage * SCSnapshot(UIView * view)
{
	CGRect bounds = view.bounds;
	UIGraphicsBeginImageContext(bounds.size);
	[view drawViewHierarchyInRect:bounds afterScreenUpdates:YES];
	UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

void SCRemoveSubviews(UIView * view)
{
	NSArray * subviews = view.subviews;
	for (NSInteger index = [subviews count] - 1; index >= 0; --index) {
		[[subviews objectAtIndex:index] removeFromSuperview];
	}
}
