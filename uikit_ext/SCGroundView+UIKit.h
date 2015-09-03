//
//  UIGroundView.h
//  SnowCat
//
//  Created by Moky on 15-5-5.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

//
//  Description:
//      An imprison view that restricted in a rect (ground)
//
@interface UIGroundView : UIView

@property(nonatomic, readwrite) CGRect ground; // default is CGRectZero, then use superview.bounds as ground

@end
