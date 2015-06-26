//
//  SCGeometry.m
//  SnowCat
//
//  Created by Moky on 15-1-1.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "SCLog.h"
#import "SCString.h"
#import "SCGeometry.h"

#define SC_VIEW_CACULATE_REPLACE(substr, value)                                \
    while ((range = [string rangeOfString:(substr)]).location != NSNotFound) { \
        string = [NSString stringWithFormat:@"%@%.1f%@",                       \
                  [string substringToIndex:range.location],                    \
                  (value),                                                     \
                  [string substringFromIndex:range.location + range.length]];  \
    }                                                                          \
                                            /* EOF 'SC_VIEW_CACULATE_REPLACE' */

static NSString * geometry_string_with_rects(NSString * string, CGRect selfFrame, CGRect parentBounds)
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSRange range;
	
	// replace key words
	SC_VIEW_CACULATE_REPLACE(@"left", 0.0f);
	SC_VIEW_CACULATE_REPLACE(@"center", parentBounds.size.width * 0.5f);
	SC_VIEW_CACULATE_REPLACE(@"right", parentBounds.size.width);
	
	SC_VIEW_CACULATE_REPLACE(@"top", 0.0f);
	SC_VIEW_CACULATE_REPLACE(@"middle", parentBounds.size.height * 0.5f);
	SC_VIEW_CACULATE_REPLACE(@"bottom", parentBounds.size.height);
	
	// screen
	if ([string rangeOfString:@"screen."].location != NSNotFound) {
		CGRect rect0 = [UIScreen mainScreen].bounds;
		// here we define the screen as the hardware screen, which is not rotated yet.
		// so the width is always the shorter side, and the height is the longer.
		SC_VIEW_CACULATE_REPLACE(@"screen.width", MIN(rect0.size.width, rect0.size.height));
		SC_VIEW_CACULATE_REPLACE(@"screen.height", MAX(rect0.size.width, rect0.size.height));
	}
	
	// self
	if ([string rangeOfString:@"self."].location != NSNotFound) {
		SC_VIEW_CACULATE_REPLACE(@"self.x", selfFrame.origin.x);
		SC_VIEW_CACULATE_REPLACE(@"self.y", selfFrame.origin.y);
		SC_VIEW_CACULATE_REPLACE(@"self.width", selfFrame.size.width);
		SC_VIEW_CACULATE_REPLACE(@"self.height", selfFrame.size.height);
	}
	
	// parent
	if ([string rangeOfString:@"parent."].location != NSNotFound) {
		SC_VIEW_CACULATE_REPLACE(@"parent.x", parentBounds.origin.x);
		SC_VIEW_CACULATE_REPLACE(@"parent.y", parentBounds.origin.y);
		SC_VIEW_CACULATE_REPLACE(@"parent.width", parentBounds.size.width);
		SC_VIEW_CACULATE_REPLACE(@"parent.height", parentBounds.size.height);
	}
	
	[string retain]; // retainCount++
	[pool release];
	
	return [string autorelease]; // retainCount--
}

static NSString * geometry_string_with_node(NSString * string, id node)
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSRange range;
	
	// sibling
	if ([string rangeOfString:@"previousSibling."].location != NSNotFound) {
		// previousSibling
		id previousSibling = SCPreviousSiblingOfNode(node);
		CGRect frame = CGRectGetFrameFromNode(previousSibling);
		SC_VIEW_CACULATE_REPLACE(@"previousSibling.x", frame.origin.x);
		SC_VIEW_CACULATE_REPLACE(@"previousSibling.y", frame.origin.y);
		SC_VIEW_CACULATE_REPLACE(@"previousSibling.width", frame.size.width);
		SC_VIEW_CACULATE_REPLACE(@"previousSibling.height", frame.size.height);
	}
	if ([string rangeOfString:@"nextSibling."].location != NSNotFound) {
		// nextSibling
		id nextSibling = SCNextSiblingOfNode(node);
		CGRect frame = CGRectGetFrameFromNode(nextSibling);
		SC_VIEW_CACULATE_REPLACE(@"nextSibling.x", frame.origin.x);
		SC_VIEW_CACULATE_REPLACE(@"nextSibling.y", frame.origin.y);
		SC_VIEW_CACULATE_REPLACE(@"nextSibling.width", frame.size.width);
		SC_VIEW_CACULATE_REPLACE(@"nextSibling.height", frame.size.height);
	}
	
	CGRect selfFrame = CGRectGetFrameFromNode(node);
	CGRect parentBounds = CGRectGetBoundsFromParentOfNode(node);
	string = geometry_string_with_rects(string, selfFrame, parentBounds);
	
	[string retain]; // retainCount++
	[pool release];
	
	return [string autorelease]; // retainCount--
}

