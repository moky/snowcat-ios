//
//  SCSegmentedScrollView.m
//  SnowCat
//
//  Created by Moky on 15-4-9.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCEventHandler.h"
#import "SCNib.h"
#import "SCSegmentedControl.h"
#import "SCSegmentedButton.h"
#import "SCScrollView.h"
#import "SCSegmentedScrollView.h"

//typedef NS_ENUM(NSUInteger, UISegmentedScrollViewControlPosition) {
//	UISegmentedScrollViewControlPositionTop,
//	UISegmentedScrollViewControlPositionBottom,
//	UISegmentedScrollViewControlPositionLeft,
//	UISegmentedScrollViewControlPositionRight,
//};
UISegmentedScrollViewControlPosition UISegmentedScrollViewControlPositionFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Top")
			return UISegmentedScrollViewControlPositionTop;
		SC_SWITCH_CASE(string, @"Bottom")
			return UISegmentedScrollViewControlPositionBottom;
		SC_SWITCH_CASE(string, @"Left")
			return UISegmentedScrollViewControlPositionLeft;
		SC_SWITCH_CASE(string, @"Right")
			return UISegmentedScrollViewControlPositionRight;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

@interface UISegmentedScrollView ()

@property(nonatomic, assign) UIView * controlView;

@property(nonatomic, assign) UIScrollView * currentScrollView;

@end

@implementation UISegmentedScrollView

@synthesize controlView = _controlView;
@synthesize controlPosition = _controlPosition;

@synthesize animated = _animated;
@synthesize selectedIndex = _selectedIndex;

@synthesize currentScrollView = _currentScrollView;

- (void) dealloc
{
	self.controlView = nil;
	self.currentScrollView = nil;
	
	[super dealloc];
}

- (void) _initializedUISegmentedScrollView
{
	self.controlView = nil;
	
	_controlPosition = UISegmentedScrollViewControlPositionTop;
	
	_animated = YES;
	_selectedIndex = 0;
	
	self.currentScrollView = nil;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializedUISegmentedScrollView];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializedUISegmentedScrollView];
	}
	return self;
}

- (void) setControlPosition:(UISegmentedScrollViewControlPosition)controlPosition
{
	if (controlPosition != _controlPosition) {
		_controlPosition = controlPosition;
		
		// 1. set position of control view
		if (_controlView) {
			[self _positionControlView];
		}
		
		// 2. set content edge inset for all scroll views
		NSEnumerator * enumerator = [self.subviews objectEnumerator];
		UIScrollView * scrollView;
		while (scrollView = [enumerator nextObject]) {
			if ([scrollView isKindOfClass:[UIScrollView class]]) {
				[self _insetScrollView:scrollView];
			}
		}
	}
}

- (void) _insetScrollView:(UIScrollView *)scrollView
{
	UIEdgeInsets contentInset = scrollView.contentInset;
	switch (_controlPosition) {
		case UISegmentedScrollViewControlPositionTop:
			contentInset.top = _controlView.frame.origin.y + _controlView.frame.size.height;
			break;
			
		case UISegmentedScrollViewControlPositionBottom:
			contentInset.bottom = _controlView.frame.size.height;
			break;
			
		case UISegmentedScrollViewControlPositionLeft:
			contentInset.left = _controlView.frame.origin.x + _controlView.frame.size.width;
			break;
			
		case UISegmentedScrollViewControlPositionRight:
			contentInset.right = _controlView.frame.size.width;
			break;
			
		default:
			break;
	}
	scrollView.contentInset = contentInset;
}

