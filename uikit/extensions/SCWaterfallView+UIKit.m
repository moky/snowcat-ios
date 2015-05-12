//
//  UIWaterfallView.m
//  SnowCat
//
//  Created by Moky on 15-5-8.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCWaterfallView+Layout.h"
#import "SCWaterfallView+UIKit.h"

//typedef NS_ENUM(NSUInteger, UIWaterfallViewDirection) {
//	UIWaterfallViewDirectionTopLeft,     // place each subview as TOP as possible, if reach the TOP, as LEFT as possible
//	UIWaterfallViewDirectionTopRight,    // TOP first, and then RIGHT
//	
//	UIWaterfallViewDirectionBottomLeft,  // BOTTOM first, and then LEFT
//	UIWaterfallViewDirectionBottomRight, // BOTTOM first, and then RIGHT
//	
//	UIWaterfallViewDirectionLeftTop,     // LEFT first, and then TOP
//	UIWaterfallViewDirectionLeftBottom,  // LEFT first, and then BOTTOM
//	
//	UIWaterfallViewDirectionRightTop,    // RIGHT first, and then TOP
//	UIWaterfallViewDirectionRightBottom, // RIGHT first, and then BOTTOM
//};
UIWaterfallViewDirection UIWaterfallViewDirectionFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"TopLeft")
			return UIWaterfallViewDirectionTopLeft;
		SC_SWITCH_CASE(string, @"TopRight")
			return UIWaterfallViewDirectionTopRight;
		SC_SWITCH_CASE(string, @"BottomLeft")
			return UIWaterfallViewDirectionBottomLeft;
		SC_SWITCH_CASE(string, @"BottomRight")
			return UIWaterfallViewDirectionBottomRight;
		SC_SWITCH_CASE(string, @"LeftTop")
			return UIWaterfallViewDirectionLeftTop;
		SC_SWITCH_CASE(string, @"LeftBottom")
			return UIWaterfallViewDirectionLeftBottom;
		SC_SWITCH_CASE(string, @"RightTop")
			return UIWaterfallViewDirectionRightTop;
		SC_SWITCH_CASE(string, @"RightBottom")
			return UIWaterfallViewDirectionRightBottom;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

@implementation UIWaterfallView

@synthesize direction = _direction;

@synthesize spaceHorizontal = _spaceHorizontal;
@synthesize spaceVertical = _spaceVertical;

@synthesize delegate = _delegate;

- (void) _initializeUIWaterfallView
{
	_direction = UIWaterfallViewDirectionTopLeft;
	
	_spaceHorizontal = 0.0f;
	_spaceVertical = 0.0f;
	
	_delegate = nil;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeUIWaterfallView];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeUIWaterfallView];
	}
	return self;
}

- (CGFloat) space
{
	NSAssert(_spaceHorizontal == _spaceVertical, @"space can be accessed only when horizontal equals to vertical");
	return _spaceHorizontal;
}

- (void) setSpace:(CGFloat)space
{
	self.spaceHorizontal = space;
	self.spaceVertical = space;
}

- (void) setSpaceHorizontal:(CGFloat)spaceHorizontal
{
	if (_spaceHorizontal != spaceHorizontal) {
		_spaceHorizontal = spaceHorizontal;
		[self setNeedsLayout];
	}
}

- (void) setSpaceVertical:(CGFloat)spaceVertical
{
	if (_spaceVertical != spaceVertical) {
		_spaceVertical = spaceVertical;
		[self setNeedsLayout];
	}
}

- (void) setDirection:(UIWaterfallViewDirection)direction
{
	if (_direction != direction) {
		_direction = direction;
		[self setNeedsLayout];
	}
}

- (void) layoutSubviews
{
	[super layoutSubviews];
	[[self class] layoutSubviewsInView:self
							   towards:_direction
					   spaceHorizontal:_spaceHorizontal
						 spaceVertical:_spaceVertical];
}

- (void) didAddSubview:(UIView *)subview
{
	[super didAddSubview:subview];
	[self setNeedsLayout];
}

- (void) willRemoveSubview:(UIView *)subview
{
	[super willRemoveSubview:subview];
	[self setNeedsLayout];
}

@end
