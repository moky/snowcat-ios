//
//  SCWaterfallView.h
//  SnowCat
//
//  Created by Moky on 15-5-8.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "SlanissueToolkit.h"

#import "SCUIKit.h"

UIKIT_EXTERN UIWaterfallViewDirection UIWaterfallViewDirectionFromString(NSString * string);

@interface SCWaterfallView : UIWaterfallView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIWaterfallView *)waterfallView;

@end
