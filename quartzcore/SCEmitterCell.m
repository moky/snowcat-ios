//
//  SCEmitterCell.m
//  SnowCat
//
//  Created by Moky on 14-12-31.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "scMacros.h"
#import "SCGeometry.h"
#import "SCColor.h"
#import "SCImage.h"
#import "SCEmitterCell.h"

NSArray * SCEmitterCellsFromArray(NSArray * array)
{
	NSMutableArray * mArray = [[NSMutableArray alloc] initWithCapacity:[array count]];
	
	NSEnumerator * enumerator = [array objectEnumerator];
	NSDictionary * item;
	CAEmitterCell * cell;
	while (item = [enumerator nextObject]) {
		cell = [CAEmitterCell emitterCell];
		[SCEmitterCell setAttributes:item to:cell];
		[mArray addObject:cell];
	}
	
	return [mArray autorelease];
}

@implementation SCEmitterCell

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

+ (BOOL) setAttributes:(NSDictionary *)dict to:(CAEmitterCell *)emitterCell
{
	NSAssert([dict isKindOfClass:[NSDictionary class]], @"parameters error: %@", dict);
	
	SC_SET_ATTRIBUTES_AS_STRING  (emitterCell, dict, name);
	SC_SET_ATTRIBUTES_AS_BOOL    (emitterCell, dict, enabled);
	SC_SET_ATTRIBUTES_AS_FLOAT   (emitterCell, dict, birthRate);
	
	SC_SET_ATTRIBUTES_AS_FLOAT   (emitterCell, dict, lifetime);
	SC_SET_ATTRIBUTES_AS_FLOAT   (emitterCell, dict, lifetimeRange);
	
	SC_SET_ATTRIBUTES_AS_FLOAT   (emitterCell, dict, emissionLatitude);
	SC_SET_ATTRIBUTES_AS_FLOAT   (emitterCell, dict, emissionLongitude);
	
	SC_SET_ATTRIBUTES_AS_FLOAT   (emitterCell, dict, emissionRange);
	
	SC_SET_ATTRIBUTES_AS_FLOAT   (emitterCell, dict, velocity);
	SC_SET_ATTRIBUTES_AS_FLOAT   (emitterCell, dict, velocityRange);
	
	SC_SET_ATTRIBUTES_AS_FLOAT   (emitterCell, dict, xAcceleration);
	SC_SET_ATTRIBUTES_AS_FLOAT   (emitterCell, dict, yAcceleration);
	SC_SET_ATTRIBUTES_AS_FLOAT   (emitterCell, dict, zAcceleration);
	
	SC_SET_ATTRIBUTES_AS_FLOAT   (emitterCell, dict, scale);
	SC_SET_ATTRIBUTES_AS_FLOAT   (emitterCell, dict, scaleRange);
	SC_SET_ATTRIBUTES_AS_FLOAT   (emitterCell, dict, scaleSpeed);
	
	SC_SET_ATTRIBUTES_AS_FLOAT   (emitterCell, dict, spin);
	SC_SET_ATTRIBUTES_AS_FLOAT   (emitterCell, dict, spinRange);
	
	SC_SET_ATTRIBUTES_AS_FLOAT   (emitterCell, dict, redRange);
	SC_SET_ATTRIBUTES_AS_FLOAT   (emitterCell, dict, greenRange);
	SC_SET_ATTRIBUTES_AS_FLOAT   (emitterCell, dict, blueRange);
	SC_SET_ATTRIBUTES_AS_FLOAT   (emitterCell, dict, alphaRange);
	
	SC_SET_ATTRIBUTES_AS_FLOAT   (emitterCell, dict, redSpeed);
	SC_SET_ATTRIBUTES_AS_FLOAT   (emitterCell, dict, greenSpeed);
	SC_SET_ATTRIBUTES_AS_FLOAT   (emitterCell, dict, blueSpeed);
	SC_SET_ATTRIBUTES_AS_FLOAT   (emitterCell, dict, alphaSpeed);
	
	SC_SET_ATTRIBUTES_AS_CGRECT  (emitterCell, dict, contentsRect);
	
	SC_SET_ATTRIBUTES_AS_STRING  (emitterCell, dict, minificationFilter);
	SC_SET_ATTRIBUTES_AS_STRING  (emitterCell, dict, magnificationFilter);
	
	SC_SET_ATTRIBUTES_AS_FLOAT   (emitterCell, dict, minificationFilterBias);
	
	//--
	
	// contents
	id contents = [dict objectForKey:@"contents"];
	if (!contents) {
		contents = [dict objectForKey:@"image"];
	}
	if (contents) {
		UIImage * image = [SCImage create:contents autorelease:NO];
		emitterCell.contents = (id)[image CGImage];
		[image release];
	}
	
	// color
	id color = [dict objectForKey:@"color"];
	if (color) {
		UIColor * clr = [SCColor create:color autorelease:NO];
		emitterCell.color = [clr CGColor];
		[clr release];
	}
	
	// emitterCells
	NSArray * emitterCells = [dict objectForKey:@"emitterCells"];
	if (emitterCells) {
		NSAssert([emitterCells isKindOfClass:[NSArray class]], @"emitterCells must be an array: %@", emitterCells);
		emitterCell.emitterCells = SCEmitterCellsFromArray(emitterCells);
	}
	
	// style
	
	return YES;
}

@end
