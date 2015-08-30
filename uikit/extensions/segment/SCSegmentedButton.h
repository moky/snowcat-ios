//
//  SCSegmentedButton.h
//  SnowCat
//
//  Created by Moky on 15-4-13.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "SCUIKit.h"

UIKIT_EXTERN UISegmentedButtonAutoLayoutDirection UISegmentedButtonAutoLayoutDirectionFromString(NSString * string);

@interface SCSegmentedButton : UISegmentedButton<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UISegmentedButton *)segmentedButton;

@end
