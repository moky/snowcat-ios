//
//  UIGridTableView.h
//  SnowCat
//
//  Created by Moky on 15-5-5.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIGridTableView : UITableView

@property(nonatomic, readwrite) CGFloat columnWidth; // will return the cell's width if unset

@end
