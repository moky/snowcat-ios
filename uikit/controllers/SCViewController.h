//
//  SCViewController.h
//  SnowCat
//
//  Created by Moky on 14-3-17.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCResponder.h"
#import "SCNavigationItem.h"
#import "SCToolbar.h"

UIKIT_EXTERN UIModalTransitionStyle UIModalTransitionStyleFromString(NSString * string);
UIKIT_EXTERN UIModalPresentationStyle UIModalPresentationStyleFromString(NSString * string);

#ifdef __IPHONE_7_0

UIKIT_EXTERN UIRectEdge UIRectEdgeFromString(NSString * string);

#endif

@interface SCViewController : UIViewController<SCUIKit, SCNavigationItemDelegate, SCToolbarItemDelegate>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIViewController *)viewController;

@end

// setAttributes
#define SC_UIKIT_VIEW_CONTROLLER_IMPLEMENT_SET_ATTRIBUTES_WITH_ORIENTATIONS(_supportedInterfaceOrientations, key)   \
    - (BOOL) setAttributes:(NSDictionary *)dict                                                                     \
    {                                                                                                               \
        if (![[self class] setAttributes:dict to:self]) {                                                           \
            return NO;                                                                                              \
        }                                                                                                           \
        NSString * supportedInterfaceOrientations = [dict objectForKey:key];                                        \
        if (supportedInterfaceOrientations) {                                                                       \
            _supportedInterfaceOrientations = UIInterfaceOrientationMaskFromString(supportedInterfaceOrientations); \
        }                                                                                                           \
        return YES;                                                                                                 \
    }                                                                                                               \
                                      /* EOF 'SC_UIKIT_VIEW_CONTROLLER_IMPLEMENT_SET_ATTRIBUTES_WITH_ORIENTATIONS' */

// viewWillLayoutSubviews
#define SC_UIKIT_VIEW_CONTROLLER_IMPLEMENT_VIEW_WILL_LAYOUT_SUBVIEWS()                           \
    - (void) viewWillLayoutSubviews                                                              \
    {                                                                                            \
        [[UIDevice currentDevice] rotateForSupportedInterfaceOrientationsOfViewController:self]; \
        [super viewWillLayoutSubviews];                                                          \
    }                                                                                            \
                          /* EOF 'SC_UIKIT_VIEW_CONTROLLER_IMPLEMENT_VIEW_WILL_LAYOUT_SUBVIEWS' */

// viewDidLoad
#define SC_UIKIT_VIEW_CONTROLLER_IMPLEMENT_VIEW_DID_LOAD()                                       \
    - (void) viewDidLoad                                                                         \
    {                                                                                            \
        [super viewDidLoad];                                                                     \
        [SCNib viewDidLoad:self.view withNibName:self.nibName bundle:self.nibBundle];            \
    }                                                                                            \
                                      /* EOF 'SC_UIKIT_VIEW_CONTROLLER_IMPLEMENT_VIEW_DID_LOAD' */

// view loading functions
#define SC_UIKIT_VIEW_CONTROLLER_IMPLEMENT_LOAD_VIEW_FUNCTIONS()                                 \
            SC_UIKIT_VIEW_CONTROLLER_IMPLEMENT_VIEW_DID_LOAD()                                   \
            SC_UIKIT_VIEW_CONTROLLER_IMPLEMENT_VIEW_WILL_LAYOUT_SUBVIEWS()                       \
                                     /* EOF 'SC_UIKIT_VIEW_CONTROLLER_IMPLEMENT_VIEW_FUNCTIONS' */

// Autorotate
#define SC_UIKIT_DEFAULT_SUPPORTED_INTERFACE_ORIENTATIONS                    UIInterfaceOrientationMaskAll

