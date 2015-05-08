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

#pragma mark -

#define SCWaterfallViewInitFirstJoiningPoint(point, compare)                   \
		switch (direction) {                                                   \
			/* {left, top} */                                                  \
			case UIWaterfallViewDirectionTopLeft:                              \
				compare = SCWaterfallViewJoiningPointCompareBlockTopLeft();    \
				point->x = spaceHorizontal;                                    \
				point->y = spaceVertical;                                      \
				break;                                                         \
			case UIWaterfallViewDirectionLeftTop:                              \
				compare = SCWaterfallViewJoiningPointCompareBlockLeftTop();    \
				point->x = spaceHorizontal;                                    \
				point->y = spaceVertical;                                      \
				break;                                                         \
			/* {right, top} */                                                 \
			case UIWaterfallViewDirectionTopRight:                             \
				compare = SCWaterfallViewJoiningPointCompareBlockTopRight();   \
				point->x = bounds.size.width - spaceHorizontal;                \
				point->y = spaceVertical;                                      \
				break;                                                         \
			case UIWaterfallViewDirectionRightTop:                             \
				compare = SCWaterfallViewJoiningPointCompareBlockRightTop();   \
				point->x = bounds.size.width - spaceHorizontal;                \
				point->y = spaceVertical;                                      \
				break;                                                         \
			/* {left, bottom} */                                               \
			case UIWaterfallViewDirectionBottomLeft:                           \
				compare = SCWaterfallViewJoiningPointCompareBlockBottomLeft(); \
				point->x = spaceHorizontal;                                    \
				point->y = bounds.size.height - spaceVertical;                 \
				break;                                                         \
			case UIWaterfallViewDirectionLeftBottom:                           \
				compare = SCWaterfallViewJoiningPointCompareBlockLeftBottom(); \
				point->x = spaceHorizontal;                                    \
				point->y = bounds.size.height - spaceVertical;                 \
				break;                                                         \
			/* {right, bottom} */                                              \
			case UIWaterfallViewDirectionBottomRight:                          \
				compare = SCWaterfallViewJoiningPointCompareBlockBottomRight();\
				point->x = bounds.size.width - spaceHorizontal;                \
				point->y = bounds.size.height - spaceVertical;                 \
				break;                                                         \
			case UIWaterfallViewDirectionRightBottom:                          \
				compare = SCWaterfallViewJoiningPointCompareBlockRightBottom();\
				point->x = bounds.size.width - spaceHorizontal;                \
				point->y = bounds.size.height - spaceVertical;                 \
				break;                                                         \
			default:                                                           \
				break;                                                         \
		}                                                                      \
		                        /* EOF 'SCWaterfallViewInitFirstJoiningPoint' */

#define SCWaterfallViewPlaceOnJoiningPoint(frame)                              \
		switch (direction) {                                                   \
			case UIWaterfallViewDirectionTopLeft:                              \
				frame.origin.x = point->x;                                     \
				frame.origin.y = point->y;                                     \
				if (frame.origin.x + frame.size.width + spaceHorizontal > bounds.size.width) { \
					continue;                                                  \
				}                                                              \
				break;                                                         \
			case UIWaterfallViewDirectionTopRight:                             \
				frame.origin.x = point->x - frame.size.width;                  \
				frame.origin.y = point->y;                                     \
				if (frame.origin.x - spaceHorizontal < 0.0f) {                 \
					continue;                                                  \
				}                                                              \
				break;                                                         \
			case UIWaterfallViewDirectionBottomLeft:                           \
				frame.origin.x = point->x;                                     \
				frame.origin.y = point->y - frame.size.height;                 \
				if (frame.origin.x + frame.size.width + spaceHorizontal > bounds.size.width) { \
					continue;                                                  \
				}                                                              \
				break;                                                         \
			case UIWaterfallViewDirectionBottomRight:                          \
				frame.origin.x = point->x - frame.size.width;                  \
				frame.origin.y = point->y - frame.size.height;                 \
				if (frame.origin.x - spaceHorizontal < 0.0f) {                 \
					continue;                                                  \
				}                                                              \
				break;                                                         \
			case UIWaterfallViewDirectionLeftTop:                              \
				frame.origin.x = point->x;                                     \
				frame.origin.y = point->y;                                     \
				if (frame.origin.y + frame.size.height + spaceVertical > bounds.size.height) { \
					continue;                                                  \
				}                                                              \
				break;                                                         \
			case UIWaterfallViewDirectionLeftBottom:                           \
				frame.origin.x = point->x;                                     \
				frame.origin.y = point->y - frame.size.height;                 \
				if (frame.origin.y - spaceVertical < 0.0f) {                   \
					continue;                                                  \
				}                                                              \
				break;                                                         \
			case UIWaterfallViewDirectionRightTop:                             \
				frame.origin.x = point->x - frame.size.width;                  \
				frame.origin.y = point->y;                                     \
				if (frame.origin.y + frame.size.height + spaceVertical > bounds.size.height) { \
					continue;                                                  \
				}                                                              \
				break;                                                         \
			case UIWaterfallViewDirectionRightBottom:                          \
				frame.origin.x = point->x - frame.size.width;                  \
				frame.origin.y = point->y - frame.size.height;                 \
				if (frame.origin.y - spaceVertical < 0.0f) {                   \
					continue;                                                  \
				}                                                              \
			default:                                                           \
				break;                                                         \
		}                                                                      \
		                          /* EOF 'SCWaterfallViewPlaceOnJoiningPoint' */

