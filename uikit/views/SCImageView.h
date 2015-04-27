//
//  SCImageView.h
//  SnowCat
//
//  Created by Moky on 14-3-18.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCDataLoader.h"
#import "SCView.h"

@interface SCImageView : UIImageView<SCUIKit, SCDataDelegate>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIImageView *)imageView;

@end