#define SC_UIKIT_IMPLEMENT_AUTOROTATE_FUNCTIONS_WITH_CHILD(topViewController)                            \
    - (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation       \
    {                                                                                                    \
        return [topViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];        \
    }                                                                                                    \
    - (BOOL) shouldAutorotate                                                                            \
    {                                                                                                    \
        return [topViewController shouldAutorotate];                                                     \
    }                                                                                                    \
    - (NSUInteger) supportedInterfaceOrientations                                                        \
    {                                                                                                    \
        return [topViewController supportedInterfaceOrientations];                                       \
    }                                                                                                    \
    - (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation                              \
    {                                                                                                    \
        return [topViewController preferredInterfaceOrientationForPresentation];                         \
    }                                                                                                    \
                                            /* EOF 'SC_UIKIT_IMPLEMENT_AUTOROTATE_FUNCTIONS_WITH_CHILD' */

#define SC_UIKIT_IMPLEMENT_AUTOROTATE_FUNCTIONS_WITH_PROPERTY(_supportedInterfaceOrientations)           \
    - (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation       \
    {                                                                                                    \
        return _supportedInterfaceOrientations & (1 << toInterfaceOrientation);                          \
    }                                                                                                    \
    - (BOOL) shouldAutorotate                                                                            \
    {                                                                                                    \
        NSUInteger count = 0;                                                                            \
        if (_supportedInterfaceOrientations & UIInterfaceOrientationMaskPortrait) ++count;               \
        if (_supportedInterfaceOrientations & UIInterfaceOrientationMaskLandscapeLeft) ++count;          \
        if (_supportedInterfaceOrientations & UIInterfaceOrientationMaskLandscapeRight) ++count;         \
        if (_supportedInterfaceOrientations & UIInterfaceOrientationMaskPortraitUpsideDown) ++count;     \
        return count > 1;                                                                                \
    }                                                                                                    \
    - (NSUInteger) supportedInterfaceOrientations                                                        \
    {                                                                                                    \
        return _supportedInterfaceOrientations;                                                          \
    }                                                                                                    \
    - (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation                              \
    {                                                                                                    \
        if (_supportedInterfaceOrientations & UIInterfaceOrientationMaskPortrait) {                      \
            return UIInterfaceOrientationPortrait;                                                       \
        } else if (_supportedInterfaceOrientations & UIInterfaceOrientationMaskLandscapeRight) {         \
            return UIInterfaceOrientationLandscapeRight;                                                 \
        } else if (_supportedInterfaceOrientations & UIInterfaceOrientationMaskLandscapeLeft) {          \
            return UIInterfaceOrientationLandscapeLeft;                                                  \
        } else if (_supportedInterfaceOrientations & UIInterfaceOrientationMaskPortraitUpsideDown) {     \
            return UIInterfaceOrientationPortraitUpsideDown;                                             \
        }                                                                                                \
        return UIInterfaceOrientationPortrait;                                                           \
    }                                                                                                    \
                                         /* EOF 'SC_UIKIT_IMPLEMENT_AUTOROTATE_FUNCTIONS_WITH_PROPERTY' */

#define SC_UIKIT_IMPLEMENT_AUTOROTATE_FUNCTIONS_WITH_CHILD_AND_PROPERTY(_supportedInterfaceOrientations) \
    - (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation       \
    {                                                                                                    \
        UIViewController * child = [self.childViewControllers lastObject];                               \
        if (child) {                                                                                     \
            return [child shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];                \
        }                                                                                                \
        return _supportedInterfaceOrientations & (1 << toInterfaceOrientation);                          \
    }                                                                                                    \
    - (BOOL) shouldAutorotate                                                                            \
    {                                                                                                    \
        UIViewController * child = [self.childViewControllers lastObject];                               \
        if (child) {                                                                                     \
            return [child shouldAutorotate];                                                             \
        }                                                                                                \
        NSUInteger count = 0;                                                                            \
        if (_supportedInterfaceOrientations & UIInterfaceOrientationMaskPortrait) ++count;               \
        if (_supportedInterfaceOrientations & UIInterfaceOrientationMaskLandscapeLeft) ++count;          \
        if (_supportedInterfaceOrientations & UIInterfaceOrientationMaskLandscapeRight) ++count;         \
        if (_supportedInterfaceOrientations & UIInterfaceOrientationMaskPortraitUpsideDown) ++count;     \
        return count > 1;                                                                                \
    }                                                                                                    \
    - (NSUInteger) supportedInterfaceOrientations                                                        \
    {                                                                                                    \
        UIViewController * child = [self.childViewControllers lastObject];                               \
        if (child) {                                                                                     \
            return [child supportedInterfaceOrientations];                                               \
        }                                                                                                \
        return _supportedInterfaceOrientations;                                                          \
    }                                                                                                    \
    - (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation                              \
    {                                                                                                    \
        UIViewController * child = [self.childViewControllers lastObject];                               \
        if (child) {                                                                                     \
            return [child preferredInterfaceOrientationForPresentation];                                 \
        }                                                                                                \
        if (_supportedInterfaceOrientations & UIInterfaceOrientationMaskPortrait) {                      \
            return UIInterfaceOrientationPortrait;                                                       \
        } else if (_supportedInterfaceOrientations & UIInterfaceOrientationMaskLandscapeLeft) {          \
            return UIInterfaceOrientationLandscapeLeft;                                                  \
        } else if (_supportedInterfaceOrientations & UIInterfaceOrientationMaskLandscapeRight) {         \
            return UIInterfaceOrientationLandscapeRight;                                                 \
        } else if (_supportedInterfaceOrientations & UIInterfaceOrientationMaskPortraitUpsideDown) {     \
            return UIInterfaceOrientationPortraitUpsideDown;                                             \
        }                                                                                                \
        return UIInterfaceOrientationPortrait;                                                           \
    }                                                                                                    \
                               /* EOF 'SC_UIKIT_IMPLEMENT_AUTOROTATE_FUNCTIONS_WITH_CHILD_AND_PROPERTY' */
