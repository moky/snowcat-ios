//
//  SCEmitterLayer.m
//  SnowCat
//
//  Created by Moky on 14-12-31.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "scMacros.h"
#import "SCGeometry.h"
#import "SCLayer.h"
#import "SCEmitterCell.h"
#import "SCEmitterLayer.h"

///** `emitterShape' values. **/
//
//CA_EXTERN NSString * const kCAEmitterLayerPoint
//__OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
//CA_EXTERN NSString * const kCAEmitterLayerLine
//__OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
//CA_EXTERN NSString * const kCAEmitterLayerRectangle
//__OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
//CA_EXTERN NSString * const kCAEmitterLayerCuboid
//__OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
//CA_EXTERN NSString * const kCAEmitterLayerCircle
//__OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
//CA_EXTERN NSString * const kCAEmitterLayerSphere
//__OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
NSString * CAEmitterShapeFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Point");
			return kCAEmitterLayerPoint;
		SC_SWITCH_CASE(string, @"Line");
			return kCAEmitterLayerLine;
		SC_SWITCH_CASE(string, @"Rect");
			return kCAEmitterLayerRectangle;
		SC_SWITCH_CASE(string, @"Cub");
			return kCAEmitterLayerCuboid;
		SC_SWITCH_CASE(string, @"Circle");
			return kCAEmitterLayerCircle;
		SC_SWITCH_CASE(string, @"Sphere");
			return kCAEmitterLayerSphere;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return string;
}

///** `emitterMode' values. **/
//
//CA_EXTERN NSString * const kCAEmitterLayerPoints
//__OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
//CA_EXTERN NSString * const kCAEmitterLayerOutline
//__OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
//CA_EXTERN NSString * const kCAEmitterLayerSurface
//__OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
//CA_EXTERN NSString * const kCAEmitterLayerVolume
//__OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
NSString * CAEmitterModeFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Point");
			return kCAEmitterLayerPoints;
		SC_SWITCH_CASE(string, @"Outline");
			return kCAEmitterLayerOutline;
		SC_SWITCH_CASE(string, @"Surface");
			return kCAEmitterLayerSurface;
		SC_SWITCH_CASE(string, @"Volume");
			return kCAEmitterLayerVolume;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return string;
}

///** `renderMode' values. **/
//
//CA_EXTERN NSString * const kCAEmitterLayerUnordered
//__OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
//CA_EXTERN NSString * const kCAEmitterLayerOldestFirst
//__OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
//CA_EXTERN NSString * const kCAEmitterLayerOldestLast
//__OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
//CA_EXTERN NSString * const kCAEmitterLayerBackToFront
//__OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
//CA_EXTERN NSString * const kCAEmitterLayerAdditive
//__OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
NSString * CARenderModeFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Unordered");
			return kCAEmitterLayerUnordered;
		SC_SWITCH_CASE(string, @"First");
			return kCAEmitterLayerOldestFirst;
		SC_SWITCH_CASE(string, @"Last");
			return kCAEmitterLayerOldestLast;
		SC_SWITCH_CASE(string, @"BackToFront");
			return kCAEmitterLayerBackToFront;
		SC_SWITCH_CASE(string, @"Additive");
			return kCAEmitterLayerAdditive;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return string;
}


@implementation SCEmitterLayer

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

+ (BOOL) setAttributes:(NSDictionary *)dict to:(CAEmitterLayer *)emitterLayer
{
	if (![SCLayer setAttributes:dict to:emitterLayer]) {
		return NO;
	}
	
	SC_SET_ATTRIBUTES_AS_FLOAT        (emitterLayer, dict, birthRate);
	SC_SET_ATTRIBUTES_AS_FLOAT        (emitterLayer, dict, lifetime);
	SC_SET_ATTRIBUTES_AS_CGPOINT      (emitterLayer, dict, emitterPosition);
	SC_SET_ATTRIBUTES_AS_FLOAT        (emitterLayer, dict, emitterZPosition);
	SC_SET_ATTRIBUTES_AS_CGSIZE       (emitterLayer, dict, emitterSize);
	SC_SET_ATTRIBUTES_AS_FLOAT        (emitterLayer, dict, emitterDepth);
	SC_SET_ATTRIBUTES_AS_BOOL         (emitterLayer, dict, preservesDepth);
	SC_SET_ATTRIBUTES_AS_FLOAT        (emitterLayer, dict, velocity);
	SC_SET_ATTRIBUTES_AS_FLOAT        (emitterLayer, dict, scale);
	SC_SET_ATTRIBUTES_AS_FLOAT        (emitterLayer, dict, spin);
	SC_SET_ATTRIBUTES_AS_UNSIGNED_INT (emitterLayer, dict, seed);
	
	//--
	
	// emitterCells
	NSArray * emitterCells = [dict objectForKey:@"emitterCells"];
	if (emitterCells) {
		NSAssert([emitterCells isKindOfClass:[NSArray class]], @"emitterCells must be an array: %@", emitterCells);
		emitterLayer.emitterCells = SCEmitterCellsFromArray(emitterCells);
	}
	
	// emitterShape
	NSString * emitterShape = [dict objectForKey:@"emitterShape"];
	if (emitterShape) {
		emitterLayer.emitterShape = CAEmitterShapeFromString(emitterShape);
	}
	
	// emitterMode
	NSString * emitterMode = [dict objectForKey:@"emitterMode"];
	if (emitterMode) {
		emitterLayer.emitterMode = CAEmitterModeFromString(emitterMode);
	}
	
	// renderMode
	NSString * renderMode = [dict objectForKey:@"renderMode"];
	if (renderMode) {
		emitterLayer.renderMode = CARenderModeFromString(renderMode);
	}
	
	return YES;
}

@end
