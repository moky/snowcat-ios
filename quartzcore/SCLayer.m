//
//  SCLayer.m
//  SnowCat
//
//  Created by Moky on 14-8-6.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "scMacros.h"
#import "SCObject.h"
#import "SCGeometry.h"
#import "SCImage.h"
#import "SCColor.h"
#import "SCLayer.h"

/* Bit definitions for `edgeAntialiasingMask' property. */
//typedef NS_OPTIONS (unsigned int, CAEdgeAntialiasingMask)
//{
//	kCALayerLeftEdge	= 1U << 0,	/* Minimum X edge. */
//	kCALayerRightEdge	= 1U << 1,	/* Maximum X edge. */
//	kCALayerBottomEdge	= 1U << 2,	/* Minimum Y edge. */
//	kCALayerTopEdge	= 1U << 3,	/* Maximum Y edge. */
//};
CAEdgeAntialiasingMask CAEdgeAntialiasingMaskFromString(NSString * string)
{
	// all
	if ([string rangeOfString:@"All"].location != NSNotFound) {
		return kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
	}
	
	CAEdgeAntialiasingMask mask = 0;
	
	// left
	if ([string rangeOfString:@"Left"].location != NSNotFound) {
		mask |= kCALayerLeftEdge;
	}
	// right
	if ([string rangeOfString:@"Right"].location != NSNotFound) {
		mask |= kCALayerRightEdge;
	}
	// top
	if ([string rangeOfString:@"Top"].location != NSNotFound) {
		mask |= kCALayerTopEdge;
	}
	// bottom
	if ([string rangeOfString:@"Bottom"].location != NSNotFound) {
		mask |= kCALayerBottomEdge;
	}
	
	return mask;
}

///** Layer `contentsGravity' values. **/
//CA_EXTERN NSString * const kCAGravityCenter           __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
//CA_EXTERN NSString * const kCAGravityTop              __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
//CA_EXTERN NSString * const kCAGravityBottom           __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
//CA_EXTERN NSString * const kCAGravityLeft             __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
//CA_EXTERN NSString * const kCAGravityRight            __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
//CA_EXTERN NSString * const kCAGravityTopLeft          __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
//CA_EXTERN NSString * const kCAGravityTopRight         __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
//CA_EXTERN NSString * const kCAGravityBottomLeft       __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
//CA_EXTERN NSString * const kCAGravityBottomRight      __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
//CA_EXTERN NSString * const kCAGravityResize           __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
//CA_EXTERN NSString * const kCAGravityResizeAspect     __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
//CA_EXTERN NSString * const kCAGravityResizeAspectFill __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
NSString * CAGravityFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Fill");        // ResizeAspectFill
			return kCAGravityResizeAspectFill;
		SC_SWITCH_CASE(string, @"Aspect");      // ResizeAspect
			return kCAGravityResizeAspect;
		SC_SWITCH_CASE(string, @"Resize");      // Resize
			return kCAGravityResize;
		SC_SWITCH_CASE(string, @"BottomRight"); // BottomRight
			return kCAGravityBottomRight;
		SC_SWITCH_CASE(string, @"BottomLeft");  // BottomLeft
			return kCAGravityBottomLeft;
		SC_SWITCH_CASE(string, @"TopRight");    // TopRight
			return kCAGravityTopRight;
		SC_SWITCH_CASE(string, @"TopLeft");     // TopLeft
			return kCAGravityTopLeft;
		SC_SWITCH_CASE(string, @"Right");       // Right
			return kCAGravityRight;
		SC_SWITCH_CASE(string, @"Left");        // Left
			return kCAGravityLeft;
		SC_SWITCH_CASE(string, @"Bottom");      // Bottom
			return kCAGravityBottom;
		SC_SWITCH_CASE(string, @"Top");         // Top
			return kCAGravityTop;
		SC_SWITCH_CASE(string, @"Center");      // Center
			return kCAGravityCenter;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return string;
}

///** Contents filter names. **/
//CA_EXTERN NSString * const kCAFilterNearest __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
//CA_EXTERN NSString * const kCAFilterLinear  __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
NSString * CAFilterNameFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Nearest")
			return kCAFilterNearest;
		SC_SWITCH_CASE(string, @"Linear")
			return kCAFilterLinear;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return string;
}

@implementation SCLayer

//- (instancetype)init; /* The designated initializer. */
//- (instancetype)initWithLayer:(id)layer;

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	self = [self init];
	if (self) {
		// default properties
	}
	return self;
}

