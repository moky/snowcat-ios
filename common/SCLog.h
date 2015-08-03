//
//  SCLog.h
//  SnowCat
//
//  Created by Moky on 14-3-17.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scMacros.h"

//{
//	char * str = path;
//	if (str) {
//		str = strrchr(path, '/');
//		if (str) {
//			str += 1;
//		} else {
//			str = strrchr(path, '\\');
//			if (str) {
//				str += 1;
//			} else {
//				str = path;
//			}
//		}
//	}
//	return str;
//}
#define SCFilenameFromString(czPath) ({                                        \
    const char * path = czPath; /* avoid multi-accessing */                    \
    const char * str = path;                                                   \
    if (str) {                                                                 \
        str = strrchr(path, '/');                                              \
        if (str) {                                                             \
            str += 1; /* skip '/' */                                           \
        } else {                                                               \
            str = strrchr(path, '\\');                                         \
            if (str) {                                                         \
                str += 1; /* skip '\' */                                       \
            } else {                                                           \
                str = path; /* the whole string */                             \
            }                                                                  \
        }                                                                      \
    }                                                                          \
    str;})                                                                     \
                                                /* EOF 'SCFilenameFromString' */

#ifdef NDEBUG
#	define SCLog(...)   do {} while(0)
#elif DEBUG
#	define SCLog(...)                                                          \
        printf("<%s:%d>%s %s\r\n", SCFilenameFromString(__FILE__), __LINE__,   \
            __FUNCTION__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#else
#	define SCLog(...)   do {} while(0)
#endif
