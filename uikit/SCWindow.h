//
//  SCWindow.h
//  SnowCat
//
//  Created by Moky on 14-3-17.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "SCView.h"

@interface SCWindow : UIWindow

/**
 *  apply 'rootViewController' in the window's definition
 */
+ (BOOL) apply:(NSDictionary *)dict withWindow:(UIWindow *)window;

/**
 *  load the definition of window from entrance path, and apply it
 */
+ (BOOL) launch:(NSString *)entrance withWindow:(UIWindow *)window;

@end