// create:
SC_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) setAttributes:(NSDictionary *)dict to:(CALayer *)layer
{
	NSAssert([dict isKindOfClass:[NSDictionary class]], @"parameters error: %@", dict);
	
	SC_SET_ATTRIBUTES_AS_CGRECT  (layer, dict, bounds);
	SC_SET_ATTRIBUTES_AS_CGPOINT (layer, dict, position);
	SC_SET_ATTRIBUTES_AS_FLOAT   (layer, dict, zPosition);
	SC_SET_ATTRIBUTES_AS_CGPOINT (layer, dict, anchorPoint);
	SC_SET_ATTRIBUTES_AS_FLOAT   (layer, dict, anchorPointZ);
	// transform
	SC_SET_ATTRIBUTES_AS_CGRECT  (layer, dict, frame);
	SC_SET_ATTRIBUTES_AS_BOOL    (layer, dict, hidden);
	SC_SET_ATTRIBUTES_AS_BOOL    (layer, dict, doubleSided);
	SC_SET_ATTRIBUTES_AS_BOOL    (layer, dict, geometryFlipped);
	
	// sublayerTransform
	SC_SET_ATTRIBUTES_AS_BOOL    (layer, dict, masksToBounds);
	SC_SET_ATTRIBUTES_AS_CGRECT  (layer, dict, contentsRect);
	SC_SET_ATTRIBUTES_AS_FLOAT   (layer, dict, contentsScale);
	SC_SET_ATTRIBUTES_AS_CGRECT  (layer, dict, contentsCenter);
	SC_SET_ATTRIBUTES_AS_FLOAT   (layer, dict, minificationFilterBias);
	SC_SET_ATTRIBUTES_AS_BOOL    (layer, dict, opaque);
	SC_SET_ATTRIBUTES_AS_BOOL    (layer, dict, needsDisplayOnBoundsChange);
	SC_SET_ATTRIBUTES_AS_BOOL    (layer, dict, drawsAsynchronously);
	
	SC_SET_ATTRIBUTES_AS_BOOL    (layer, dict, allowsEdgeAntialiasing);
	SC_SET_ATTRIBUTES_AS_FLOAT   (layer, dict, cornerRadius);
	SC_SET_ATTRIBUTES_AS_FLOAT   (layer, dict, borderWidth);
	SC_SET_ATTRIBUTES_AS_FLOAT   (layer, dict, opacity);
	SC_SET_ATTRIBUTES_AS_BOOL    (layer, dict, allowsGroupOpacity);
	// compositingFilter
	// filters
	// backgroundFilters
	SC_SET_ATTRIBUTES_AS_BOOL    (layer, dict, shouldRasterize);
	SC_SET_ATTRIBUTES_AS_FLOAT   (layer, dict, rasterizationScale);
	SC_SET_ATTRIBUTES_AS_FLOAT   (layer, dict, shadowOpacity);
	SC_SET_ATTRIBUTES_AS_CGSIZE  (layer, dict, shadowOffset);
	SC_SET_ATTRIBUTES_AS_FLOAT   (layer, dict, shadowRadius);
	// shadowPath
	// actions
	SC_SET_ATTRIBUTES_AS_STRING  (layer, dict, name);
	// delegate
	// style
	
	//--
	
	// sublayers
	NSArray * sublayers = [dict objectForKey:@"sublayers"];
	if (sublayers) {
		NSAssert([sublayers isKindOfClass:[NSArray class]], @"sublayers must be an array: %@", sublayers);
		NSEnumerator * enumerator = [sublayers objectEnumerator];
		NSDictionary * item;
		SCLayer * subLayer;
		while (item = [enumerator nextObject]) {
			NSAssert([item isKindOfClass:[NSDictionary class]], @"item must be a dictionary: %@", item);
			subLayer = [SCLayer create:item autorelease:NO];
			NSAssert([subLayer isKindOfClass:[CALayer class]], @"failed to create sub layer: %@", item);
			if (subLayer) {
				[layer addSublayer:subLayer];
				SC_SET_ATTRIBUTES(subLayer, SCLayer, item);
				[subLayer release];
			}
		}
	}
	
	// edgeAntialiasingMask
	NSString * edgeAntialiasingMask = [dict objectForKey:@"edgeAntialiasingMask"];
	if (edgeAntialiasingMask) {
		layer.edgeAntialiasingMask = CAEdgeAntialiasingMaskFromString(edgeAntialiasingMask);
	}
	
	// mask
	NSDictionary * mask = [dict objectForKey:@"mask"];
	if (mask) {
		SCLayer * m = [SCLayer create:mask autorelease:NO];
		layer.mask = m;
		SC_SET_ATTRIBUTES(m, SCLayer, mask);
		[m release];
	}
	
	// contents
	id contents = [dict objectForKey:@"contents"];
	if (!contents) {
		contents = [dict objectForKey:@"image"];
	}
	if (contents) {
		UIImage * image = [SCImage create:contents autorelease:NO];
		layer.contents = (id)[image CGImage];
		[image release];
	}
	
	// backgroundColor
	id backgroundColor = [dict objectForKey:@"backgroundColor"];
	if (backgroundColor) {
		UIColor * color = [SCColor create:backgroundColor autorelease:NO];
		layer.backgroundColor = [color CGColor];
		[color release];
	}
	
	// borderColor
	id borderColor = [dict objectForKey:@"borderColor"];
	if (borderColor) {
		UIColor * color = [SCColor create:borderColor autorelease:NO];
		layer.borderColor = [color CGColor];
		[color release];
	}
	
	// shadowColor
	id shadowColor = [dict objectForKey:@"shadowColor"];
	if (shadowColor) {
		UIColor * color = [SCColor create:shadowColor autorelease:NO];
		layer.shadowColor = [color CGColor];
		[color release];
	}
	
	// contentsGravity
	NSString * contentsGravity = [dict objectForKey:@"contentsGravity"];
	if (contentsGravity) {
		layer.contentsGravity = CAGravityFromString(contentsGravity);
	}
	
	// minificationFilter
	NSString * minificationFilter = [dict objectForKey:@"minificationFilter"];
	if (minificationFilter) {
		layer.minificationFilter = CAFilterNameFromString(minificationFilter);
	}
	
	// magnificationFilter
	NSString * magnificationFilter = [dict objectForKey:@"magnificationFilter"];
	if (magnificationFilter) {
		layer.magnificationFilter = CAFilterNameFromString(magnificationFilter);
	}
	
	return YES;
}

@end
