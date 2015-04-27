//
//  SCView+Geometry.m
//  SnowCat
//
//  Created by Moky on 14-11-11.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCString.h"
#import "SCGeometry.h"
#import "SCView+Geometry.h"

@implementation SCView (Geometry)

+ (CGSize) sizeThatFits:(CGSize)size to:(UIView *)view
{
	CGSize ss;
	CGFloat w, h;
	
	NSEnumerator * enumerator = [view.subviews objectEnumerator];
	UIView * sv;
	while (sv = [enumerator nextObject]) {
		if ([sv isKindOfClass:[UIScrollView class]]) {
			ss = sv.frame.size; // don't dig the scroll views
		} else {
			ss = [self sizeThatFits:sv.frame.size to:sv];
		}
		w = sv.frame.origin.x + ss.width;
		h = sv.frame.origin.y + ss.height;
		if (w > size.width) {
			size.width = w;
		}
		if (h > size.height) {
			size.height = h;
		}
	}
	
	return size;
}

+ (CGPoint) centerFromDictionary:(NSDictionary *)dict withView:(UIView *)view
{
	NSAssert([dict isKindOfClass:[NSDictionary class]], @"parameters error: %@", dict);
	
	// position & anchorPoint
	CGPoint anchor = CGPointZero;
	CGPoint point = CGPointZero;//view.frame.origin;
	
	// origin
	NSString * origin = [dict objectForKey:@"origin"];
	if (origin) {
		anchor = CGPointZero;
		point = CGPointFromStringWithNode(origin, view);
	}
	
	// center
	NSString * center = [dict objectForKey:@"center"];
	if (center) {
		anchor = CGPointMake(0.5, 0.5);
		point = CGPointFromStringWithNode(center, view);
	}
	
	// anchorPoint + position
	NSString * anchorPoint = [dict objectForKey:@"anchorPoint"];
	NSString * position = [dict objectForKey:@"position"];
	if (anchorPoint || position) {
		anchor = anchorPoint ? CGPointFromString(anchorPoint) : CGPointMake(0.5, 0.5);
		point = CGPointFromStringWithNode(position, view);
	}
	
	if (anchor.x != 0.5 || anchor.y != 0.5) {
		// coordinate conversion
		CGRect rect1 = view.bounds;
		CGPoint delta = CGPointMake((0.5 - anchor.x) * rect1.size.width,
									(0.5 - anchor.y) * rect1.size.height);
//		delta = [view convertPoint:delta toView:view.window];
//		delta = [view.superview convertPoint:delta fromView:view.window];
		point.x += delta.x;
		point.y += delta.y;
	}
	
	return point;
}

+ (BOOL) setGeometryAttributes:(NSDictionary *)dict to:(UIView *)view
{
	// animatable. do not use frame if view is transformed since it will not correctly reflect the actual location of the view. use bounds + center instead.
	// frame
	NSString * frame = [dict objectForKey:@"frame"];
	if (frame && ![frame isEqualToString:@"self.frame"]) {
		view.frame = CGRectFromStringWithNode(frame, view);
	}
	
	// use bounds/center and not frame if non-identity transform. if bounds dimension is odd, center may be have fractional part
	// bounds
	NSString * bounds = [dict objectForKey:@"bounds"];
	if (bounds) {
		view.bounds = CGRectFromStringWithNode(bounds, view);
	}
	
	// size
	NSString * size = [dict objectForKey:@"size"];
	if (size) {
		CGRect bounds = CGRectZero;
		bounds.size = CGSizeFromStringWithNode(size, view);
		view.bounds = bounds;
	}
	
	// if frame/bounds/size not defined, it means this is an empty node,
	// use its superview's bounds as frame.
	if (CGRectEqualToRect(view.frame, CGRectZero)) {
		view.frame = CGRectGetBoundsFromParentOfNode(view);
	}
	
	// center
	NSString * origin = [dict objectForKey:@"origin"];
	NSString * center = [dict objectForKey:@"center"];
	NSString * anchorPoint = [dict objectForKey:@"anchorPoint"];
	NSString * position = [dict objectForKey:@"position"];
	if (!frame || origin || center || anchorPoint || position) {
		view.center = [self centerFromDictionary:dict withView:view];
	}
	
	// transform
	
	// contentScaleFactor
	id contentScaleFactor = [dict objectForKey:@"contentScaleFactor"];
	if (contentScaleFactor) {
		view.contentScaleFactor = [contentScaleFactor floatValue];
	}
	
	// multipleTouchEnabled
	id multipleTouchEnabled = [dict objectForKey:@"multipleTouchEnabled"];
	if (multipleTouchEnabled) {
		view.multipleTouchEnabled = [multipleTouchEnabled boolValue];
	}
	
	// exclusiveTouch
	id exclusiveTouch = [dict objectForKey:@"exclusiveTouch"];
	if (exclusiveTouch) {
		view.exclusiveTouch = [exclusiveTouch boolValue];
	}
	
	// autoresizesSubviews
	id autoresizesSubviews = [dict objectForKey:@"autoresizesSubviews"];
	if (autoresizesSubviews) {
		view.autoresizesSubviews = [autoresizesSubviews boolValue];
	}
	
	// autoresizingMask
	NSString * autoresizingMask = [dict objectForKey:@"autoresizingMask"];
	if (autoresizingMask) {
		view.autoresizingMask = UIViewAutoresizingFromString(autoresizingMask);
	}
	
	return YES;
}

@end
