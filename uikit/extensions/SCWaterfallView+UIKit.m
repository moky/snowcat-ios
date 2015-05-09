//
//  UIWaterfallView.m
//  SnowCat
//
//  Created by Moky on 15-5-8.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCBaseArray.h"
#import "SCWaterfallView+UIKit.h"

//typedef NS_ENUM(NSUInteger, UIWaterfallViewDirection) {
//	UIWaterfallViewDirectionTopLeft,     // place each subview as TOP as possible, if reach the TOP, as LEFT as possible
//	UIWaterfallViewDirectionTopRight,    // TOP first, and then RIGHT
//	
//	UIWaterfallViewDirectionBottomLeft,  // BOTTOM first, and then LEFT
//	UIWaterfallViewDirectionBottomRight, // BOTTOM first, and then RIGHT
//	
//	UIWaterfallViewDirectionLeftTop,     // LEFT first, and then TOP
//	UIWaterfallViewDirectionLeftBottom,  // LEFT first, and then BOTTOM
//	
//	UIWaterfallViewDirectionRightTop,    // RIGHT first, and then TOP
//	UIWaterfallViewDirectionRightBottom, // RIGHT first, and then BOTTOM
//};
UIWaterfallViewDirection UIWaterfallViewDirectionFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"TopLeft")
			return UIWaterfallViewDirectionTopLeft;
		SC_SWITCH_CASE(string, @"TopRight")
			return UIWaterfallViewDirectionTopRight;
		SC_SWITCH_CASE(string, @"BottomLeft")
			return UIWaterfallViewDirectionBottomLeft;
		SC_SWITCH_CASE(string, @"BottomRight")
			return UIWaterfallViewDirectionBottomRight;
		SC_SWITCH_CASE(string, @"LeftTop")
			return UIWaterfallViewDirectionLeftTop;
		SC_SWITCH_CASE(string, @"LeftBottom")
			return UIWaterfallViewDirectionLeftBottom;
		SC_SWITCH_CASE(string, @"RightTop")
			return UIWaterfallViewDirectionRightTop;
		SC_SWITCH_CASE(string, @"RightBottom")
			return UIWaterfallViewDirectionRightBottom;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

NS_INLINE void add_first_joining_point(SCBaseArray * pointPool,
									   UIWaterfallViewDirection direction,
									   CGFloat spaceHorizontal, CGFloat spaceVertical,
									   CGRect bounds)
{
	SCBaseTypeCompareBlock compare = NULL;
	CGPoint point = CGPointZero;
	switch (direction) {
		/* {left, top} */
		case UIWaterfallViewDirectionTopLeft:
			compare = SCWaterfallViewJoiningPointCompareBlockTopLeft();
			point.x = spaceHorizontal;
			point.y = spaceVertical;
			break;
		case UIWaterfallViewDirectionLeftTop:
			compare = SCWaterfallViewJoiningPointCompareBlockLeftTop();
			point.x = spaceHorizontal;
			point.y = spaceVertical;
			break;
			
		/* {right, top} */
		case UIWaterfallViewDirectionTopRight:
			compare = SCWaterfallViewJoiningPointCompareBlockTopRight();
			point.x = bounds.size.width - spaceHorizontal;
			point.y = spaceVertical;
			break;
		case UIWaterfallViewDirectionRightTop:
			compare = SCWaterfallViewJoiningPointCompareBlockRightTop();
			point.x = bounds.size.width - spaceHorizontal;
			point.y = spaceVertical;
			break;
		
		/* {left, bottom} */
		case UIWaterfallViewDirectionBottomLeft:
			compare = SCWaterfallViewJoiningPointCompareBlockBottomLeft();
			point.x = spaceHorizontal;
			point.y = bounds.size.height - spaceVertical;
			break;
		case UIWaterfallViewDirectionLeftBottom:
			compare = SCWaterfallViewJoiningPointCompareBlockLeftBottom();
			point.x = spaceHorizontal;
			point.y = bounds.size.height - spaceVertical;
			break;
			
		/* {right, bottom} */
		case UIWaterfallViewDirectionBottomRight:
			compare = SCWaterfallViewJoiningPointCompareBlockBottomRight();
			point.x = bounds.size.width - spaceHorizontal;
			point.y = bounds.size.height - spaceVertical;
			break;
		case UIWaterfallViewDirectionRightBottom:
			compare = SCWaterfallViewJoiningPointCompareBlockRightBottom();
			point.x = bounds.size.width - spaceHorizontal;
			point.y = bounds.size.height - spaceVertical;
			break;
			
		default:
			break; // error
	}
	pointPool->bkCompare = compare;
	SCBaseArrayAdd(pointPool, (SCBaseType *)&point);
}

