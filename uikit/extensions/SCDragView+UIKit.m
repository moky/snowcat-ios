//
//  UIDragView.m
//  SnowCat
//
//  Created by Moky on 15-5-5.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "SCDragView+UIKit.h"

@implementation UIDragView

- (void) onDragStart:(UIPanGestureRecognizer *)recognizer
{
	// do nothing
}

- (void) onDrag:(UIPanGestureRecognizer *)recognizer
{
	CGPoint delta = [recognizer translationInView:self]; // get translation
	[recognizer setTranslation:CGPointZero inView:self]; // reset translation
	
	//	delta = [self convertPoint:delta toView:self.window];
	//	delta = [self.superview convertPoint:delta fromView:self.window];
	
	CGPoint center = self.center;
	self.center = CGPointMake(center.x + delta.x, center.y + delta.y);
}

- (void) onDragEnd:(UIPanGestureRecognizer *)recognizer
{
	// do nothing
}

@end
