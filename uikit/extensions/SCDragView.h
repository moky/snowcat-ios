//
//  SCDragView.h
//  SnowCat
//
//  Created by Moky on 14-11-14.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCView+Gesture.h"
#import "SCGroundView.h"

@interface UIDragView : UIGroundView<UIViewDragGestureDelegate>

@end

@interface SCDragView : UIDragView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIDragView *)dragView;

@end