NS_INLINE BOOL place_on_joining_point(CGRect *frame, CGPoint point,
									  UIWaterfallViewDirection direction,
									  CGFloat spaceHorizontal, CGFloat spaceVertical,
									  CGRect bounds)
{
	switch (direction) {
		/* top first */
		case UIWaterfallViewDirectionTopLeft:
			frame->origin.x = point.x;
			frame->origin.y = point.y;
			if (frame->origin.x + frame->size.width + spaceHorizontal > bounds.size.width) {
				return NO;
			}
			break;
		case UIWaterfallViewDirectionTopRight:
			frame->origin.x = point.x - frame->size.width;
			frame->origin.y = point.y;
			if (frame->origin.x - spaceHorizontal < 0.0f) {
				return NO;
			}
			break;
			
		/* bottom first */
		case UIWaterfallViewDirectionBottomLeft:
			frame->origin.x = point.x;
			frame->origin.y = point.y - frame->size.height;
			if (frame->origin.x + frame->size.width + spaceHorizontal > bounds.size.width) {
				return NO;
			}
			break;
		case UIWaterfallViewDirectionBottomRight:
			frame->origin.x = point.x - frame->size.width;
			frame->origin.y = point.y - frame->size.height;
			if (frame->origin.x - spaceHorizontal < 0.0f) {
				return NO;
			}
			break;
			
		/* left first */
		case UIWaterfallViewDirectionLeftTop:
			frame->origin.x = point.x;
			frame->origin.y = point.y;
			if (frame->origin.y + frame->size.height + spaceVertical > bounds.size.height) {
				return NO;
			}
			break;
		case UIWaterfallViewDirectionLeftBottom:
			frame->origin.x = point.x;
			frame->origin.y = point.y - frame->size.height;
			if (frame->origin.y - spaceVertical < 0.0f) {
				return NO;
			}
			break;
			
		/* right first */
		case UIWaterfallViewDirectionRightTop:
			frame->origin.x = point.x - frame->size.width;
			frame->origin.y = point.y;
			if (frame->origin.y + frame->size.height + spaceVertical > bounds.size.height) {
				return NO;
			}
			break;
		case UIWaterfallViewDirectionRightBottom:
			frame->origin.x = point.x - frame->size.width;
			frame->origin.y = point.y - frame->size.height;
			if (frame->origin.y - spaceVertical < 0.0f) {
				return NO;
			}
			
		default:
			return NO; // error
			break;
	}
	return YES;
}

