//
//  scMacros.h
//  SnowCat
//
//  Created by Moky on 14-3-17.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scSlanissueToolkit.h"

#define SC_NODE_FILE_PARSER_USE_OUTPUT_FILE 0
#define SC_NODE_FILE_PARSER_OUTPUT_FILE_EXT @"output.mof"


#if TARGET_OS_TV
#	define SC_DEFAULT_FONT_NAME                @"Courier"
#	define SC_DEFAULT_FONT_SIZE                24 /* ? */
#else
#	define SC_DEFAULT_FONT_NAME                @"Courier"
#	define SC_DEFAULT_FONT_SIZE                [UIFont systemFontSize]
#endif


//------------------------------------------------------------- file path suffix
#define SC_PATH_SUFFIX_736H                 @"-736h"
#define SC_PATH_SUFFIX_667H                 @"-667h"
#define SC_PATH_SUFFIX_568H                 @"-568h"
#define SC_PATH_SUFFIX_IPHONE               @"~iphone"
#define SC_PATH_SUFFIX_IPAD                 @"~ipad"
#define SC_PATH_SUFFIX_RETINA               @"@2x"

//-------------------------------------------------------------- localize string
#define SCTranslatorSetCurrentLanguage(language)                               \
        S9TranslatorSetCurrentLanguage(language)                               \
                                      /* EOF 'SCTranslatorSetCurrentLanguage' */
#define SCTranslatorAddLanguagePack(tableName, bundlePath)                     \
        S9TranslatorAddLanguagePack((tableName), (bundlePath))                 \
                                         /* EOF 'SCTranslatorAddLanguagePack' */
#define SCTranslatorScanLanguagePacks(bundlePath)                              \
        S9TranslatorScanLanguagePacks(bundlePath)                              \
                                       /* EOF 'SCTranslatorScanLanguagePacks' */

#define SCLocalizedString(key, comment)                                        \
        S9LocalizedString((key), (comment))                                    \
                                                   /* EOF 'SCLocalizedString' */
#define SCLocalizedStringFromTable(key, tbl, comment)                          \
        S9LocalizedStringFromTable((key), (tbl), (comment))                    \
                                          /* EOF 'S9LocalizedStringFromTable' */
//#define SCLocalizedString(key, default)                  ( (key) ?             \
//        NSLocalizedString((key), @"localized for key") : ( (default) ?         \
//        NSLocalizedString((default), @"localized for default") : nil ) )       \
//                                                   /* EOF 'SCLocalizedString' */

//----------------------------------------------------------- system directories
#define SCApplicationDirectory()   [[SCClient getInstance] applicationDirectory]
#define SCDocumentDirectory()      [[SCClient getInstance] documentDirectory]
#define SCCachesDirectory()        [[SCClient getInstance] cachesDirectory]
#define SCTemporaryDirectory()     [[SCClient getInstance] temporaryDirectory]

#define SCSystemVersion()    [[[SCClient getInstance] systemVersion] floatValue]

//--------------------------------------------------------------- set attributes
#define SC_SET_ATTRIBUTES_AS_STRING(obj, dict, name)                           \
    NSString * name = [dict objectForKey:@#name];                              \
    if (name) {                                                                \
        obj.name = name;                                                       \
    }                                                                          \
                                         /* EOF 'SC_SET_ATTRIBUTES_AS_STRING' */
#define SC_SET_ATTRIBUTES_AS_LOCALIZED_STRING(obj, dict, name)                 \
    NSString * name = [dict objectForKey:@#name];                              \
    if (name) {                                                                \
        name = SCLocalizedString(name, nil);                                   \
        obj.name = name;                                                       \
    }                                                                          \
                               /* EOF 'SC_SET_ATTRIBUTES_AS_LOCALIZED_STRING' */
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
#define SC_SET_ATTRIBUTES_AS_DOUBLE(obj, dict, name)                           \
    id name = [dict objectForKey:@#name];                                      \
    if (name) {                                                                \
        obj.name = [name doubleValue];                                         \
    }                                                                          \
                                         /* EOF 'SC_SET_ATTRIBUTES_AS_DOUBLE' */
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
#define SC_SET_ATTRIBUTES_AS_UIEDGEINSETS(obj, dict, name)                     \
    NSString * name = [dict objectForKey:@#name];                              \
    if (name) {                                                                \
	    obj.name = UIEdgeInsetsFromString(name);                               \
    }                                                                          \
                                   /* EOF 'SC_SET_ATTRIBUTES_AS_UIEDGEINSETS' */
#define SC_SET_ATTRIBUTES_AS_UIRECTEDGE(obj, dict, name)                       \
    NSString * name = [dict objectForKey:@#name];                              \
    if (name) {                                                                \
        obj.name = UIRectEdgeFromString(name);                                 \
    }                                                                          \
                                     /* EOF 'SC_SET_ATTRIBUTES_AS_UIRECTEDGE' */
#define SC_SET_ATTRIBUTES_AS_UICOLOR(obj, dict, name)                          \
    NSDictionary * name = [dict objectForKey:@#name];                          \
    if (name) {                                                                \
        SCColor * clr = [SCColor create:name autorelease:NO];                  \
        obj.name = clr;                                                        \
        [clr release];                                                         \
    }                                                                          \
                                        /* EOF 'SC_SET_ATTRIBUTES_AS_UICOLOR' */
#define SC_SET_ATTRIBUTES_AS_UIFONT(obj, dict, name)                           \
    NSDictionary * name = [dict objectForKey:@#name];                          \
    if (name) {                                                                \
        SCFont * fnt = [SCFont create:name autorelease:NO];                    \
        obj.name = fnt;                                                        \
        [fnt release];                                                         \
    }                                                                          \
                                         /* EOF 'SC_SET_ATTRIBUTES_AS_UIFONT' */
#define SC_SET_ATTRIBUTES_AS_UIIMAGE(obj, dict, name)                          \
    NSDictionary * name = [dict objectForKey:@#name];                          \
    if (name) {                                                                \
        SCImage * img = [SCImage create:name autorelease:NO];                  \
        obj.name = img;                                                        \
        [img release];                                                         \
    }                                                                          \
                                        /* EOF 'SC_SET_ATTRIBUTES_AS_UIIMAGE' */
