//
//  SCActivityIndicatorView.h
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCView.h"

UIKIT_EXTERN UIActivityIndicatorViewStyle UIActivityIndicatorViewStyleFromString(NSString * string);

@interface SCActivityIndicatorView : UIActivityIndicatorView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIActivityIndicatorView *)activityIndicatorView;

@end
