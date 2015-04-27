//
//  SCGroundView.h
//  SnowCat
//
//  Created by Moky on 15-1-27.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "SCView.h"

//
//  Description:
//      An imprison view that restricted in a rect (ground)
//
@interface UIGroundView : UIView

@property(nonatomic, readwrite) CGRect ground; // default is CGRectZero, then use superview.bounds as ground

@end

#pragma mark -

@interface SCGroundView : UIGroundView<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIGroundView *)groundView;

@end
