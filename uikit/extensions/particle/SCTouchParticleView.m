//
//  SCTouchParticleView.m
//  SnowCat
//
//  Created by Moky on 15-1-1.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "SCTouchParticleView.h"

@implementation SCTouchParticleView

@synthesize birthRate = _birthRate;

- (void) setBirthRate:(CGFloat)birthRate
{
	self.emitter.birthRate = birthRate;
	_birthRate = birthRate;
}

- (BOOL) setAttributes:(NSDictionary *)dict
{
	if (![super setAttributes:dict]) {
		return NO;
	}
	
	_birthRate = self.emitter.birthRate;
	self.emitter.birthRate = 0; // stop emitting
	
	return YES;
}

- (UIView *) hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	UIView * view = [super hitTest:point withEvent:event];
	if (view) {
		// subview or self, while 'userInteractionEnabled' is YES
		return view;
	} else if (CGRectContainsPoint(self.frame, point)) {
		// ignore 'userInteractionEnabled', 'hidden', 'alpha', ...
		return self;
	} else {
		// not hit
		return nil;
	}
}

- (void) _touches:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch * touch = [touches anyObject];
	self.emitterPosition = [touch locationInView:self];
}

- (void) _startEmitting
{
	self.emitter.birthRate = _birthRate;
}

- (void) _stopEmitting
{
	self.emitter.birthRate = 0;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	[self _touches:touches withEvent:event];
	[self _startEmitting];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesMoved:touches withEvent:event];
	[self _touches:touches withEvent:event];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	[self _stopEmitting];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesCancelled:touches withEvent:event];
	[self _stopEmitting];
}

@end
