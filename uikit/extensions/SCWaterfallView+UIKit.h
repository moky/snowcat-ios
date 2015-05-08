//
//  UIWaterfallView.h
//  SnowCat
//
//  Created by Moky on 15-5-8.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UIWaterfallViewDirection) {
	UIWaterfallViewDirectionTopLeft,     // place each subview as TOP as possible, if reach the TOP, as LEFT as possible
	UIWaterfallViewDirectionTopRight,    // TOP first, and then RIGHT
	
	UIWaterfallViewDirectionBottomLeft,  // BOTTOM first, and then LEFT
	UIWaterfallViewDirectionBottomRight, // BOTTOM first, and then RIGHT
	
	UIWaterfallViewDirectionLeftTop,     // LEFT first, and then TOP
	UIWaterfallViewDirectionLeftBottom,  // LEFT first, and then BOTTOM
	
	UIWaterfallViewDirectionRightTop,    // RIGHT first, and then TOP
	UIWaterfallViewDirectionRightBottom, // RIGHT first, and then BOTTOM
};

UIKIT_EXTERN UIWaterfallViewDirection UIWaterfallViewDirectionFromString(NSString * string);

//
//  Description:
//      All subviews in it will layout as waterfall automatically
//
@interface UIWaterfallView : UIView

@property(nonatomic, readwrite) UIWaterfallViewDirection direction;

@property(nonatomic, readwrite) CGFloat space; // setting 'space' will effect horizontal & vertical at the same time
@property(nonatomic, readwrite) CGFloat spaceHorizontal;
@property(nonatomic, readwrite) CGFloat spaceVertical;

+ (CGSize) layoutSubviewsInView:(UIView *)view;

+ (CGSize) layoutSubviewsInView:(UIView *)view
						towards:(UIWaterfallViewDirection)direction;

+ (CGSize) layoutSubviewsInView:(UIView *)view
						towards:(UIWaterfallViewDirection)direction
				spaceHorizontal:(CGFloat)spaceHorizontal
				  spaceVertical:(CGFloat)spaceVertical;

@end

#pragma mark -

#define SCWaterfallViewJoiningPointAssignBlock()                               \
        ^void(void * ptr, const void * val) {                                  \
            CGPoint * p = (CGPoint *)ptr;                                      \
            CGPoint * v = (CGPoint *)val;                                      \
            p->x = v->x;                                                       \
            p->y = v->y;                                                       \
        }                                                                      \
                              /* EOF 'SCWaterfallViewJoiningPointAssignBlock' */

#define SCWaterfallViewJoiningPointCompareBlock(cond1, cond2, cond3, cond4)    \
        ^int(const void * ptr1, const void * ptr2) {                           \
            CGPoint * p1 = (CGPoint *)ptr1;                                    \
            CGPoint * p2 = (CGPoint *)ptr2;                                    \
            if (cond1) {                                                       \
                return NSOrderedAscending;                                     \
            } else if (cond2) {                                                \
                if (cond3) {                                                   \
                    return NSOrderedAscending;                                 \
                } else if (cond4) {                                            \
                    return NSOrderedSame;                                      \
                }                                                              \
            }                                                                  \
            return NSOrderedDescending;                                        \
        }                                                                      \
                             /* EOF 'SCWaterfallViewJoiningPointCompareBlock' */

#define SCWaterfallViewJoiningPointCompareBlockTopLeft()                       \
        SCWaterfallViewJoiningPointCompareBlock(p1->y < p2->y, p1->y == p2->y, \
                                                p1->x < p2->x, p1->x == p2->x) \
                      /* EOF 'SCWaterfallViewJoiningPointCompareBlockTopLeft' */

#define SCWaterfallViewJoiningPointCompareBlockLeftTop()                       \
        SCWaterfallViewJoiningPointCompareBlock(p1->x < p2->x, p1->x == p2->x, \
                                                p1->y < p2->y, p1->y == p2->y) \
                      /* EOF 'SCWaterfallViewJoiningPointCompareBlockLeftTop' */

#define SCWaterfallViewJoiningPointCompareBlockTopRight()                      \
        SCWaterfallViewJoiningPointCompareBlock(p1->y < p2->y, p1->y == p2->y, \
                                                p1->x > p2->x, p1->x == p2->x) \
                     /* EOF 'SCWaterfallViewJoiningPointCompareBlockTopRight' */

#define SCWaterfallViewJoiningPointCompareBlockRightTop()                      \
        SCWaterfallViewJoiningPointCompareBlock(p1->x > p2->x, p1->x == p2->x, \
                                                p1->y < p2->y, p1->y == p2->y) \
                     /* EOF 'SCWaterfallViewJoiningPointCompareBlockRightTop' */

#define SCWaterfallViewJoiningPointCompareBlockBottomLeft()                    \
        SCWaterfallViewJoiningPointCompareBlock(p1->y > p2->y, p1->y == p2->y, \
                                                p1->x < p2->x, p1->x == p2->x) \
                   /* EOF 'SCWaterfallViewJoiningPointCompareBlockBottomLeft' */

#define SCWaterfallViewJoiningPointCompareBlockLeftBottom()                    \
        SCWaterfallViewJoiningPointCompareBlock(p1->x < p2->x, p1->x == p2->x, \
                                                p1->y > p2->y, p1->y == p2->y) \
                   /* EOF 'SCWaterfallViewJoiningPointCompareBlockLeftBottom' */

#define SCWaterfallViewJoiningPointCompareBlockBottomRight()                   \
        SCWaterfallViewJoiningPointCompareBlock(p1->y > p2->y, p1->y == p2->y, \
                                                p1->x > p2->x, p1->x == p2->x) \
                  /* EOF 'SCWaterfallViewJoiningPointCompareBlockBottomRight' */

#define SCWaterfallViewJoiningPointCompareBlockRightBottom()                   \
        SCWaterfallViewJoiningPointCompareBlock(p1->x > p2->x, p1->x == p2->x, \
                                                p1->y > p2->y, p1->y == p2->y) \
                  /* EOF 'SCWaterfallViewJoiningPointCompareBlockRightBottom' */
