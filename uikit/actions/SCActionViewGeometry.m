//
//  SCActionViewGeometry.m
//  SnowCat
//
//  Created by Moky on 15-1-15.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "SCGeometry.h"
#import "SCView+Geometry.h"
#import "SCActionViewGeometry.h"

@implementation SCActionHide

- (BOOL) runWithResponder:(id)responder
{
	if ([responder isKindOfClass:[UIViewController class]]) {
		responder = [(UIViewController *)responder view];
	}
	NSAssert([responder isKindOfClass:[UIView class]], @"definition error: %@, responder: %@", _dict, responder);
	
	UIView * view = (UIView *)responder;
	
	id alpha = [_dict objectForKey:@"alpha"];
	if (alpha) {
		view.alpha = [alpha floatValue];
	} else {
		view.hidden = YES;
	}
	
	return YES;
}

@end

@implementation SCActionShow

- (BOOL) runWithResponder:(id)responder
{
	if ([responder isKindOfClass:[UIViewController class]]) {
		responder = [(UIViewController *)responder view];
	}
	NSAssert([responder isKindOfClass:[UIView class]], @"definition error: %@, responder: %@", _dict, responder);
	
	UIView * view = (UIView *)responder;
	
	id alpha = [_dict objectForKey:@"alpha"];
	if (alpha) {
		view.alpha = [alpha floatValue];
	} else {
		view.hidden = NO;
	}
	
	return YES;
}

@end

@implementation SCActionMoveBy

- (void) view:(UIView *)view moveFrom:(CGPoint)point
{
	NSAssert([_dict objectForKey:@"origin"] ||
			 [_dict objectForKey:@"center"] ||
			 [_dict objectForKey:@"anchorPoint"] ||
			 [_dict objectForKey:@"position"],
			 @"parameters error: %@", _dict);
	
	// calculating as relative distance
	CGPoint delta = [SCView centerFromDictionary:_dict withView:view];
	view.center = CGPointMake(point.x + delta.x, point.y + delta.y);
}

- (BOOL) runWithResponder:(id)responder
{
	if ([responder isKindOfClass:[UIViewController class]]) {
		responder = [(UIViewController *)responder view];
	}
	NSAssert([responder isKindOfClass:[UIView class]], @"definition error: %@, responder: %@", _dict, responder);
	
	UIView * view = (UIView *)responder;
	[self view:view moveFrom:view.center];
	
	return YES;
}

@end

@implementation SCActionMoveTo

- (BOOL) runWithResponder:(id)responder
{
	if ([responder isKindOfClass:[UIViewController class]]) {
		responder = [(UIViewController *)responder view];
	}
	NSAssert([responder isKindOfClass:[UIView class]], @"definition error: %@, responder: %@", _dict, responder);
	
	UIView * view = (UIView *)responder;
	[self view:view moveFrom:CGPointZero];
	
	return YES;
}

@end

@implementation SCActionResize

- (BOOL) runWithResponder:(id)responder
{
	if ([responder isKindOfClass:[UIViewController class]]) {
		responder = [(UIViewController *)responder view];
	}
	NSAssert([responder isKindOfClass:[UIView class]], @"definition error: %@, responder: %@", _dict, responder);
	
	UIView * view = (UIView *)responder;
	
	NSString * anchorPoint = [_dict objectForKey:@"anchorPoint"];
	NSString * size = [_dict objectForKey:@"size"];
	NSAssert(size, @"parameters error: %@", _dict);
	
	CGPoint anchor = anchorPoint ? CGPointFromString(anchorPoint) : CGPointMake(0.5f, 0.5f);
	CGSize newSize = CGSizeFromStringWithNode(size, view);
	
	CGSize oldSize = view.frame.size;
	CGPoint center = view.center;
	
	CGPoint position = CGPointMake(center.x - oldSize.width * (0.5 - anchor.x),
								   center.y - oldSize.width * (0.5 - anchor.y));
	
	view.frame = CGRectMake(position.x - newSize.width * anchor.x,
							position.y - newSize.height * anchor.y,
							newSize.width,
							newSize.height);
	
	return YES;
}

@end
