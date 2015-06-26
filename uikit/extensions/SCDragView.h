//
//  SCDragView.h
//  SnowCat
//
//  Created by Moky on 14-11-14.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "SCUIKit.h"
#import "SCDragView+UIKit.h"

@interface SCDragView : UIDragView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIDragView *)dragView;

@end