- (void) _positionControlView
{
	NSAssert(_controlView, @"control view not set");
	
	UIScrollView * scrollView = self.currentScrollView;
	UIEdgeInsets edges = scrollView.contentInset;
	CGPoint offset = scrollView.contentOffset;
	CGSize size = scrollView.contentSize;
	CGSize winSize = self.bounds.size;
	
	CGFloat delta;
	
	CGPoint center = CGPointMake(winSize.width * 0.5f, winSize.height * 0.5f);
	switch (_controlPosition) {
		case UISegmentedScrollViewControlPositionTop:
			center.y = _controlView.bounds.size.height * 0.5f;
			// calculate delta
			delta = edges.top + offset.y;
			if (delta > 0.0f) {
				center.y -= delta;
			}
			break;
			
		case UISegmentedScrollViewControlPositionBottom:
			center.y = winSize.height - _controlView.bounds.size.height * 0.5f;
			// calculate delta
			delta = size.height - (edges.top + offset.y) + edges.bottom - winSize.height;
			if (delta > 0.0f) {
				center.y += delta;
			}
			break;
			
		case UISegmentedScrollViewControlPositionLeft:
			center.x = _controlView.bounds.size.width * 0.5f;
			// calculate delta
			delta = edges.left + offset.x;
			if (delta > 0.0f) {
				center.x -= delta;
			}
			break;
			
		case UISegmentedScrollViewControlPositionRight:
			center.x = winSize.width - _controlView.bounds.size.width * 0.5f;
			// calculate content size
			delta = size.width - (edges.left + offset.x) + edges.right - winSize.width;
			if (delta > 0.0f) {
				center.x += delta;
			}
			break;
			
		default:
			break;
	}
	_controlView.center = center;
}

- (void) setControlView:(UIView *)controlView
{
	NSAssert([self.subviews count] == 0, @"unexpected subview(s)");
	if (_controlView != controlView) {
		// add new one
		[super addSubview:controlView];
		
		// remove old one
		[_controlView removeFromSuperview];
		
		_controlView = controlView;
		// position
		[self _positionControlView];
	}
}

- (UIScrollView *) currentScrollView
{
	if (!_currentScrollView) {
		NSEnumerator * enumerator = [self.subviews objectEnumerator];
		UIScrollView * scrollView;
		NSUInteger index = 0;
		while (scrollView = [enumerator nextObject]) {
			if ([scrollView isKindOfClass:[UIScrollView class]]) {
				if (index == _selectedIndex) {
					_currentScrollView = scrollView;
					break;
				}
				++index;
			}
		}
	}
	return _currentScrollView;
}

- (void) didAddSubview:(UIView *)subview
{
	[super didAddSubview:subview];
	
	if ([subview isKindOfClass:[UIScrollView class]]) {
		UIScrollView * scrollView = (UIScrollView *)subview;
		
		// resize and content inset
		scrollView.frame = self.bounds;
		[self _insetScrollView:scrollView];
		
		// set delegate for scrolling
		NSAssert(scrollView.delegate == nil, @"delegate's already been set");
		if (scrollView.delegate == nil) {
			scrollView.delegate = self;
		}
	}
}

- (void) willRemoveSubview:(UIView *)subview
{
	if ([subview isKindOfClass:[UIScrollView class]]) {
		UIScrollView * scrollView = (UIScrollView *)subview;
		
		// set delegate for scrolling
		NSAssert(scrollView.delegate == self, @"delegate error");
		if (scrollView.delegate == self) {
			scrollView.delegate = nil;
		}
	}
	
	[super willRemoveSubview:subview];
}

- (void) addSubview:(UIView *)view
{
	NSAssert([_controlView isKindOfClass:[UIView class]], @"cannot add subview before controlView init");
	NSAssert([view isKindOfClass:[UIScrollView class]], @"subview must be a UIScrollView");
	
	[self insertSubview:view belowSubview:_controlView];
}

