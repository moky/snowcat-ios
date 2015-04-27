//
//  SCClient.m
//  SnowCat
//
//  Created by Moky on 14-6-7.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCDevice.h"
#import "SCClient.h"

@interface SCClient ()

@property(nonatomic, retain) NSString * hardware;
@property(nonatomic, retain) NSString * deviceIdentifier;
@property(nonatomic, retain) NSString * deviceModel;
@property(nonatomic, retain) NSString * systemName;
@property(nonatomic, retain) NSString * systemVersion;

// app bundle
@property(nonatomic, retain) NSString * name;
@property(nonatomic, retain) NSString * version;

// DOS
@property(nonatomic, retain) NSString * applicationDirectory;
@property(nonatomic, retain) NSString * documentDirectory;
@property(nonatomic, retain) NSString * cachesDirectory;
@property(nonatomic, retain) NSString * temporaryDirectory;

@end

@implementation SCClient

@synthesize screenSize = _screenSize;
@synthesize screenScale = _screenScale;
@synthesize windowSize = _windowSize;
@synthesize statusBarHeight = _statusBarHeight;

@synthesize hardware = _hardware;
@synthesize deviceIdentifier = _deviceIdentifier;
@synthesize deviceModel = _deviceModel;
@synthesize systemName = _systemName;
@synthesize systemVersion = _systemVersion;

@synthesize name = _name;
@synthesize version = _version;

// DOS
@synthesize applicationDirectory = _applicationDirectory;
@synthesize documentDirectory = _documentDirectory;
@synthesize cachesDirectory = _cachesDirectory;
@synthesize temporaryDirectory = _temporaryDirectory;

- (void) dealloc
{
	[_hardware release];
	[_deviceIdentifier release];
	[_deviceModel release];
	[_systemName release];
	[_systemVersion release];
	
	[_name release];
	[_version release];
	
	// DOS
	[_applicationDirectory release];
	[_documentDirectory release];
	[_cachesDirectory release];
	[_temporaryDirectory release];
	
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		UIScreen * screen = [UIScreen mainScreen];
		UIApplication * app = [UIApplication sharedApplication];
		
		_screenSize = screen.bounds.size;
		_screenScale = [screen respondsToSelector:@selector(scale)] ? screen.scale : 1.0f;
		_windowSize = screen.applicationFrame.size;
		_statusBarHeight = app.statusBarFrame.size.height;
		
		self.hardware = nil;
		self.deviceIdentifier = nil;
		self.deviceModel = nil;
		self.systemName = nil;
		self.systemVersion = nil;
		
		self.name = nil;
		self.version = nil;
		
		// DOS
		self.applicationDirectory = nil;
		self.documentDirectory = nil;
		self.cachesDirectory = nil;
		self.temporaryDirectory = nil;
	}
	return self;
}

// singleton implementations
SC_IMPLEMENT_SINGLETON_FUNCTIONS(getInstance)

#pragma mark -

- (NSString *) hardware
{
	if (!_hardware) {
		self.hardware = [[UIDevice currentDevice] machine];
	}
	return _hardware;
}

- (NSString *) deviceIdentifier
{
	if (!_deviceIdentifier) {
		self.deviceIdentifier = [[UIDevice currentDevice] globalIdentifier];
	}
	return _deviceIdentifier;
}

- (NSString *) deviceModel
{
	if (!_deviceModel) {
		self.deviceModel = [[UIDevice currentDevice] model];
	}
	return _deviceModel;
}

- (NSString *) systemName
{
	if (!_systemName) {
		self.systemName = [[UIDevice currentDevice] systemName];
	}
	return _systemName;
}

- (NSString *) systemVersion
{
	if (!_systemVersion) {
		self.systemVersion = [[UIDevice currentDevice] systemVersion];
	}
	return _systemVersion;
}

- (NSString *) name
{
	if (!_name) {
		self.name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
	}
	return _name;
}

- (NSString *) version
{
	if (!_version) {
		self.version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	}
	return _version;
}

#pragma mark DOS

- (NSString *) applicationDirectory
{
	if (!_applicationDirectory) {
		self.applicationDirectory = [[NSBundle mainBundle] resourcePath];
	}
	return _applicationDirectory;
}

- (NSString *) documentDirectory
{
	if (!_documentDirectory) {
		NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSAssert([paths count] > 0, @"failed to locate document directory");
		self.documentDirectory = [paths firstObject];
	}
	return _documentDirectory;
}

- (NSString *) cachesDirectory
{
	if (!_cachesDirectory) {
		NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
		NSAssert([paths count] > 0, @"failed to locate caches directory");
		self.cachesDirectory = [paths firstObject];
	}
	return _cachesDirectory;
}

- (NSString *) temporaryDirectory
{
	if (!_temporaryDirectory) {
		self.temporaryDirectory = NSTemporaryDirectory();
	}
	return _temporaryDirectory;
}

@end

@implementation SCClient (HTTP)

- (NSString *) urlParameters
{
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
	
	return [NSString stringWithFormat:@"client=%@&screen=%@&os=%@&device=%@&imei=%@",
			client, screen, os, device, imei];
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