#pragma mark -

CGSize CGSizeAspectFit(CGSize fromSize, CGSize toSize)
{
	if (fromSize.width > 0.0f && fromSize.height > 0.0f) {
		CGFloat dw = toSize.width / fromSize.width;
		CGFloat dh = toSize.height / fromSize.height;
		CGFloat delta = MIN(dw, dh);
		return CGSizeMake(fromSize.width * delta, fromSize.height * delta);
	} else {
		return fromSize;
	}
}

CGSize CGSizeAspectFill(CGSize fromSize, CGSize toSize)
{
	if (fromSize.width > 0.0f && fromSize.height > 0.0f) {
		CGFloat dw = toSize.width / fromSize.width;
		CGFloat dh = toSize.height / fromSize.height;
		CGFloat delta = MAX(dw, dh);
		return CGSizeMake(fromSize.width * delta, fromSize.height * delta);
	} else {
		return fromSize;
	}
}

#pragma mark Fixed String

CGRect CGRectFromFixedString(NSString * string, CGRect selfFrame, CGRect parentBounds)
{
	CGRect rect = CGRectZero;
	
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"ToFill")
			rect = parentBounds;
			break;
		SC_SWITCH_CASE(string, @"AspectFit")
			rect.size = CGSizeAspectFit(selfFrame.size, parentBounds.size);
			rect.origin.x = parentBounds.origin.x + (parentBounds.size.width - rect.size.width) * 0.5f;
			rect.origin.y = parentBounds.origin.y + (parentBounds.size.height - rect.size.height) * 0.5f;
			break;
		SC_SWITCH_CASE(string, @"AspectFill")
			rect.size = CGSizeAspectFill(selfFrame.size, parentBounds.size);
			rect.origin.x = parentBounds.origin.x + (selfFrame.size.width - parentBounds.size.width) * 0.5f;
			rect.origin.y = parentBounds.origin.y + (selfFrame.size.height - parentBounds.size.height) * 0.5f;
			break;
		SC_SWITCH_DEFAULT
			break;
	SC_SWITCH_END
	
	return rect;
}

CGSize CGSizeFromFixedString(NSString * string, CGRect selfFrame, CGRect parentBounds)
{
	CGSize size = CGSizeZero;
	
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"ToFill")
			size = parentBounds.size;
			break;
		SC_SWITCH_CASE(string, @"AspectFit")
			size = CGSizeAspectFit(selfFrame.size, parentBounds.size);
			break;
		SC_SWITCH_CASE(string, @"AspectFill")
			size = CGSizeAspectFill(selfFrame.size, parentBounds.size);
			break;
		SC_SWITCH_DEFAULT
			break;
	SC_SWITCH_END
	
	return size;
}