NS_INLINE void add_two_joining_points(SCBaseArray * pointPool, CGRect frame,
									  UIWaterfallViewDirection direction,
									  CGFloat spaceHorizontal, CGFloat spaceVertical,
									  CGRect bounds)
{
	CGPoint point = CGPointZero;
	SCBaseType * bt = (SCBaseType *)&point;
	switch (direction) {
		/* top first */
		case UIWaterfallViewDirectionTopLeft:
			point.x = frame.origin.x + frame.size.width + spaceHorizontal;
			point.y = frame.origin.y;
			if (point.x < bounds.size.width) {
				SCBaseArraySortInsert(pointPool, bt); /* right */
			}
			point.x = frame.origin.x;
			point.y = frame.origin.y + frame.size.height + spaceVertical;
			SCBaseArraySortInsert(pointPool, bt); /* bottom */
			break;
		case UIWaterfallViewDirectionTopRight:
			point.x = frame.origin.x - spaceHorizontal;
			point.y = frame.origin.y;
			if (point.x > 0.0f) {
				SCBaseArraySortInsert(pointPool, bt); /* left */
			}
			point.x = frame.origin.x + frame.size.width;
			point.y = frame.origin.y + frame.size.height + spaceVertical;
			SCBaseArraySortInsert(pointPool, bt); /* bottom */
			break;
			
		/* bottom first */
		case UIWaterfallViewDirectionBottomLeft:
			point.x = frame.origin.x + frame.size.width + spaceHorizontal;
			point.y = frame.origin.y + frame.size.height;
			if (point.x < bounds.size.width) {
				SCBaseArraySortInsert(pointPool, bt); /* right */
			}
			point.x = frame.origin.x;
			point.y = frame.origin.y - spaceVertical;
			SCBaseArraySortInsert(pointPool, bt); /* top */
			break;
		case UIWaterfallViewDirectionBottomRight:
			point.x = frame.origin.x - spaceHorizontal;
			point.y = frame.origin.y + frame.size.height;
			if (point.x > 0.0f) {
				SCBaseArraySortInsert(pointPool, bt); /* left */
			}
			point.x = frame.origin.x + frame.size.width;
			point.y = frame.origin.y - spaceVertical;
			SCBaseArraySortInsert(pointPool, bt); /* top */
			break;
			
		/* left first */
		case UIWaterfallViewDirectionLeftTop:
			point.x = frame.origin.x;
			point.y = frame.origin.y + frame.size.height + spaceVertical;
			if (point.y < bounds.size.height) {
				SCBaseArraySortInsert(pointPool, bt); /* bottom */
			}
			point.x = frame.origin.x + frame.size.width + spaceHorizontal;
			point.y = frame.origin.y;
			SCBaseArraySortInsert(pointPool, bt); /* right */
			break;
		case UIWaterfallViewDirectionLeftBottom:
			point.x = frame.origin.x;
			point.y = frame.origin.y - spaceVertical;
			if (point.y > 0.0f) {
				SCBaseArraySortInsert(pointPool, bt); /* top */
			}
			point.x = frame.origin.x + frame.size.width + spaceHorizontal;
			point.y = frame.origin.y + frame.size.height;
			SCBaseArraySortInsert(pointPool, bt); /* right */
			break;
			
		/* right first */
		case UIWaterfallViewDirectionRightTop:
			point.x = frame.origin.x + frame.size.width;
			point.y = frame.origin.y + frame.size.height + spaceVertical;
			if (point.y < bounds.size.height) {
				SCBaseArraySortInsert(pointPool, bt); /* bottom */
			}
			point.x = frame.origin.x - spaceHorizontal;
			point.y = frame.origin.y;
			SCBaseArraySortInsert(pointPool, bt); /* left */
			break;
		case UIWaterfallViewDirectionRightBottom:
			point.x = frame.origin.x + frame.size.width;
			point.y = frame.origin.y - spaceVertical;
			if (point.y > 0.0f) {
				SCBaseArraySortInsert(pointPool, bt); /* top */
			}
			point.x = frame.origin.x - spaceHorizontal;
			point.y = frame.origin.y + frame.size.height;
			SCBaseArraySortInsert(pointPool, bt); /* left */
			break;
			
		default:
			break; // error
	}
}

#pragma mark -

@implementation UIWaterfallView

@synthesize direction = _direction;

@synthesize spaceHorizontal = _spaceHorizontal;
@synthesize spaceVertical = _spaceVertical;

- (void) _initializeUIWaterfallView
{
	_direction = UIWaterfallViewDirectionTopLeft;
	
	_spaceHorizontal = 0.0f;
	_spaceVertical = 0.0f;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeUIWaterfallView];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeUIWaterfallView];
	}
	return self;
}

- (CGFloat) space
{
	NSAssert(_spaceHorizontal == _spaceVertical, @"space can be accessed only when horizontal equals to vertical");
	return _spaceHorizontal;
}

- (void) setSpace:(CGFloat)space
{
	self.spaceHorizontal = space;
	self.spaceVertical = space;
}

