//
//  UIGridTableView.m
//  SnowCat
//
//  Created by Moky on 15-5-5.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "SCGridTableView+UIKit.h"

@implementation UIGridTableView

@synthesize columnWidth = _columnWidth;

- (void) _initializeUIGridTableView
{
	// default attributes
	self.allowsSelection = NO;
	self.allowsSelectionDuringEditing = NO;
	self.allowsMultipleSelection = NO;
	self.allowsMultipleSelectionDuringEditing = NO;
	self.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	_columnWidth = self.bounds.size.width;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeUIGridTableView];
	}
	return self;
}

// must specify style at creation. -initWithFrame: calls this with UITableViewStylePlain
- (instancetype) initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
	self = [super initWithFrame:frame style:style];
	if (self) {
		[self _initializeUIGridTableView];
	}
	return self;
}

- (void) setFrame:(CGRect)frame
{
	CGFloat width = self.frame.size.width;
	[super setFrame:frame];
	
	if (frame.size.width > 0 && _columnWidth > 0 &&
		floor(width / _columnWidth) != floor(frame.size.width / _columnWidth)) {
		[self reloadData];
	}
}

@end
