//
//  SCLabel.h
//  SnowCat
//
//  Created by Moky on 14-3-22.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCView.h"

@interface SCLabel : UILabel<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UILabel *)label;

@end
