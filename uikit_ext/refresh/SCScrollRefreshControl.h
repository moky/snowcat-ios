//
//  SCScrollRefreshControl.h
//  SnowCat
//
//  Created by Moky on 15-1-8.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "SlanissueToolkit.h"

#import "SCView.h"

UIKIT_EXTERN UIScrollRefreshControlDirection UIScrollRefreshControlDirectionFromString(NSString * string);

@interface SCScrollRefreshControl : UIScrollRefreshControl<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIScrollRefreshControl *)scrollRefreshControl;

@end

#pragma mark - interfaces for refresh control

#define SCScrollRefreshControlWillBeginDragging(scrollView)                    \
    {                                                                          \
        NSEnumerator * enumerator = [(scrollView).subviews objectEnumerator];  \
        UIScrollRefreshControl * src = nil;                                    \
        while (src = [enumerator nextObject]) {                                \
            if ([src isKindOfClass:[UIScrollRefreshControl class]]) {          \
                [src scrollViewWillBeginDragging:(scrollView)];                \
            }                                                                  \
        }                                                                      \
    }                                                                          \
                             /* EOF 'SCScrollRefreshControlWillBeginDragging' */

#define SCScrollRefreshControlDidScroll(scrollView)                            \
    {                                                                          \
        NSEnumerator * enumerator = [(scrollView).subviews objectEnumerator];  \
        UIScrollRefreshControl * src = nil;                                    \
        while (src = [enumerator nextObject]) {                                \
            if ([src isKindOfClass:[UIScrollRefreshControl class]]) {          \
                [src scrollViewDidScroll:(scrollView)];                        \
            }                                                                  \
        }                                                                      \
    }                                                                          \
                                     /* EOF 'SCScrollRefreshControlDidScroll' */

#define SCScrollRefreshControlDidEndDragging(scrollView)                       \
    {                                                                          \
        NSEnumerator * enumerator = [(scrollView).subviews objectEnumerator];  \
        UIScrollRefreshControl * src = nil;                                    \
        while (src = [enumerator nextObject]) {                                \
            if ([src isKindOfClass:[UIScrollRefreshControl class]]) {          \
                [src scrollViewDidEndDragging:(scrollView)];                   \
            }                                                                  \
        }                                                                      \
    }                                                                          \
                                /* EOF 'SCScrollRefreshControlDidEndDragging' */

#define SCScrollRefreshControlReloadData(tableView)                            \
    {                                                                          \
        NSEnumerator * enumerator = [(tableView).subviews objectEnumerator];   \
        UIScrollRefreshControl * src = nil;                                    \
        while (src = [enumerator nextObject]) {                                \
            if ([src isKindOfClass:[UIScrollRefreshControl class]]) {          \
                [src reloadData:(tableView)];                                  \
            }                                                                  \
        }                                                                      \
    }                                                                          \
                                    /* EOF 'SCScrollRefreshControlReloadData' */
