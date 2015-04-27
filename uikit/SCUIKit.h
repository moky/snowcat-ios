//
//  SCUIKit.h
//  SnowCat
//
//  Created by Moky on 14-3-17.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCObject.h"

@protocol SCUIKit <SCObject>

@optional

@property(nonatomic, readwrite) NSInteger scTag;  // use for hierarchy searching
@property(nonatomic, retain) NSString * nodeFile; // filename, use for awaked from nib

- (void) buildHandlers:(NSDictionary *)dict;

@end

@interface SCUIKit : SCObject<SCUIKit>

// supporting 'ObjectFromFile'
+ (NSDictionary *) dictionaryByDiggingCreationInfo:(NSDictionary *)dict;

@end

@interface SCUIKit (Relationship)

+ (UIResponder *) getTarget:(NSString *)target responder:(UIResponder *)responder;

@end

// create:
#define SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()                                  \
              SC_IMPLEMENT_CREATE_FUNCTIONS()                                  \
                                 /* EOF 'SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS' */

// buildHandlers:
#define SC_UIKIT_IMELEMENT_BUILD_HANDLERS_FUNCTION()                           \
    - (void) buildHandlers:(NSDictionary *)dict                                \
    {                                                                          \
        [SCResponder onCreate:self withDictionary:dict];                       \
    }                                                                          \
                          /* EOF 'SC_UIKIT_IMELEMENT_BUILD_HANDLERS_FUNCTION' */

// awakeFromNib
#define SC_UIKIT_IMPLEMENT_AWAKE_FUNCTION()                                    \
    - (void) awakeFromNib                                                      \
    {                                                                          \
        [super awakeFromNib];                                                  \
        [SCNib awakeFromNib:self withNodeFile:_nodeFile];                      \
    }                                                                          \
                                   /* EOF 'SC_UIKIT_IMPLEMENT_AWAKE_FUNCTION' */


// setAttributes:
#define SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()                           \
              SC_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()                           \
                          /* EOF 'SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION' */

// call 'setAttributes:'
#define SC_UIKIT_SET_ATTRIBUTES(object, class, dictionary)                     \
              SC_SET_ATTRIBUTES(object, class, dictionary)                     \
                                             /* EOF 'SC_UIKIT_SET_ATTRIBUTES' */

// call 'dictionaryByDiggingCreationInfo:'
#define SC_UIKIT_DIG_CREATION_INFO(dict)                                       \
    (dict) = [SCUIKit dictionaryByDiggingCreationInfo:(dict)]                  \
                                          /* EOF 'SC_UIKIT_DIG_CREATION_INFO' */
