//
//  SCCoverFlowView.h
//  SnowCat
//
//  Created by Moky on 14-7-8.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCDockScrollView.h"

@interface UICoverFlowView : UIDockScrollView

@end

#pragma mark -

@interface SCCoverFlowView : UICoverFlowView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UICoverFlowView *)coverFlowView;

@end