- (void) setSelectedIndex:(NSUInteger)selectedIndex
{
	NSArray * subviews = self.subviews;
	NSAssert([subviews count] > 2, @"subviews error: %@", subviews);
	NSUInteger count = [subviews count] - 1;
	selectedIndex = selectedIndex % count;
	
	if (_animated) {
		[UIView beginAnimations:nil context:NULL];
	}
	
	NSEnumerator * enumerator = [subviews objectEnumerator];
	CGSize size = self.bounds.size;
	NSUInteger index = 0;
	UIScrollView * child;
	CGPoint center;
	
	// left/top
	if (_controlPosition == UISegmentedScrollViewControlPositionTop ||
		_controlPosition == UISegmentedScrollViewControlPositionBottom) {
		center = CGPointMake(-size.width * 0.5f, size.height * 0.5f);
	} else {
		center = CGPointMake(size.width * 0.5f, -size.height * 0.5f);
	}
	for (; index < selectedIndex; ++index) {
		child = [enumerator nextObject];
		NSAssert([child isKindOfClass:[UIScrollView class]], @"subview must be a UIScrollView");
		child.center = center;
	}
	
	// center/middle (selected)
	if (_controlPosition == UISegmentedScrollViewControlPositionTop ||
		_controlPosition == UISegmentedScrollViewControlPositionBottom) {
		center.x += size.width;
	} else {
		center.y += size.height;
	}
	child = [enumerator nextObject];
	NSAssert([child isKindOfClass:[UIScrollView class]], @"subview must be a UIScrollView");
	if ([child isKindOfClass:[UIScrollView class]]) {
		[self scrollViewDidScroll:child];
	}
	child.center = center;
	++index;
	
	// right/bottom
	if (_controlPosition == UISegmentedScrollViewControlPositionTop ||
		_controlPosition == UISegmentedScrollViewControlPositionBottom) {
		center.x += size.width;
	} else {
		center.y += size.height;
	}
	for (; index < count; ++index) {
		child = [enumerator nextObject];
		NSAssert([child isKindOfClass:[UIScrollView class]], @"subview must be a UIScrollView");
		child.center = center;
	}
	
	if (_animated) {
		[UIView commitAnimations];
	}
	
	_selectedIndex = selectedIndex;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
	NSAssert(scrollView.superview == self, @"must be subview");
	self.currentScrollView = scrollView;
	[self _positionControlView];
}

@end

#pragma mark -

@interface SCSegmentedScrollView ()

@property(nonatomic, retain) UISegmentedControl * segmentedControl;
@property(nonatomic, retain) UISegmentedButton * segmentedButton;

@end

@implementation SCSegmentedScrollView

@synthesize segmentedControl = _segmentedControl;
@synthesize segmentedButton = _segmentedButton;

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib

- (void) dealloc
{
	self.segmentedControl = nil;
	self.segmentedButton = nil;
	
	self.nodeFile = nil;
	
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) setSegmentedControl:(UISegmentedControl *)segmentedControl
{
	if (_segmentedControl != segmentedControl) {
		[segmentedControl addTarget:self action:@selector(onChange:) forControlEvents:UIControlEventValueChanged];
		[segmentedControl retain];
		
		[_segmentedControl removeTarget:self action:@selector(onChange:) forControlEvents:UIControlEventValueChanged];
		[_segmentedControl release];
		
		_segmentedControl = segmentedControl;
	}
}

- (void) setSegmentedButton:(UISegmentedButton *)segmentedButton
{
	if (_segmentedButton != segmentedButton) {
		[segmentedButton addTarget:self action:@selector(onChange:) forControlEvents:UIControlEventValueChanged];
		[segmentedButton retain];
		
		[_segmentedButton removeTarget:self action:@selector(onChange:) forControlEvents:UIControlEventValueChanged];
		[_segmentedButton release];
		
		_segmentedButton = segmentedButton;
	}
}

- (void) _initializeSCSegmentedScrollView
{
	_scTag = 0;
	self.nodeFile = nil;
	
	self.segmentedControl = nil;
	self.segmentedButton = nil;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCSegmentedScrollView];
	}
	return self;
}

// default initializer
- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeSCSegmentedScrollView];
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	self = [self initWithFrame:CGRectZero];
	if (self) {
		[self buildHandlers:dict];
	}
	return self;
}

// buildHandlers:
SC_UIKIT_IMELEMENT_BUILD_HANDLERS_FUNCTION()

