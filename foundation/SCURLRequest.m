//
//  SCURLRequest.m
//  SnowCat
//
//  Created by Moky on 14-6-7.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCClient.h"
#import "SCURLRequest.h"

@implementation SCURLRequest

// the designated initializer
- (instancetype) initWithURL:(NSURL *)URL
				 cachePolicy:(NSURLRequestCachePolicy)cachePolicy
			 timeoutInterval:(NSTimeInterval)timeoutInterval
{
	self = [super initWithURL:URL
				  cachePolicy:cachePolicy
			  timeoutInterval:timeoutInterval];
	
	if (self) {
		[self _addHTTPHeaders];
	}
	return self;
}

- (void) _addHTTPHeaders
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	SCClient * app = [SCClient getInstance];
	
	// client
	NSString * clientName = app.name;
	NSString * clientVersion = app.version;
	NSString * client = [NSString stringWithFormat:@"%@/%@", clientName, clientVersion];
	// imei
	NSString * imei = app.deviceIdentifier;
	// device
	NSString * model = app.deviceModel;
	NSString * hardware = app.hardware;
	NSString * device = [NSString stringWithFormat:@"%@/%@", model, hardware];
	// os
	NSString * systemName = app.systemName;
	NSString * systemVersion = app.systemVersion;
	NSString * os = [NSString stringWithFormat:@"%@/%@", systemName, systemVersion];
	// screen
	CGSize size = app.screenSize;
	CGFloat scale = app.screenScale;
	NSString * screen = [NSString stringWithFormat:@"%.0fx%.0f@%.1f",
						 size.width, size.height, scale];
	
	[self addValue:client forHTTPHeaderField:@"User-Agent"]; // try to append to 'User-Agent'
//	[self setValue:client forHTTPHeaderField:@"Client"];
//	[self setValue:screen forHTTPHeaderField:@"Screen"];
//	[self setValue:os forHTTPHeaderField:@"OS"];
//	[self setValue:device forHTTPHeaderField:@"Device"];
//	[self setValue:imei forHTTPHeaderField:@"IMEI"];
	
	NSString * info = [NSString stringWithFormat:@"%@ (%@; %@; %@)",
					   client, device, os, screen];
	[self setValue:info forHTTPHeaderField:@"Client"];
	[self setValue:imei forHTTPHeaderField:@"IMEI"];
	
	[pool release];
}

@end
