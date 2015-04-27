//
//  SCEventHandler.h
//  SnowCat
//
//  Created by Moky on 14-3-23.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCUIKit.h"

@protocol SCEventDelegate <NSObject>

- (BOOL) doEvent:(NSString *)eventName withResponder:(id)responder;
- (BOOL) doAction:(NSString *)actionName withResponder:(id)responder;

@end

@interface SCEventHandler : SCObject<SCEventDelegate> @end

@interface SCEventHandler (pool)

+ (void) setDelegate:(id<SCEventDelegate>)delegate forResponder:(id)responder;
+ (id<SCEventDelegate>) delegateForResponder:(id)responder;
+ (void) removeDelegateForResponder:(id)responder;

@end

// Convenient interface

UIKIT_EXTERN void SCDoEvent(NSString * event, id responder);
