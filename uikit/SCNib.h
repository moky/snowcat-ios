//
//  SCNib.h
//  SnowCat
//
//  Created by Moky on 14-4-25.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCUIKit.h"

@interface SCNib : UINib

+ (NSString *) nibNameFromDictionary:(NSDictionary *)dict;

+ (NSBundle *) bundleFromDictionary:(NSDictionary *)dict;
+ (NSBundle *) bundleFromDictionary:(NSDictionary *)dict autorelease:(BOOL)autorelease;

@end

@interface SCNib (Awaking)

// call by 'viewDidLoad' of SCViewController, which was initialized via 'initWithNibName:bundle:'
+ (void) viewDidLoad:(UIView *)view withNibName:(NSString *)nibName bundle:(NSBundle *)bundle;

// call when the view is awaked from nib,
// the nodeFile's value must be prefixed with '${...}', such as '${app}', '${docs}', '${caches}' or '${tmp}'
+ (void) awakeFromNib:(id<SCUIKit>)view withNodeFile:(NSString *)nodeFile;

@end
