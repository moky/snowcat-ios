//
//  SCViewController+Patch.m
//  SnowCat
//
//  Created by Moky on 14-6-5.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCClient.h"
#import "SCViewController.h"

@implementation UIViewController (PatchAutorotate)

SC_UIKIT_IMPLEMENT_AUTOROTATE_FUNCTIONS_WITH_CHILD_AND_PROPERTY(SC_UIKIT_DEFAULT_SUPPORTED_INTERFACE_ORIENTATIONS)

@end

@implementation UINavigationController (PatchAutorotate)

SC_UIKIT_IMPLEMENT_AUTOROTATE_FUNCTIONS_WITH_CHILD(self.topViewController)

@end

@implementation UITabBarController (PatchAutorotate)

SC_UIKIT_IMPLEMENT_AUTOROTATE_FUNCTIONS_WITH_CHILD(self.selectedViewController)

@end

@implementation UICollectionViewController (PatchAutorotate)

SC_UIKIT_IMPLEMENT_AUTOROTATE_FUNCTIONS_WITH_PROPERTY(SC_UIKIT_DEFAULT_SUPPORTED_INTERFACE_ORIENTATIONS)

@end

@implementation UIPageViewController (PatchAutorotate)

SC_UIKIT_IMPLEMENT_AUTOROTATE_FUNCTIONS_WITH_PROPERTY(SC_UIKIT_DEFAULT_SUPPORTED_INTERFACE_ORIENTATIONS)

@end

@implementation UISplitViewController (PatchAutorotate)

SC_UIKIT_IMPLEMENT_AUTOROTATE_FUNCTIONS_WITH_PROPERTY(SC_UIKIT_DEFAULT_SUPPORTED_INTERFACE_ORIENTATIONS)

@end

@implementation UITableViewController (PatchAutorotate)

SC_UIKIT_IMPLEMENT_AUTOROTATE_FUNCTIONS_WITH_PROPERTY(SC_UIKIT_DEFAULT_SUPPORTED_INTERFACE_ORIENTATIONS)

@end
