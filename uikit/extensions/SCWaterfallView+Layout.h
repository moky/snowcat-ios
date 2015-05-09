//
//  SCWaterfallView+Layout.h
//  SnowCat
//
//  Created by Moky on 15-5-9.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "SCWaterfallView+UIKit.h"

@interface UIWaterfallView (Layout)

+ (CGSize) layoutSubviewsInView:(UIView *)view;

+ (CGSize) layoutSubviewsInView:(UIView *)view
						towards:(UIWaterfallViewDirection)direction;

+ (CGSize) layoutSubviewsInView:(UIView *)view
						towards:(UIWaterfallViewDirection)direction
				spaceHorizontal:(CGFloat)spaceHorizontal
				  spaceVertical:(CGFloat)spaceVertical;

@end

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
