//
//  SCFont.m
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCFont.h"

@implementation SCFont

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	self = [self init];
	if (self) {
	}
	return self;
}

// create:
SC_IMPLEMENT_CREATE_FUNCTION()
+ (id) create:(NSDictionary *)dict autorelease:(BOOL)autorelease
{
	NSString * className = [dict objectForKey:@"Class"];
	if (className) {
		return [SCObject create:dict autorelease:autorelease];
	}
	
	UIFont * font = nil;
	
	id fontSize = [dict objectForKey:@"fontSize"];
	if (!fontSize) {
		fontSize = [dict objectForKey:@"size"];
	}
	CGFloat size = fontSize ? [fontSize floatValue] : SC_DEFAULT_FONT_SIZE;
	
	NSString * fontName = [dict objectForKey:@"fontName"];
	if (!fontName) {
		font = [UIFont fontWithName:SC_DEFAULT_FONT_NAME size:size];
	} else if ([fontName isEqualToString:@"systemFont"]) {
		font = [UIFont systemFontOfSize:size];
	} else if ([fontName isEqualToString:@"boldSystemFont"]) {
		font = [UIFont boldSystemFontOfSize:size];
	} else if ([fontName isEqualToString:@"italicSystemFont"]) {
		font = [UIFont italicSystemFontOfSize:size];
	} else {
		font = [UIFont fontWithName:fontName size:size];
	}
	
	if (autorelease) {
		return font;
	} else {
		return [font retain];
	}
}

@end
