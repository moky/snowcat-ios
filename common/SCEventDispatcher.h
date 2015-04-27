//
//  SCEventDispatcher.h
//  SnowCat
//
//  Created by Moky on 14-3-25.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCEventDispatcher : NSNotificationCenter

+ (instancetype) getInstance;

// add event responder for event name
- (void) addEventResponder:(id)responder withEventName:(NSString *)eventName;
- (void) addEventResponder:(id)responder withEvents:(NSArray *)events; // events: event name list

// remove all event binding for the responder
- (void) removeEventResponder:(id)responder;

// event notification handler
- (void) receiveEventNotification:(NSNotification *)notification;

@end
