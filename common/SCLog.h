//
//  SCLog.h
//  SnowCat
//
//  Created by Moky on 14-3-17.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scMacros.h"

#ifdef NDEBUG
#	define SCLog(...)   do {} while(0)
#elif DEBUG
//#	define SCLog(...)   NSLog(@"<%@:%d>%s %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#	define SCLog(...)   printf("<%s:%d>%s %s\r\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __FUNCTION__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#else
#	define SCLog(...)   do {} while(0)
#endif
