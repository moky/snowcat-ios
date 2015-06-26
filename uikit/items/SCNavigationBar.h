//
//  SCNavigationBar.h
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "SCView.h"

@interface SCNavigationBar : UINavigationBar<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UINavigationBar *)navigationBar;

@end
