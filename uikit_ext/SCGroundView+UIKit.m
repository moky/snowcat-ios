//
//  UIGroundView.m
//  SnowCat
//
//  Created by Moky on 15-5-5.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "SCGroundView+UIKit.h"

@implementation UIGroundView

@synthesize ground = _ground;

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		_ground = CGRectZero;
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		_ground = CGRectZero;
	}
	return self;
}

- (void) setCenter:(CGPoint)center
{
	do {
		CGRect rect = _ground;
		if (CGRectEqualToRect(rect, CGRectZero)) {
			rect = self.superview.bounds;
			if (CGRectEqualToRect(rect, CGRectZero)) {
				// no gound found
				break;
			}
		}
		
		CGSize size = self.frame.size;
		
		CGFloat midX = size.width * 0.5f;
		CGFloat midY = size.height * 0.5f;
		
		CGFloat minX = rect.origin.x + midX;
		CGFloat maxX = rect.origin.x + rect.size.width - midX;
		
		CGFloat minY = rect.origin.y + midY;
		CGFloat maxY = rect.origin.y + rect.size.height - midY;
		
		if (center.x < minX) {
			center.x = minX;
		} else if (center.y > maxX) {
			center.x = maxX;
		}
		
		if (center.y < minY) {
			center.y = minY;
		} else if (center.y > maxY) {
			center.y = maxY;
		}
	} while (false);
	
	[super setCenter:center];
}

@end
