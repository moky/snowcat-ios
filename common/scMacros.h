//
//  scMacros.h
//  SnowCat
//
//  Created by Moky on 14-3-17.
//  Copyright (c) 2014 Moky. All rights reserved.
//


#define SC_NODE_FILE_PARSER_USE_OUTPUT_FILE 0
#define SC_NODE_FILE_PARSER_OUTPUT_FILE_EXT @"output.mof"


#define SC_DEFAULT_FONT_NAME                @"Courier"
#define SC_DEFAULT_FONT_SIZE                [UIFont systemFontSize]


//------------------------------------------------------------- file path suffix
#define SC_PATH_SUFFIX_568H                 @"-568h"
#define SC_PATH_SUFFIX_IPHONE               @"~iphone"
#define SC_PATH_SUFFIX_IPAD                 @"~ipad"
#define SC_PATH_SUFFIX_RETINA               @"@2x"

//-------------------------------------------------------------- localize string
#define SCLocalizedString(key, default)                  ( (key) ?             \
        NSLocalizedString((key), @"localized for key") : ( (default) ?         \
        NSLocalizedString((default), @"localized for default") : nil ) )       \
                                                   /* EOF 'SCLocalizedString' */

//----------------------------------------------------------- system directories
#define SCApplicationDirectory()   [[SCClient getInstance] applicationDirectory]
#define SCDocumentDirectory()      [[SCClient getInstance] documentDirectory]
#define SCCachesDirectory()        [[SCClient getInstance] cachesDirectory]
#define SCTemporaryDirectory()     [[SCClient getInstance] temporaryDirectory]

#define SCSystemVersion()    [[[SCClient getInstance] systemVersion] floatValue]

//-------------------------------------------------------------------- singleton
#define SC_IMPLEMENT_SINGLETON_FUNCTIONS(getInstance)                          \
    static id s_singleton_instance = nil;                                      \
    + (instancetype) getInstance                                               \
    {                                                                          \
        @synchronized(self) {                                                  \
            if (!s_singleton_instance) {                                       \
                [self new]; /* alloc & init */                                 \
            }                                                                  \
        }                                                                      \
        return s_singleton_instance;                                           \
    }                                                                          \
    + (instancetype) allocWithZone:(NSZone *)zone                              \
    {                                                                          \
        NSAssert(s_singleton_instance == nil, @"Singleton!");                  \
        @synchronized(self) {                                                  \
            if (!s_singleton_instance) {                                       \
                s_singleton_instance = [super allocWithZone:zone];             \
            }                                                                  \
        }                                                                      \
        return s_singleton_instance;                                           \
    }                                                                          \
    - (id) copy { return self; }                                               \
    - (id) mutableCopy { return self; }                                        \
    - (instancetype) retain { return self; }                                   \
    - (oneway void) release { /* do nothing */ }                               \
    - (instancetype) autorelease { return self; }                              \
    - (NSUInteger) retainCount { return NSUIntegerMax; }                       \
                                    /* EOF 'SC_IMPLEMENT_SINGLETON_FUNCTIONS' */


//------------------------------------------------------------------ switch case
//	do {
//		if (string) {
//			{
//			};
//			if ([string rangeOfString:@"Yes"].location != NSNotFound) {
//				return YES;
//			};
//			if ([string rangeOfString:@"No"].location != NSNotFound) {
//				return NO;
//			};
//		};
//		return Default;
//	} while(0);

#define SC_SWITCH_BEGIN(var)        do { if (var) { {
#define SC_SWITCH_CASE(var, value)  }; if ([(var) rangeOfString:(value)].location != NSNotFound) {
#define SC_SWITCH_DEFAULT           }; };
#define SC_SWITCH_END               } while(0);


//--------------------------------------------------------------- set attributes
#define SC_SET_ATTRIBUTES_AS_STRING(obj, dict, name)                           \
    NSString * name = [dict objectForKey:@#name];                              \
    if (name) {                                                                \
        obj.name = name;                                                       \
    }                                                                          \
                                         /* EOF 'SC_SET_ATTRIBUTES_AS_STRING' */
#define SC_SET_ATTRIBUTES_AS_INTEGER(obj, dict, name)                          \
    id name = [dict objectForKey:@#name];                                      \
    if (name) {                                                                \
        obj.name = [name integerValue];                                        \
    }                                                                          \
                                        /* EOF 'SC_SET_ATTRIBUTES_AS_INTEGER' */
#define SC_SET_ATTRIBUTES_AS_INT(obj, dict, name)                              \
    id name = [dict objectForKey:@#name];                                      \
    if (name) {                                                                \
        obj.name = [name intValue];                                            \
    }                                                                          \
                                            /* EOF 'SC_SET_ATTRIBUTES_AS_INT' */
#define SC_SET_ATTRIBUTES_AS_UNSIGNED_INTEGER(obj, dict, name)                 \
    id name = [dict objectForKey:@#name];                                      \
    if (name) {                                                                \
        obj.name = [name unsignedIntegerValue];                                \
    }                                                                          \
                               /* EOF 'SC_SET_ATTRIBUTES_AS_UNSIGNED_INTEGER' */
#define SC_SET_ATTRIBUTES_AS_UNSIGNED_INT(obj, dict, name)                     \
    id name = [dict objectForKey:@#name];                                      \
    if (name) {                                                                \
        obj.name = [name unsignedIntValue];                                    \
    }                                                                          \
                                   /* EOF 'SC_SET_ATTRIBUTES_AS_UNSIGNED_INT' */
#define SC_SET_ATTRIBUTES_AS_FLOAT(obj, dict, name)                            \
    id name = [dict objectForKey:@#name];                                      \
    if (name) {                                                                \
        obj.name = [name floatValue];                                          \
    }                                                                          \
                                          /* EOF 'SC_SET_ATTRIBUTES_AS_FLOAT' */
#define SC_SET_ATTRIBUTES_AS_BOOL(obj, dict, name)                             \
    id name = [dict objectForKey:@#name];                                      \
    if (name) {                                                                \
        obj.name = [name boolValue];                                           \
    }                                                                          \
                                           /* EOF 'SC_SET_ATTRIBUTES_AS_BOOL' */
#define SC_SET_ATTRIBUTES_AS_CGRECT(obj, dict, name)                           \
    NSString * name = [dict objectForKey:@#name];                              \
    if (name) {                                                                \
        obj.name = CGRectFromStringWithNode(name, obj);                        \
    }                                                                          \
                                         /* EOF 'SC_SET_ATTRIBUTES_AS_CGRECT' */
#define SC_SET_ATTRIBUTES_AS_CGSIZE(obj, dict, name)                           \
    NSString * name = [dict objectForKey:@#name];                              \
    if (name) {                                                                \
        obj.name = CGSizeFromStringWithNode(name, obj);                        \
    }                                                                          \
                                         /* EOF 'SC_SET_ATTRIBUTES_AS_CGSIZE' */
#define SC_SET_ATTRIBUTES_AS_CGPOINT(obj, dict, name)                          \
    NSString * name = [dict objectForKey:@#name];                              \
    if (name) {                                                                \
        obj.name = CGPointFromStringWithNode(name, obj);                       \
    }                                                                          \
                                        /* EOF 'SC_SET_ATTRIBUTES_AS_CGPOINT' */
