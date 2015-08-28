//
//  SCString+DeviceSuffix.m
//  SnowCat
//
//  Created by Moky on 15-6-17.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCClient.h"
#import "SCString+DeviceSuffix.h"

//
//  Retina
//
NS_INLINE NSString * retina_path(NSString * filename, NSString * ext) {
	NSFileManager * fm = [NSFileManager defaultManager];
	BOOL isDirectory = NO;
	
	NSString * path = [filename stringByAppendingString:SC_PATH_SUFFIX_RETINA];
	
	// Retina
	path = [path stringByAppendingPathExtension:ext];
	if ([fm fileExistsAtPath:path isDirectory:&isDirectory]) {
		return path; // @2x
	}
	return nil;
}

NS_INLINE NSString * retina3x_path(NSString * filename, NSString * ext) {
	NSFileManager * fm = [NSFileManager defaultManager];
	BOOL isDirectory = NO;
	
	NSString * path = [filename stringByAppendingString:@"@3x"];
	
	// Retina
	path = [path stringByAppendingPathExtension:ext];
	if ([fm fileExistsAtPath:path isDirectory:&isDirectory]) {
		return path; // @3x
	}
	return nil;
}

//
//  iPad 1/2/...
//
NS_INLINE NSString * ipad_path(NSString * filename, NSString * ext, BOOL retina) {
	NSFileManager * fm = [NSFileManager defaultManager];
	BOOL isDirectory = NO;
	
	NSString * path = [filename stringByAppendingString:SC_PATH_SUFFIX_IPAD];
	
	if (retina) {
		// Retina iPad
		NSString * path2 = retina_path(path, ext);
		if (path2) {
			return path2; // ~ipad@2x
		}
	}
	
	// iPad
	path = [path stringByAppendingPathExtension:ext];
	if ([fm fileExistsAtPath:path isDirectory:&isDirectory]) {
		return path; // ~ipad
	}
	return nil;
}

//
//  iPhone 3/3GS/4/4s
//
NS_INLINE NSString * iphone_path(NSString * filename, NSString * ext, BOOL retina) {
	NSFileManager * fm = [NSFileManager defaultManager];
	BOOL isDirectory = NO;
	
	NSString * path = [filename stringByAppendingString:SC_PATH_SUFFIX_IPHONE];
	
	if (retina) {
		// Retina iPhone/iPod
		NSString * path2 = retina_path(path, ext);
		if (path2) {
			return path2; // ~iphone@2x
		}
	}
	
	// iPhone/iPod
	path = [path stringByAppendingPathExtension:ext];
	if ([fm fileExistsAtPath:path isDirectory:&isDirectory]) {
		return path; // ~iphone
	}
	return nil;
}

//
//  iPhone 5/5s
//
NS_INLINE NSString * iphone5_path(NSString * filename, NSString * ext/*, BOOL retina = YES*/) {
	
	NSString * path = [filename stringByAppendingString:SC_PATH_SUFFIX_568H];
	
	// Retina iPhone5/iPod5
	NSString * path2 = retina_path(path, ext);
	if (path2) {
		return path2; // -568h@2x
	}
	
	return nil;
}

//
//  iPhone 6
//
NS_INLINE NSString * iphone6_path(NSString * filename, NSString * ext/*, BOOL retina = YES*/) {
	
	NSString * path = [filename stringByAppendingString:SC_PATH_SUFFIX_667H];
	
	// Retina iPhone6
	NSString * path2 = retina_path(path, ext);
	if (path2) {
		return path2; // -667h@2x
	}
	
	return nil;
}

//
//  iPhone 6+
//
NS_INLINE NSString * iphone6p_path(NSString * filename, NSString * ext/*, BOOL retina = YES*/) {
	
	NSString * path = [filename stringByAppendingString:SC_PATH_SUFFIX_736H];
	
	// Retina iPhone6+
	NSString * path2 = retina3x_path(path, ext);
	if (path2) {
		return path2; // -736h@3x
	}
	
	return nil;
}

@implementation NSString (DeviceSuffix)

- (NSString *) appendDeviceSuffix
{
	SCClient * client = [SCClient getInstance];
	BOOL retina   = [client isRetina];
	BOOL ipad     = [client isPad];
	BOOL iphone5  = NO;
	BOOL iphone6  = NO;
	BOOL iphone6p = NO;
	if (!ipad && retina) {
		CGSize s = client.screenSize;
		if (s.width == 568.0f || s.height == 568.0f) {
			iphone5 = YES;
		} else if (s.width == 667.0f || s.height == 667.0f) {
			iphone6 = YES;
		} else if (s.width == 736.0f || s.height == 736.0f) {
			iphone6p = YES;
		}
	}
	
	NSString * ext = [self pathExtension];
	NSString * filename = [self stringByDeletingPathExtension];
	
	NSString * path = nil;
	
	if (ipad)
	{
		// iPad
		path = ipad_path(filename, ext, retina);        // iPad x
	}
	else
	{
		// iPhone
		if (iphone5)
		{
			path = iphone5_path(filename, ext);         // iPhone 5
		}
		else if (iphone6)
		{
			path = iphone6_path(filename, ext);         // iPhone 6
			if (!path) {
				path = iphone6p_path(filename, ext);    // iPhone 6 <= 6+
				if (!path) {
					path = iphone5_path(filename, ext); // iPhone 6 <= 5
				}
			}
		}
		else if (iphone6p)
		{
			path = iphone6p_path(filename, ext);        // iPhone 6+
			if (!path) {
				path = iphone6_path(filename, ext);     // iPhone 6+ <= 6
				if (!path) {
					path = iphone5_path(filename, ext); // iPhone 6+ <= 5
				}
			}
		}
		
		if (!path) {
			path = iphone_path(filename, ext, retina);  // iPhone x
		}
	}
	
	if (!path && retina) {
		path = retina_path(filename, ext);              // Retina
	}
	
	return path ? path : self;
}

@end
