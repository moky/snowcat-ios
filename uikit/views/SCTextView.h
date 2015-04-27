//
//  SCTextView.h
//  SnowCat
//
//  Created by Moky on 14-4-3.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCScrollView.h"

@interface SCTextView : UITextView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UITextView *)textView;

@end
