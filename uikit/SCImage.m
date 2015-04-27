//
//  SCImage.m
//  SnowCat
//
//  Created by Moky on 14-3-17.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCMemoryCache.h"
#import "SCURL.h"
#import "SCImage.h"

//typedef NS_ENUM(NSInteger, UIImageOrientation) {
//    UIImageOrientationUp,            // default orientation
//    UIImageOrientationDown,          // 180 deg rotation
//    UIImageOrientationLeft,          // 90 deg CCW
//    UIImageOrientationRight,         // 90 deg CW
//    UIImageOrientationUpMirrored,    // as above but image mirrored along other axis. horizontal flip
//    UIImageOrientationDownMirrored,  // horizontal flip
//    UIImageOrientationLeftMirrored,  // vertical flip
//    UIImageOrientationRightMirrored, // vertical flip
//};
UIImageOrientation UIImageOrientationFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"RightMirrored")
			return UIImageOrientationRightMirrored;
		SC_SWITCH_CASE(string, @"LeftMirrored")
			return UIImageOrientationLeftMirrored;
		SC_SWITCH_CASE(string, @"DownMirrored")
			return UIImageOrientationDownMirrored;
		SC_SWITCH_CASE(string, @"UpMirrored")
			return UIImageOrientationUpMirrored;
		SC_SWITCH_CASE(string, @"Right")
			return UIImageOrientationRight;
		SC_SWITCH_CASE(string, @"Left")
			return UIImageOrientationLeft;
		SC_SWITCH_CASE(string, @"Down")
			return UIImageOrientationDown;
		SC_SWITCH_CASE(string, @"Up")
			return UIImageOrientationUp;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return UIImageOrientationUp;
}

@implementation UIImage (IO)

- (BOOL) writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile
{
	NSData * data = nil;
	NSString * ext = [[path pathExtension] lowercaseString];
	if ([ext isEqualToString:@"png"]) {
		data = UIImagePNGRepresentation(self);
	} else if ([ext isEqualToString:@"jpg"] || [ext isEqualToString:@"jpeg"]) {
		data = UIImageJPEGRepresentation(self, 1.0f);
	} else {
		NSAssert(false, @"unsupportd image format: %@", path);
		return NO;
	}
	return [data writeToFile:path atomically:useAuxiliaryFile];
}

@end

#pragma mark -

@interface SCImage ()

@property(nonatomic, retain) SCDataLoader * downloader;

@end

@implementation SCImage

@synthesize downloader = _downloader;
@synthesize delegate = _delegate;

- (void) dealloc
{
	self.downloader = nil;
	self.delegate = nil;
	
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		self.downloader = nil;
		self.delegate = nil;
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	self = [self init];
	if (self) {
	}
	return self;
}

- (void) setDelegate:(id<SCDataDelegate>)delegate
{
	_delegate = delegate;
	
	if (delegate) {
		_downloader.delegate = self;
	}
}

// create:
SC_IMPLEMENT_CREATE_FUNCTION()
+ (id) create:(NSDictionary *)dict autorelease:(BOOL)autorelease
{
	NSAssert([dict isKindOfClass:[NSDictionary class]] || [dict isKindOfClass:[NSString class]], @"parameters error: %@", dict);
	NSString * file = nil;
	if ([dict isKindOfClass:[NSString class]]) {
		file = (NSString *)dict;
	} else {
		NSString * className = [dict objectForKey:@"Class"];
		if (className) {
			// try as scobject
			return [SCObject create:dict autorelease:autorelease];
		} else {
			file = [dict objectForKey:@"File"];
		}
	}
	
	if (autorelease) {
		return [self imageNamed:file];
	} else {
		return [[self imageNamed:file] retain];
	}
}

#pragma mark -

+ (UIImage *) imageNamed:(NSString *)filename
{
	NSAssert(filename, @"image filename cannot be empty");
	SCMemoryCache * cache = [SCMemoryCache getInstance];
	
	// try from cache
	UIImage * image = [cache objectForKey:filename];
	if (image) {
		return image;
	}
	
	// full path
	SCURL * url = [[SCURL alloc] initWithString:filename isDirectory:NO];
	if ([url isFileURL]) {
		// load image from local file
		image = [[UIImage alloc] initWithContentsOfFile:[url path]]; // detect high-resolution image automatically
	} else {
		SCDataLoader * downloader = [[SCDataLoader alloc] initWithContentsOfURL:url delegate:nil];
		if (downloader.data.length > 0) {
			// load image from cache
			image = [[UIImage alloc] initWithData:downloader.data];
		} else {
			// download image from remote asynchronously
			image = [[SCImage alloc] init];
			[(SCImage *)image setDownloader:downloader];
		}
		[downloader release];
	}
	[url release];
	
	//NSAssert([image isKindOfClass:[UIImage class]], @"failed to load image: %@", filename);
	[cache setObject:image forKey:filename]; // memory cache, image.reference++
	[image release];
	
	return image;
}

#pragma mark - SCDataDelegate

- (void) onDataLoad:(NSData *)data withURL:(NSURL *)url
{
	NSAssert([data isKindOfClass:[NSData class]], @"error: %@", url);
	
	self = [self initWithData:data];
	
	[_delegate onDataLoad:data withURL:url];
	
	self.downloader = nil; // remove downloader
}

- (void) onDataError:(NSData *)data withURL:(NSURL *)url
{
	[_delegate onDataError:data withURL:url];
	
	self.downloader = nil; // remove downloader
}

- (void) onDataStart:(NSData *)data withURL:(NSURL *)url
{
	if ([_delegate respondsToSelector:@selector(onDataStart:withURL:)]) {
		[_delegate onDataStart:data withURL:url];
	}
}

- (void) onDataReceive:(NSData *)data contentLength:(long long)contentLength withURL:(NSURL *)url
{
	if ([_delegate respondsToSelector:@selector(onDataReceive:contentLength:withURL:)]) {
		[_delegate onDataReceive:data contentLength:contentLength withURL:url];
	}
}

@end
