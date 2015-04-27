//
//  SCLog.h
//  SnowCat
//
//  Created by Moky on 14-3-17.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"

#ifdef NDEBUG
#	define SCLog(...)   do {} while(0)
#else
#	define SCLog(...)   NSLog(@"<%@:%d>%s %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#endif