CGPoint CGPointFromFixedString(NSString * string, CGRect selfFrame, CGRect parentBounds)
{
	CGPoint point = CGPointZero;
	
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"TopLeft")
			point = CGPointMake(parentBounds.origin.x,
								parentBounds.origin.y);
			break;
		SC_SWITCH_CASE(string, @"TopRight")
			point = CGPointMake(parentBounds.origin.x + parentBounds.size.width,
								parentBounds.origin.y);
			break;
		SC_SWITCH_CASE(string, @"Center")
			point = CGPointMake(parentBounds.origin.x + parentBounds.size.width * 0.5f,
								parentBounds.origin.y + parentBounds.size.height * 0.5f);
			break;
		SC_SWITCH_CASE(string, @"BottomLeft")
			point = CGPointMake(parentBounds.origin.x,
								parentBounds.origin.y + parentBounds.size.height);
			break;
		SC_SWITCH_CASE(string, @"BottomRight")
			point = CGPointMake(parentBounds.origin.x + parentBounds.size.width,
								parentBounds.origin.y + parentBounds.size.height);
			break;
		SC_SWITCH_DEFAULT
			break;
	SC_SWITCH_END
	
	return point;
}

#pragma mark -

CGRect CGRectFromStringWithRects(NSString * string, CGRect selfFrame, CGRect parentBounds)
{
	CGRect rect = CGRectZero;
	
	if ([string rangeOfString:@"{"].location == NSNotFound) {
		rect = CGRectFromFixedString(string, selfFrame, parentBounds);
	} else {
		string = geometry_string_with_rects(string, selfFrame, parentBounds);
		string = [SCString caculateString:string];
		rect = CGRectFromString(string);
	}
	
	// zero ?
	if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
		if (CGSizeEqualToSize(selfFrame.size, CGSizeZero)) {
			rect = parentBounds;
		} else {
			rect = selfFrame;
		}
	}
	
	return rect;
}

CGRect CGRectFromStringWithNode(NSString * string, id node)
{
	CGRect rect = CGRectZero;
	
	CGRect selfFrame = CGRectGetFrameFromNode(node);
	CGRect parentBounds = CGRectGetBoundsFromParentOfNode(node);
	
	if ([string rangeOfString:@"{"].location == NSNotFound) {
		rect = CGRectFromFixedString(string, selfFrame, parentBounds);
	} else {
		string = geometry_string_with_node(string, node);
		string = [SCString caculateString:string];
		rect = CGRectFromString(string);
	}
	
	// zero ?
	if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
		if (CGSizeEqualToSize(selfFrame.size, CGSizeZero)) {
			rect = parentBounds;
		} else {
			rect = selfFrame;
		}
	}
	
	return rect;
}

CGSize CGSizeFromStringWithRects(NSString * string, CGRect selfFrame, CGRect parentBounds)
{
	CGSize size = CGSizeZero;
	
	if ([string rangeOfString:@"{"].location == NSNotFound) {
		size = CGSizeFromFixedString(string, selfFrame, parentBounds);
	} else {
		string = geometry_string_with_rects(string, selfFrame, parentBounds);
		string = [SCString caculateString:string];
		size = CGSizeFromString(string);
	}
	
	// zero ?
	if (CGSizeEqualToSize(size, CGSizeZero)) {
		if (CGSizeEqualToSize(selfFrame.size, CGSizeZero)) {
			size = parentBounds.size;
		} else {
			size = selfFrame.size;
		}
	}
	
	return size;
}

CGSize CGSizeFromStringWithNode(NSString * string, id node)
{
	CGSize size = CGSizeZero;
	
	CGRect selfFrame = CGRectGetFrameFromNode(node);
	CGRect parentBounds = CGRectGetBoundsFromParentOfNode(node);
	
	if ([string rangeOfString:@"{"].location == NSNotFound) {
		size = CGSizeFromFixedString(string, selfFrame, parentBounds);
	} else {
		string = geometry_string_with_node(string, node);
		string = [SCString caculateString:string];
		size = CGSizeFromString(string);
	}
	
	// zero ?
	if (CGSizeEqualToSize(size, CGSizeZero)) {
		if (CGSizeEqualToSize(selfFrame.size, CGSizeZero)) {
			size = parentBounds.size;
		} else {
			size = selfFrame.size;
		}
	}
	
	return size;
}

