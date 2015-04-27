//
//  SCView+Reflection.m
//  SnowCat
//
//  Created by Moky on 14-7-8.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "SCView+Reflection.h"

#define SC_VIEW_REFLECTION_LAYER_NAME          @"ReflectionLayer"

#define SC_VIEW_REFLECTION_LAYER_OPACITY       0.3f
#define SC_VIEW_REFLECTION_LAYER_START_POINT   0.4f
#define SC_VIEW_REFLECTION_LAYER_END_POINT     1.0f

@implementation UIView (Reflection)

- (BOOL) hasReflection
{
	NSEnumerator * enumerator = [self.layer.sublayers objectEnumerator];
	CALayer * layer;
	while (layer = [enumerator nextObject]) {
		if ([layer.name isEqualToString:SC_VIEW_REFLECTION_LAYER_NAME]) {
			return YES;
		}
	}
	return NO;
}

- (void) hideReflection
{
	NSArray * subLayers = self.layer.sublayers;
	CALayer * layer;
	for (NSInteger index = [subLayers count] - 1; index >= 0; --index) {
		layer = [subLayers objectAtIndex:index];
		if ([layer.name isEqualToString:SC_VIEW_REFLECTION_LAYER_NAME]) {
			[layer removeFromSuperlayer];
		}
	}
}

- (void) showReflection
{
	[self showReflectionWithOpacity:SC_VIEW_REFLECTION_LAYER_OPACITY
						 startPoint:SC_VIEW_REFLECTION_LAYER_START_POINT
						   endPoint:SC_VIEW_REFLECTION_LAYER_END_POINT];
}

- (void) showReflectionWithOpacity:(CGFloat)opacity
{
	[self showReflectionWithOpacity:opacity
						 startPoint:SC_VIEW_REFLECTION_LAYER_START_POINT
						   endPoint:SC_VIEW_REFLECTION_LAYER_END_POINT];
}

- (void) showReflectionWithStartPoint:(CGFloat)start endPoint:(CGFloat)end
{
	[self showReflectionWithOpacity:SC_VIEW_REFLECTION_LAYER_OPACITY
						 startPoint:start
						   endPoint:end];
}

- (void) showReflectionWithOpacity:(CGFloat)opacity startPoint:(CGFloat)start endPoint:(CGFloat)end
{
	if ([self hasReflection]) {
		// already add reflection
		return;
	}
	
	CALayer * layer = self.layer;
	
	CGRect bounds = self.bounds;
	CGSize size = bounds.size;
	CGFloat width = size.width;
	CGFloat height = size.height;
	CGPoint center = CGPointMake(width * 0.5f, height * 0.5f);
	
	// reflection
	CALayer * reflectLayer = [[CALayer alloc] init];
	reflectLayer.name = SC_VIEW_REFLECTION_LAYER_NAME;
	reflectLayer.contents = layer.contents;
	reflectLayer.bounds = bounds;
	reflectLayer.position = CGPointMake(center.x, center.y + height);
	reflectLayer.opacity = opacity;
	reflectLayer.transform = CATransform3DMakeRotation(M_PI, 1.0f, 0.0f, 0.0f);
	
	// mask for reflection
	CGColorRef whiteColor = [UIColor whiteColor].CGColor;
	CGColorRef clearColor = [UIColor clearColor].CGColor;
	
	CAGradientLayer * mask = [[CAGradientLayer alloc] init];
	mask.bounds = bounds;
	mask.position = center;
	mask.colors = [NSArray arrayWithObjects:(id)clearColor, (id)whiteColor, nil];
	mask.startPoint = CGPointMake(0.5f, start);
	mask.endPoint = CGPointMake(0.5f, end);
	reflectLayer.mask = mask;
	[mask release];
	
	[layer addSublayer:reflectLayer];
	[reflectLayer release];
}

@end
