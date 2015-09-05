//
//  SCDockScrollView.h
//  SnowCat
//
//  Created by Moky on 14-8-5.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "SlanissueToolkit.h"

#import "SCUIKit.h"

@interface SCDockScrollView : UIDockScrollView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIDockScrollView *)dockScrollView;

@end
