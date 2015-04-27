//
//  SCSearchBar.h
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCView.h"

UIKIT_EXTERN UISearchBarIcon UISearchBarIconFromString(NSString * string);

@interface SCSearchBar : UISearchBar<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UISearchBar *)searchBar;

@end
