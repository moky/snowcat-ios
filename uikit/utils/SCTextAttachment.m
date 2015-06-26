//
//  SCTextAttachment.m
//  SnowCat
//
//  Created by Moky on 15-5-14.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

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
	
	// fileType
	NSString * fileType = [dict objectForKey:@"fileType"];
	if (fileType) {
		textAttachment.fileType = fileType;
	}
	
	// fileWrapper
	
	// image
	NSDictionary * image = [dict objectForKey:@"image"];
	if (image) {
		SCImage * img = [SCImage create:image autorelease:NO];
		textAttachment.image = img;
		[img release];
	}
	
	// bounds
	NSString * bounds = [dict objectForKey:@"bounds"];
	if (bounds) {
		textAttachment.bounds = CGRectFromString(bounds);
	}
	
	return YES;
}

@end
