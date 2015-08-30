//
//  SCScrollRefreshView.h
//  SnowCat
//
//  Created by Moky on 15-1-11.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "SCScrollRefreshControl.h"

@interface SCScrollRefreshView : UIScrollRefreshView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIScrollRefreshView *)scrollRefreshView;

@end