#define SCWaterfallViewAddTwoJoiningPoints(frame)                              \
		switch (direction) {                                                   \
			case UIWaterfallViewDirectionTopLeft:                              \
				pt.x = frame.origin.x + frame.size.width + spaceHorizontal;    \
				pt.y = frame.origin.y;                                         \
				if (pt.x < bounds.size.width) {                                \
					SCBaseArraySortInsert(pointPool, bt); /* right */          \
				}                                                              \
				pt.x = frame.origin.x;                                         \
				pt.y = frame.origin.y + frame.size.height + spaceVertical;     \
				SCBaseArraySortInsert(pointPool, bt); /* bottom */             \
				break;                                                         \
			case UIWaterfallViewDirectionTopRight:                             \
				pt.x = frame.origin.x - spaceHorizontal;                       \
				pt.y = frame.origin.y;                                         \
				if (pt.x > 0.0f) {                                             \
					SCBaseArraySortInsert(pointPool, bt); /* left */           \
				}                                                              \
				pt.x = frame.origin.x + frame.size.width;                      \
				pt.y = frame.origin.y + frame.size.height + spaceVertical;     \
				SCBaseArraySortInsert(pointPool, bt); /* bottom */             \
				break;                                                         \
			case UIWaterfallViewDirectionBottomLeft:                           \
				pt.x = frame.origin.x + frame.size.width + spaceHorizontal;    \
				pt.y = frame.origin.y + frame.size.height;                     \
				if (pt.x < bounds.size.width) {                                \
					SCBaseArraySortInsert(pointPool, bt); /* right */          \
				}                                                              \
				pt.x = frame.origin.x;                                         \
				pt.y = frame.origin.y - spaceVertical;                         \
				SCBaseArraySortInsert(pointPool, bt); /* top */                \
				break;                                                         \
			case UIWaterfallViewDirectionBottomRight:                          \
				pt.x = frame.origin.x - spaceHorizontal;                       \
				pt.y = frame.origin.y + frame.size.height;                     \
				if (pt.x > 0.0f) {                                             \
					SCBaseArraySortInsert(pointPool, bt); /* left */           \
				}                                                              \
				pt.x = frame.origin.x + frame.size.width;                      \
				pt.y = frame.origin.y - spaceVertical;                         \
				SCBaseArraySortInsert(pointPool, bt); /* top */                \
				break;                                                         \
			case UIWaterfallViewDirectionLeftTop:                              \
				pt.x = frame.origin.x;                                         \
				pt.y = frame.origin.y + frame.size.height + spaceVertical;     \
				if (pt.y < bounds.size.height) {                               \
					SCBaseArraySortInsert(pointPool, bt); /* bottom */         \
				}                                                              \
				pt.x = frame.origin.x + frame.size.width + spaceHorizontal;    \
				pt.y = frame.origin.y;                                         \
				SCBaseArraySortInsert(pointPool, bt); /* right */              \
				break;                                                         \
			case UIWaterfallViewDirectionLeftBottom:                           \
				pt.x = frame.origin.x;                                         \
				pt.y = frame.origin.y - spaceVertical;                         \
				if (pt.y > 0.0f) {                                             \
					SCBaseArraySortInsert(pointPool, bt); /* top */            \
				}                                                              \
				pt.x = frame.origin.x + frame.size.width + spaceHorizontal;    \
				pt.y = frame.origin.y + frame.size.height;                     \
				SCBaseArraySortInsert(pointPool, bt); /* right */              \
				break;                                                         \
			case UIWaterfallViewDirectionRightTop:                             \
				pt.x = frame.origin.x + frame.size.width;                      \
				pt.y = frame.origin.y + frame.size.height + spaceVertical;     \
				if (pt.y < bounds.size.height) {                               \
					SCBaseArraySortInsert(pointPool, bt); /* bottom */         \
				}                                                              \
				pt.x = frame.origin.x - spaceHorizontal;                       \
				pt.y = frame.origin.y;                                         \
				SCBaseArraySortInsert(pointPool, bt); /* left */               \
				break;                                                         \
			case UIWaterfallViewDirectionRightBottom:                          \
				pt.x = frame.origin.x + frame.size.width;                      \
				pt.y = frame.origin.y - spaceVertical;                         \
				if (pt.y > 0.0f) {                                             \
					SCBaseArraySortInsert(pointPool, bt); /* top */            \
				}                                                              \
				pt.x = frame.origin.x - spaceHorizontal;                       \
				pt.y = frame.origin.y + frame.size.height;                     \
				SCBaseArraySortInsert(pointPool, bt); /* left */               \
				break;                                                         \
			default:                                                           \
				break;                                                         \
		}                                                                      \
		                          /* EOF 'SCWaterfallViewAddTwoJoiningPoints' */


