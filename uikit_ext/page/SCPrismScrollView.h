//
//  SCPrismScrollView.h
//  SnowCat
//
//  Created by Moky on 14-4-17.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "SlanissueToolkit.h"

#import "SCUIKit.h"

@interface SCPrismScrollView : UIPrismScrollView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIPrismScrollView *)prismScrollView;

@end
