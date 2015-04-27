//
//  SCGeometry.m
//  SnowCat
//
//  Created by Moky on 15-1-1.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCString.h"
#import "SCGeometry.h"

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

static NSString * caculate_string_with_node(NSString * string, id node)
{
#define SC_VIEW_CACULATE_REPLACE(substr, value)                                \
    while ((range = [string rangeOfString:(substr)]).location != NSNotFound) { \
        string = [NSString stringWithFormat:@"%@%.1f%@",                       \
                  [string substringToIndex:range.location],                    \
                  (value),                                                     \
                  [string substringFromIndex:range.location + range.length]];  \
    }
	
	CGRect rect1 = CGRectGetFrameFromNode(node);
	CGRect rect2 = CGRectGetBoundsFromParentOfNode(node);
	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSRange range;
	
	// replace key words
	SC_VIEW_CACULATE_REPLACE(@"left", 0.0f);
	SC_VIEW_CACULATE_REPLACE(@"center", rect2.size.width * 0.5f);
	SC_VIEW_CACULATE_REPLACE(@"right", rect2.size.width);
	
	SC_VIEW_CACULATE_REPLACE(@"top", 0.0f);
	SC_VIEW_CACULATE_REPLACE(@"middle", rect2.size.height * 0.5f);
	SC_VIEW_CACULATE_REPLACE(@"bottom", rect2.size.height);
	
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
		SC_VIEW_CACULATE_REPLACE(@"self.x", rect1.origin.x);
		SC_VIEW_CACULATE_REPLACE(@"self.y", rect1.origin.y);
		SC_VIEW_CACULATE_REPLACE(@"self.width", rect1.size.width);
		SC_VIEW_CACULATE_REPLACE(@"self.height", rect1.size.height);
	}
	
	// parent
	if ([string rangeOfString:@"parent."].location != NSNotFound) {
		SC_VIEW_CACULATE_REPLACE(@"parent.x", rect2.origin.x);
		SC_VIEW_CACULATE_REPLACE(@"parent.y", rect2.origin.y);
		SC_VIEW_CACULATE_REPLACE(@"parent.width", rect2.size.width);
		SC_VIEW_CACULATE_REPLACE(@"parent.height", rect2.size.height);
	}
	
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
	
	// math
	string = [SCString caculateString:string];
	
	[string retain]; // retainCount++
	[pool release];
	
	return [string autorelease]; // retainCount--
}

CGRect CGRectFromStringWithNode(NSString * string, id node)
{
	CGRect rect = CGRectZero;
	
	CGRect rect1 = CGRectGetFrameFromNode(node);
	CGRect rect2 = CGRectGetBoundsFromParentOfNode(node);
	
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"ToFill")
			rect = rect2;
			break;
		SC_SWITCH_CASE(string, @"AspectFit")
			rect.size = CGSizeAspectFit(rect1.size, rect2.size);
			rect.origin.x = (rect2.size.width - rect1.size.width) * 0.5f;
			rect.origin.y = (rect2.size.height - rect1.size.height) * 0.5f;
			break;
		SC_SWITCH_CASE(string, @"AspectFill")
			rect.size = CGSizeAspectFill(rect1.size, rect2.size);
			rect.origin.x = (rect1.size.width - rect2.size.width) * 0.5f;
			rect.origin.y = (rect1.size.height - rect2.size.height) * 0.5f;
			break;
		SC_SWITCH_DEFAULT
			rect = CGRectFromString(caculate_string_with_node(string, node));
			break;
	SC_SWITCH_END
	
	// zero ?
	if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
		if (CGSizeEqualToSize(rect1.size, CGSizeZero)) {
			rect = rect2;
		} else {
			rect = rect1;
		}
	}
	
	return rect;
}

CGSize CGSizeFromStringWithNode(NSString * string, id node)
{
	CGSize size = CGSizeZero;
	
	CGRect rect1 = CGRectGetFrameFromNode(node);
	CGRect rect2 = CGRectGetBoundsFromParentOfNode(node);
	
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"ToFill")
			size = rect2.size;
			break;
		SC_SWITCH_CASE(string, @"AspectFit")
			size = CGSizeAspectFit(rect1.size, rect2.size);
			break;
		SC_SWITCH_CASE(string, @"AspectFill")
			size = CGSizeAspectFill(rect1.size, rect2.size);
			break;
		SC_SWITCH_DEFAULT
			size = CGSizeFromString(caculate_string_with_node(string, node));
			break;
	SC_SWITCH_END
	
	// zero ?
	if (CGSizeEqualToSize(size, CGSizeZero)) {
		if (CGSizeEqualToSize(rect1.size, CGSizeZero)) {
			size = rect2.size;
		} else {
			size = rect1.size;
		}
	}
	
	return size;
}

CGPoint CGPointFromStringWithNode(NSString * string, id node)
{
	CGPoint point = CGPointZero;
	
	//CGRect rect1 = CGRectGetFrameFromNode(node);
	CGRect rect2 = CGRectGetBoundsFromParentOfNode(node);
	
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"TopLeft")
			point = CGPointMake(0.0f, 0.0f);
			break;
		SC_SWITCH_CASE(string, @"TopRight")
			point = CGPointMake(rect2.size.width, 0.0f);
			break;
		SC_SWITCH_CASE(string, @"Center")
			point = CGPointMake(rect2.size.width * 0.5f, rect2.size.height * 0.5f);
			break;
		SC_SWITCH_CASE(string, @"BottomLeft")
			point = CGPointMake(0.0f, rect2.size.height);
			break;
		SC_SWITCH_CASE(string, @"BottomRight")
			point = CGPointMake(rect2.size.width, rect2.size.height);
			break;
		SC_SWITCH_DEFAULT
			point = CGPointFromString(caculate_string_with_node(string, node));
			break;
	SC_SWITCH_END
	
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
