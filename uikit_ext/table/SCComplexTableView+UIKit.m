//
//  UIComplexTableView.m
//  SnowCat
//
//  Created by Moky on 15-5-5.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "SCComplexTableView+UIKit.h"

@implementation UIComplexTableView

- (void) setFrame:(CGRect)frame
{
	[super setFrame:frame];
	
	if (frame.size.width > 0) {
		[self reloadData];
	}
}

@end
