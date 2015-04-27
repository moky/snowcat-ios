//
//  SCColor.m
//  SnowCat
//
//  Created by Moky on 14-3-18.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCColor.h"

@implementation SCColor

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	CGFloat red = 0.0f, green = 0.0f, blue = 0.0f, alpha = 1.0f;
	
	if ([dict isKindOfClass:[NSDictionary class]]) {
		// as a dictionary
		red = [[dict objectForKey:@"red"] floatValue] / 255;
		green = [[dict objectForKey:@"green"] floatValue] / 255;
		blue = [[dict objectForKey:@"blue"] floatValue] / 255;
		alpha = [dict objectForKey:@"alpha"] ? [[dict objectForKey:@"alpha"] floatValue] : 1.0f;
		if (alpha > 1) {
			alpha /= 255;
		}
	} else if ([dict isKindOfClass:[NSString class]]) {
		// as a string
		NSString * string = (NSString *)dict;
		if ([string isEqualToString:@"clearColor"] || [string isEqualToString:@"clear"]) {
			alpha = 0.0f;
		} else {
			// {r, g, b}
			// {r, g, b, a}
			NSRange range1 = [string rangeOfString:@"{"];
			NSRange range2 = [string rangeOfString:@"}" options:NSBackwardsSearch];
			if (range1.location != NSNotFound && range2.location != NSNotFound) {
				range1.location += 1;
				NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
				
				string = [string substringWithRange:NSMakeRange(range1.location, range2.location - range1.location)];
				NSArray * array = [string componentsSeparatedByString:@","];
				if ([array count] >= 3) {
					red = [[array objectAtIndex:0] floatValue] / 255;
					green = [[array objectAtIndex:1] floatValue] / 255;
					blue = [[array objectAtIndex:2] floatValue] / 255;
					if ([array count] == 4) {
						alpha = [[array objectAtIndex:3] floatValue];
						if (alpha > 1) {
							alpha /= 255;
						}
					}
				}
				
				[pool release];
			}
		}
	}
	
	self = [self initWithRed:red green:green blue:blue alpha:alpha];
	if (self) {
	}
	return self;
}

// create:
SC_IMPLEMENT_CREATE_FUNCTION()
+ (id) create:(NSDictionary *)dict autorelease:(BOOL)autorelease
{
	if ([dict isKindOfClass:[NSDictionary class]]) {
		// try as scobject
		NSString * className = [dict objectForKey:@"Class"];
		if (className) {
			return [SCObject create:dict autorelease:autorelease];
		}
	}
	
	UIColor * color = [[SCColor alloc] initWithDictionary:dict];
	
	if (autorelease) {
		return [color autorelease];
	} else {
		return color;
	}
}

@end
