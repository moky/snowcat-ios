//
//  SCProgressView.h
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCView.h"

UIKIT_EXTERN UIProgressViewStyle UIProgressViewStyleFromString(NSString * string);

@interface SCProgressView : UIProgressView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIProgressView *)progressView;

@end
