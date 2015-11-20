//
//  SCColor.m
//  SnowCat
//
//  Created by Moky on 14-3-18.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "S9String.h"
#import "SCColor.h"

@implementation SCColor

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	CGFloat red = 0.0f, green = 0.0f, blue = 0.0f, alpha = 1.0f;
	
	if ([dict isKindOfClass:[NSDictionary class]])
	{
		// as a dictionary
		red = [[dict objectForKey:@"red"] floatValue] / 255;
		green = [[dict objectForKey:@"green"] floatValue] / 255;
		blue = [[dict objectForKey:@"blue"] floatValue] / 255;
		alpha = [dict objectForKey:@"alpha"] ? [[dict objectForKey:@"alpha"] floatValue] : 1.0f;
		if (alpha > 1) {
			alpha /= 255;
		}
	}
	else if ([dict isKindOfClass:[NSString class]])
	{
		// as a string
		NSString * string = (NSString *)dict;
		string = [string trim];
		if ([string rangeOfString:@"clear"].location != NSNotFound)
		{
			// clear color
			alpha = 0.0f;
		}
		else if ([string hasPrefix:@"0x"])
		{
			// 0xFFFFFF
			// 0xFFFFFF,0.5
			NSUInteger len = [string length];
			if (len >= 8) {
				NSString * rgbString = [string substringWithRange:NSMakeRange(2, 6)];
				unsigned int rgb;
				NSScanner * scaner = [[NSScanner alloc] initWithString:rgbString];
				[scaner scanHexInt:&rgb];
				[scaner release];
				
				unsigned char r = (rgb & 0x00FF0000) >> 16;
				unsigned char g = (rgb & 0x0000FF00) >> 8;
				unsigned char b = (rgb & 0x000000FF);
				red   = r / 255.0f;
				green = g / 255.0f;
				blue  = b / 255.0f;
				
				// alhpa
				if (len >= 10) {
					NSString * aString = [string substringWithRange:NSMakeRange(9, len - 9)];
					alpha = [aString floatValue];
				}
			}
		}
		else
		{
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
					red = [[array objectAtIndex:0] floatValue] / 255.0f;
					green = [[array objectAtIndex:1] floatValue] / 255.0f;
					blue = [[array objectAtIndex:2] floatValue] / 255.0f;
					if ([array count] >= 4) {
						alpha = [[array objectAtIndex:3] floatValue];
						if (alpha > 1) {
							alpha /= 255.0f;
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