- (void) setSpaceHorizontal:(CGFloat)spaceHorizontal
{
	if (_spaceHorizontal != spaceHorizontal) {
		_spaceHorizontal = spaceHorizontal;
		[self setNeedsLayout];
	}
}

- (void) setSpaceVertical:(CGFloat)spaceVertical
{
	if (_spaceVertical != spaceVertical) {
		_spaceVertical = spaceVertical;
		[self setNeedsLayout];
	}
}

- (void) setDirection:(UIWaterfallViewDirection)direction
{
	if (_direction != direction) {
		_direction = direction;
		[self setNeedsLayout];
	}
}

- (void) layoutSubviews
{
	[super layoutSubviews];
	[UIWaterfallView layoutSubviewsInView:self towards:_direction];
}

- (void) didAddSubview:(UIView *)subview
{
	[super didAddSubview:subview];
	[self setNeedsLayout];
}

+ (CGSize) layoutSubviewsInView:(UIView *)view
{
	return [self layoutSubviewsInView:view towards:UIWaterfallViewDirectionTopLeft spaceHorizontal:0.0f spaceVertical:0.0f];
}

+ (CGSize) layoutSubviewsInView:(UIView *)view towards:(UIWaterfallViewDirection)direction
{
	return [self layoutSubviewsInView:view towards:direction spaceHorizontal:0.0f spaceVertical:0.0f];
}

+ (CGSize) layoutSubviewsInView:(UIView *)view towards:(UIWaterfallViewDirection)direction spaceHorizontal:(CGFloat)spaceHorizontal spaceVertical:(CGFloat)spaceVertical
{
	CGRect bounds = view.bounds;
	NSArray * subviews = view.subviews;
	NSUInteger count = [subviews count];
	
	// 1. create a pool for joining points
	//    each subview may offers two new joining point,
	//    create a pool to save all available joining point(s)
	SCBaseArray * pointPool = SCBaseArrayCreate(sizeof(CGPoint), count * 2);
	pointPool->bkAssign = SCWaterfallViewJoiningPointAssignBlock();
	add_first_joining_point(pointPool, direction, spaceHorizontal, spaceVertical, bounds);
	NSAssert(pointPool->bkCompare, @"init failed");
	
	NSEnumerator * enumerator = [subviews objectEnumerator];
	UIView * child;
	CGRect frame;
	
	NSUInteger index;
	NSInteger offset;
	
	UIView * v;
	BOOL conflicts;
	NSInteger i;
	
	CGPoint * point;
	
	// 2. layout each subview
	for (index = 0; child = [enumerator nextObject]; ++index) {
		NSAssert(pointPool->count > 0, @"no available joining point");
		frame = child.frame;
		
		// 2.1. trying each joining points
		point = (CGPoint *)SCBaseArrayItemAt(pointPool, 0);
		for (offset = 0; offset < pointPool->count; ++offset, ++point) {
			// 2.1.1. place it on the joing point
			//        if the frame outside the bounds, continue
			if (!place_on_joining_point(&frame, *point, direction, spaceHorizontal, spaceVertical, bounds)) {
				continue;
			}
			
			// 2.1.2. check each elder sibling whether conflict
			conflicts = NO;
			for (i = index - 1; i >= 0; --i) {
				v = [subviews objectAtIndex:i];
				if (CGRectIntersectsRect(frame, v.frame)) {
					conflicts = YES;
					// TODO: check whether the space is too small, if YES, remove it
					break;
				}
			}
			
			if (!conflicts) {
				break; // got a joining point with enough space
			}
		}
		
		// 2.2. check joining point
		if (offset < pointPool->count) {
			// delete the joining point
			SCBaseArrayRemove(pointPool, offset);
		} else {
			NSAssert(false, @"no joining point match?");
			// FIXME: place it anywhere that has enough space
		}
		
		// 2.3. place it
		child.frame = frame;
		
		// 2.4. add two new joing points
		add_two_joining_points(pointPool, frame, direction, spaceVertical, spaceVertical, bounds);
	}
	
	// 3. destroy the pool for joining points
	SCBaseArrayDestroy(pointPool);
	
	return bounds.size;
}

@end
