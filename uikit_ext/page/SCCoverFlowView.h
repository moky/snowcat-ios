//
//  SCCoverFlowView.h
//  SnowCat
//
//  Created by Moky on 14-7-8.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "SCUIKit.h"
#import "SCCoverFlowView+UIKit.h"

@interface SCCoverFlowView : UICoverFlowView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UICoverFlowView *)coverFlowView;

@end
