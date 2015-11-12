//
//  SCKaraokeLabel.h
//  SnowCat
//
//  Created by Moky on 15-11-12.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "SlanissueToolkit.h"

#import "SCUIKit.h"

@interface SCKaraokeLabel : UIKaraokeLabel<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIKaraokeLabel *)karaokeView;

@end
