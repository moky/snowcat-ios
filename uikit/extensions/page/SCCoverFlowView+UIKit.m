//
//  UICoverFlowView.m
//  SnowCat
//
//  Created by Moky on 15-5-5.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "SCView+Transform.h"
#import "SCCoverFlowView+UIKit.h"

@implementation UICoverFlowView

- (void) performEffectOnScrollView:(UIScrollView *)scrollView
{
	[self _performCoverFlowEffectOnScrollView:scrollView];
}

//
//  <Formulas>
//
//      1. rotate   : r = f(x) = atan(x)
//
//      2. scale    : s = g(x) = e^(-|x|)
//
//      3. position : l = h(x) = f(x) / (PI / 2)
//

// perform cover flow effect
- (void) _performCoverFlowEffectOnScrollView:(UIScrollView *)scrollView
{
	CGSize size = scrollView.bounds.size;
	CGPoint offset = scrollView.contentOffset;
	CGPoint center = CGPointMake(offset.x + size.width * 0.5, offset.y + size.height * 0.5);
	
	CGFloat distance;
	CGFloat rotate;
	CGFloat scale;
	CGFloat position;
	
	CGFloat SCALE_MIN   = self.scale;
	CGFloat SCALE_RANGE = 1.0f - SCALE_MIN;
	
	NSArray * subviews = scrollView.subviews;
	UIView * subview;
	NSUInteger count = [subviews count];
	
	if (self.direction == UIPageScrollViewDirectionHorizontal) {
		// distance between each item and the center item
		distance = - offset.x / size.width;
		
		for (NSInteger i = 0; i < count; ++i, distance += 1.0f) {
			// pick out each subview
			subview = [subviews objectAtIndex:i];
			
			// 0. reset
			[subview resetTransform];
			
			// 1. rotate
			rotate = atanf(distance);
			[subview rollWithRotation:-rotate]; // rotating around axis Y
			
			// 2. scale
			scale = expf(-fabsf(distance)) * SCALE_RANGE + SCALE_MIN;
			[subview scaleWithScale:scale];
			
			// 3. position
			position = rotate / M_PI_2 * subview.bounds.size.width;
			subview.center = CGPointMake(center.x + position, center.y);
		}
	} else {
		// distance between each item and the center item
		distance = - offset.y / size.height;
		
		for (NSInteger i = 0; i < count; ++i, distance += 1.0f) {
			// pick out each subview
			subview = [subviews objectAtIndex:i];
			
			// 0. reset
			[subview resetTransform];
			
			// 1. rotate
			rotate = atanf(distance);
			[subview pitchWithRotation:rotate]; // rotating around axis X
			
			// 2. scale
			scale = expf(-fabsf(distance)) * SCALE_RANGE + SCALE_MIN;
			[subview scaleWithScale:scale];
			
			// 3. position
			position = rotate / M_PI_2 * subview.bounds.size.height;
			subview.center = CGPointMake(center.x, center.y + position);
		}
	}
}

@end