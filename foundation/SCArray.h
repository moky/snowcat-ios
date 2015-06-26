//
//  SCArray.h
//  SnowCat
//
//  Created by Moky on 15-6-6.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SCArrayObjectAtIndex(array, index)                                     \
        ((index) < [(array) count] && (index) >= 0 ?                           \
            [(array) objectAtIndex:(index)] : nil)                             \
                                                /* EOF 'SCArrayObjectAtIndex' */

#define SCArrayAddObject(array, object)                                        \
        if (object) {                                                          \
            [(array) addObject:(object)]                                       \
        }                                                                      \
                                                    /* EOF 'SCArrayAddObject' */

#define SCArrayInsertObjectAtIndex(array, object, index)                       \
        if ((object) && (index) <= [(array) count] && (index) >= 0) {          \
            [(array) insertObject:(object) atIndex:(index)];                   \
        }                                                                      \
                                          /* EOF 'SCArrayInsertObjectAtIndex' */

#define SCArrayRemoveObjectAtIndex(array, index)                               \
        if ((index) < [(array) count] && (index) >= 0) {                       \
            [(array) removeObjectAtIndex:(index)];                             \
        }                                                                      \
                                          /* EOF 'SCArrayRemoveObjectAtIndex' */

#define SCArrayReplaceObjectAtIndex(array, object, index)                      \
        if ((object) && (index) < [(array) count] && (index) >= 0) {           \
            [(array) replaceObjectAtIndex:(index) withObject:(object)];        \
        }                                                                      \
                                         /* EOF 'SCArrayReplaceObjectAtIndex' */

#define SCArrayRemoveObject(array, object)                                     \
        if (object) {                                                          \
            [(array) removeObject:(object)];                                   \
        }                                                                      \
                                                 /* EOF 'SCArrayRemoveObject' */