// awakeFromNib
SC_UIKIT_IMPLEMENT_AWAKE_FUNCTION()

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UISegmentedScrollView *)segmentedScrollView
{
	if (![SCView setAttributes:dict to:segmentedScrollView]) {
		return NO;
	}
	
	// controlPosition
	NSString * controlPosition = [dict objectForKey:@"controlPosition"];
	if (controlPosition) {
		segmentedScrollView.controlPosition = UISegmentedScrollViewControlPositionFromString(controlPosition);
	}
	
	// controlView
	NSDictionary * controlView = [dict objectForKey:@"controlView"];
	if (controlView) {
		SCView * view = [SCView create:controlView autorelease:NO];
		// initialize default properties
		view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		segmentedScrollView.controlView = view;
		SC_UIKIT_SET_ATTRIBUTES(view, SCView, controlView);
		
		// search segmented control/button
		if ([segmentedScrollView isKindOfClass:[SCSegmentedScrollView class]]) {
			SCSegmentedScrollView * ssv = (SCSegmentedScrollView *)segmentedScrollView;
			if ([view isKindOfClass:[UISegmentedControl class]]) {
				ssv.segmentedControl = (UISegmentedControl *)view;
			} else if ([view isKindOfClass:[UISegmentedButton class]]) {
				ssv.segmentedButton = (UISegmentedButton *)view;
			} else {
				NSEnumerator * enumerator = [view.subviews objectEnumerator];
				UIView * item;
				while (item = [enumerator nextObject]) {
					if ([item isKindOfClass:[UISegmentedControl class]]) {
						ssv.segmentedControl = (UISegmentedControl *)item;
						break;
					} else if ([item isKindOfClass:[UISegmentedButton class]]) {
						ssv.segmentedButton = (UISegmentedButton *)item;
						break;
					}
				}
			}
		}
		
		[view release];
	}
	
	// scrollViews
	NSArray * scrollViews = [dict objectForKey:@"scrollViews"];
	if (scrollViews) {
		NSAssert([scrollViews isKindOfClass:[NSArray class]], @"scrollViews must be an array");
		NSEnumerator * enumerator = [scrollViews objectEnumerator];
		NSDictionary * item;
		SCScrollView * scrollView;
		while (item = [enumerator nextObject]) {
			NSAssert([item isKindOfClass:[NSDictionary class]], @"item must be a dictionary");
			scrollView = [SCScrollView create:item autorelease:NO];
			// initialize default properties
			scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
			[segmentedScrollView addSubview:scrollView];
			SC_UIKIT_SET_ATTRIBUTES(scrollView, SCScrollView, item);
			[scrollView release];
		}
	}
	
	// animated
	id animated = [dict objectForKey:@"animated"];
	if (animated) {
		segmentedScrollView.animated = [animated boolValue];
	}
	
	// selectedIndex
	id selectedIndex = [dict objectForKey:@"selectedIndex"];
	if (selectedIndex) {
		segmentedScrollView.selectedIndex = [selectedIndex unsignedIntegerValue];
		// activate segmented control
		if ([segmentedScrollView isKindOfClass:[SCSegmentedScrollView class]]) {
			SCSegmentedScrollView * ssv = (SCSegmentedScrollView *)segmentedScrollView;
			ssv.segmentedControl.selectedSegmentIndex = segmentedScrollView.selectedIndex;
			ssv.segmentedButton.selectedSegmentIndex = segmentedScrollView.selectedIndex;
		}
	}
	
	// contentOffset
	
	return YES;
}

- (void) onChange:(id)sender
{
	SCLog(@"onChange: %@", sender);
	SCDoEvent(@"onChange", sender);
	
	if ([sender isKindOfClass:[UISegmentedControl class]]) {
		self.selectedIndex = [(UISegmentedControl *)sender selectedSegmentIndex];
	} else if ([sender isKindOfClass:[UISegmentedButton class]]) {
		self.selectedIndex = [(UISegmentedButton *)sender selectedSegmentIndex];
	}
	
	NSString * event = [[NSString alloc] initWithFormat:@"onSelect:%d", (int)self.selectedIndex];
	SCDoEvent(event, sender);
	[event release];
}

@end
