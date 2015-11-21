//
//  SCTextAttachment.m
//  SnowCat
//
//  Created by Moky on 15-5-14.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCImage.h"
#import "SCTextAttachment.h"

@implementation SCTextAttachment

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	self = [self initWithData:nil ofType:nil];
	if (self) {
		[self setAttributes:dict];
	}
	return self;
}

// create:
SC_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) setAttributes:(NSDictionary *)dict to:(NSTextAttachment *)textAttachment
{
	NSAssert([dict isKindOfClass:[NSDictionary class]], @"parameters error: %@", dict);
	
	// contents
	
	SC_SET_ATTRIBUTES_AS_STRING(textAttachment, dict, fileType);
	
	// fileWrapper
	
	SC_SET_ATTRIBUTES_AS_UIIMAGE(textAttachment, dict, image);
	
	// bounds
	NSString * bounds = [dict objectForKey:@"bounds"];
	if (bounds) {
		textAttachment.bounds = CGRectFromString(bounds);
	}
	
	return YES;
}

@end
