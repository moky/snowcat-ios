//
//  SCObject.h
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCObject <NSObject>

+ (id) create:(NSDictionary *)dict;
+ (id) create:(NSDictionary *)dict autorelease:(BOOL)autorelease;

- (instancetype) initWithDictionary:(NSDictionary *)dict;

@optional
- (BOOL) setAttributes:(NSDictionary *)dict;

@end

@interface SCObject : NSObject<SCObject>

@end

// create:
#define SC_IMPLEMENT_CREATE_FUNCTION()                                         \
    + (id) create:(NSDictionary *)dict                                         \
    {                                                                          \
        return [self create:dict autorelease:YES];                             \
    }                                                                          \
                                        /* EOF 'SC_IMPLEMENT_CREATE_FUNCTION' */
#define SC_IMPLEMENT_CREATE_FUNCTIONS()                                        \
    SC_IMPLEMENT_CREATE_FUNCTION()                                             \
    + (id) create:(NSDictionary *)dict autorelease:(BOOL)autorelease           \
    {                                                                          \
        NSString * className = [dict objectForKey:@"Class"];                   \
        if (className) {                                                       \
            return [SCObject create:dict autorelease:autorelease];             \
        } else if (autorelease) {                                              \
            return [[[self alloc] initWithDictionary:dict] autorelease];       \
        } else {                                                               \
            return [[self alloc] initWithDictionary:dict];                     \
        }                                                                      \
    }                                                                          \
                                       /* EOF 'SC_IMPLEMENT_CREATE_FUNCTIONS' */

// setAttributes:
#define SC_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()                                 \
    - (BOOL) setAttributes:(NSDictionary *)dict                                \
    {                                                                          \
        return [[self class] setAttributes:dict to:self];                      \
    }                                                                          \
                                /* EOF 'SC_IMPLEMENT_SET_ATTRIBUTES_FUNCTION' */

// call 'setAttributes:'
#define SC_SET_ATTRIBUTES(object, class, dictionary)                           \
    ([(object) respondsToSelector:@selector(setAttributes:)] ?                 \
    [((class *)(object)) setAttributes:(dictionary)] :                         \
    [class setAttributes:(dictionary) to:(object)])                            \
                                                   /* EOF 'SC_SET_ATTRIBUTES' */