+ (CGSize) layoutSubviewsInView:(UIView *)view towards:(UIWaterfallViewDirection)direction spaceHorizontal:(CGFloat)spaceHorizontal spaceVertical:(CGFloat)spaceVertical
{
	CGRect bounds = view.bounds;
	NSArray * subviews = view.subviews;
	NSUInteger count = [subviews count];
	
	// 1. create a pool for joining points
	//    each subview offers two new joining point,
	//    create a pool to save all available joining point(s)
	SCBaseArray * pointPool = SCBaseArrayCreate(sizeof(CGPoint), count * 2);
	pointPool->bkAssign = SCWaterfallViewJoiningPointAssignBlock();
	
	// set compare function & first joining point
	CGPoint * point = (CGPoint *)SCBaseArrayItemAt(pointPool, 0);
	SCBaseTypeCompareBlock compare = NULL;
	SCWaterfallViewInitFirstJoiningPoint(point, compare);
	pointPool->bkCompare = compare;
	pointPool->count = 1;
	
	NSEnumerator * enumerator = [subviews objectEnumerator];
	UIView * child;
	CGRect frame;
	
	NSUInteger index;
	NSInteger offset;
	
	UIView * v;
	BOOL conflicts;
	NSInteger i;
	
	CGPoint pt = CGPointZero;
	SCBaseType * bt = (SCBaseType *)&pt;
	
	// 2. layout each subview
	for (index = 0; child = [enumerator nextObject]; ++index) {
		NSAssert(pointPool->count > 0, @"no available joining point");
		frame = child.frame;
		
		// 2.1. trying each joining points
		point = (CGPoint *)SCBaseArrayItemAt(pointPool, 0);
		for (offset = 0; offset < pointPool->count; ++offset, ++point) {
			// 2.1.1. place it on the joing point
			//        if the frame outside the bounds, continue
			SCWaterfallViewPlaceOnJoiningPoint(frame);
			
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
		SCWaterfallViewAddTwoJoiningPoints(frame);
	}
	
	// 3. destroy the pool for joining points
	SCBaseArrayDestroy(pointPool);
	
	return bounds.size;
}

@end
