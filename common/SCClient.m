//
//  SCClient.m
//  SnowCat
//
//  Created by Moky on 14-6-7.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCClient.h"

@interface SCClient ()

@property(nonatomic, retain) NSString * urlParameters;

@end

@implementation SCClient

@synthesize urlParameters = _urlParameters;

- (void) dealloc
{
	[_urlParameters release];
	
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		self.urlParameters = nil;
	}
	return self;
}

// singleton implementations
SC_IMPLEMENT_SINGLETON_FUNCTIONS(getInstance)

- (NSString *) urlParameters
{
	if (!_urlParameters) {
		// client
		NSString * clientName = self.name;
		NSString * clientVersion = self.version;
		NSString * client = [NSString stringWithFormat:@"%@/%@", clientName, clientVersion];
		// imei
		NSString * imei = self.deviceIdentifier;
		// device
		NSString * model = self.deviceModel;
		NSString * hardware = self.hardware;
		NSString * device = [NSString stringWithFormat:@"%@/%@",
							 [model stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
							 [hardware stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		// os
		NSString * systemName = self.systemName;
		NSString * systemVersion = self.systemVersion;
		NSString * os = [NSString stringWithFormat:@"%@/%@",
						 [systemName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
						 [systemVersion stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		// screen
		CGSize size = self.screenSize;
		CGFloat scale = self.screenScale;
		NSString * screen = [NSString stringWithFormat:@"%.0fx%.0f@%.1f",
							 size.width, size.height, scale];
		
		self.urlParameters = [NSString stringWithFormat:@"client=%@&screen=%@&os=%@&device=%@&imei=%@", client, screen, os, device, imei];
	}
	return _urlParameters;
}

- (BOOL) openURL:(NSString *)url
{
	NSAssert([url isKindOfClass:[NSString class]], @"url error: %@", url);
	if (!url) {
		return NO;
	}
	
	UIApplication * app = [UIApplication sharedApplication];
	
	// check whether can open
	NSURL * URL = [NSURL URLWithString:url];
	if ([app canOpenURL:URL]) {
		SCLog(@"opening url: [%@]", url);
		[app openURL:URL]; // open it!
		return YES;
	}
	
	// cannot open, try the next fragment
	SCLog(@"the app is not installed, url = %@", url);
	NSRange range = [url rangeOfString:@"#"];
	if (range.location == NSNotFound) {
		SCLog(@"no other fragment in url: %@", url);
		return NO;
	}
	url = [url substringFromIndex:range.location+1];
	
	SCLog(@"continue trying url: %@", url);
	return [self openURL:url];
}

@end
