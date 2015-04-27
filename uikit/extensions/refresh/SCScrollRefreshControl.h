//
//  SCScrollRefreshControl.h
//  SnowCat
//
//  Created by Moky on 15-1-8.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "SCView.h"
#import "SCScrollRefreshControlState.h"

typedef NS_ENUM(NSUInteger, UIScrollRefreshControlDirection) {
    UIScrollRefreshControlDirectionTop,
    UIScrollRefreshControlDirectionBottom,
	UIScrollRefreshControlDirectionLeft,
	UIScrollRefreshControlDirectionRight,
};

UIKIT_EXTERN UIScrollRefreshControlDirection UIScrollRefreshControlDirectionFromString(NSString * string);

@interface UIScrollRefreshControl : UIView<SCFSMDelegate>

@property(nonatomic, readwrite) UIScrollRefreshControlDirection direction; // direction to pull out from
@property(nonatomic, readwrite) CGFloat dimension; // default is 80, the dimension for showing contents(subviews)

// called on start of dragging (may require some time and or distance to move)
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView;
// any offset changes
- (void) scrollViewDidScroll:(UIScrollView *)scrollView;
// called on finger up if the user dragged
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView;

// called on data reloaded
- (void) reloadData:(UIScrollView *)scrollView;

@end

#pragma mark -

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