CGPoint CGPointFromStringWithRects(NSString * string, CGRect selfFrame, CGRect parentBounds)
{
	CGPoint point = CGPointZero;
	
	if ([string rangeOfString:@"{"].location == NSNotFound) {
		point = CGPointFromFixedString(string, selfFrame, parentBounds);
	} else {
		string = geometry_string_with_rects(string, selfFrame, parentBounds);
		string = [SCString caculateString:string];
		point = CGPointFromString(string);
	}
	
	return point;
}

CGPoint CGPointFromStringWithNode(NSString * string, id node)
{
	CGPoint point = CGPointZero;
	
	if ([string rangeOfString:@"{"].location == NSNotFound) {
		CGRect selfFrame = CGRectGetFrameFromNode(node);
		CGRect parentBounds = CGRectGetBoundsFromParentOfNode(node);
		point = CGPointFromFixedString(string, selfFrame, parentBounds);
	} else {
		string = geometry_string_with_node(string, node);
		string = [SCString caculateString:string];
		point = CGPointFromString(string);
	}
	
	return point;
}

#pragma mark -

CGRect CGRectGetFrameFromNode(id node)
{
	if ([node isKindOfClass:[UIView class]]) {
		UIView * view = (UIView *)node;
		return view.frame;
	} else if ([node isKindOfClass:[CALayer class]]) {
		CALayer * layer = (CALayer *)node;
		return layer.frame;
	} else if ([node isKindOfClass:[UIViewController class]]) {
		UIViewController * vc = (UIViewController *)node;
		UIView * view = vc.view;
		return view.frame;
	} else {
		SCLog(@"unsupported node: %@", node);
		return CGRectZero;
	}
}

CGRect CGRectGetBoundsFromParentOfNode(id node)
{
	if ([node isKindOfClass:[UIView class]]) {
		UIView * view = (UIView *)node;
		if (view.superview) {
			return view.superview.bounds;
		} else if (view.window) {
			return view.window.bounds;
		} else {
			return [UIScreen mainScreen].bounds;
		}
	} else if ([node isKindOfClass:[CALayer class]]) {
		CALayer * layer = (CALayer *)node;
		if (layer.superlayer) {
			return layer.superlayer.bounds;
		} else {
			return [UIScreen mainScreen].bounds;
		}
	} else if ([node isKindOfClass:[UIViewController class]]) {
		UIViewController * vc = (UIViewController *)node;
		UIView * view = vc.view;
		if (view.superview) {
			return view.superview.bounds;
		} else if (view.window) {
			return view.window.bounds;
		} else {
			return [UIScreen mainScreen].bounds;
		}
	} else {
		SCLog(@"unsupported node: %@", node);
		return [UIScreen mainScreen].bounds;
	}
}

#pragma mark - Siblings

NSArray * SCSiblingsOfNode(id node)
{
	if ([node isKindOfClass:[UIView class]]) {
		UIView * view = (UIView *)node;
		return view.superview.subviews;
	} else if ([node isKindOfClass:[CALayer class]]) {
		CALayer * layer = (CALayer *)node;
		return layer.superlayer.sublayers;
	} else if ([node isKindOfClass:[UIViewController class]]) {
		UIViewController * vc = (UIViewController *)node;
		return vc.parentViewController.childViewControllers;
	} else {
		SCLog(@"unsupported node: %@", node);
		return nil;
	}
}

id SCPreviousSiblingOfNode(id node)
{
	NSArray * siblings = SCSiblingsOfNode(node);
	NSUInteger index = [siblings indexOfObject:node];
	if (index == NSNotFound || index == 0) {
		return nil;
	} else {
		return [siblings objectAtIndex:index - 1];
	}
}

id SCNextSiblingOfNode(id node)
{
	NSArray * siblings = SCSiblingsOfNode(node);
	NSUInteger index = [siblings indexOfObject:node];
	if (index == NSNotFound || index + 1 >= [siblings count]) {
		return nil;
	} else {
		return [siblings objectAtIndex:index + 1];
	}
}
