//
//  SCWebViewDelegate.h
//  SnowCat
//
//  Created by Moky on 14-4-14.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "SCUIKit.h"

#if !TARGET_OS_TV

@protocol SCWebViewDelegate <UIWebViewDelegate>

@end

@interface SCWebViewDelegate : SCObject<SCWebViewDelegate>

@end

#endif
