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

@interface UISegmentedScrollView ()

@property(nonatomic, retain) UIView * controlView;

@end

@implementation UISegmentedScrollView

@synthesize controlView = _controlView;

@synthesize animated = _animated;
@synthesize selectedIndex = _selectedIndex;
@synthesize contentOffset = _contentOffset;

- (void) dealloc
{
	[_controlView release];
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializedUISegmentedScrollView
{
	[_controlView release];
	_controlView = nil;
	
	_animated = YES;
	_selectedIndex = 0;
	_contentOffset = CGPointZero;
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

- (void) setControlView:(UIView *)controlView
{
	NSAssert([self.subviews count] == 0, @"unexpected subview(s)");
	if (_controlView != controlView) {
		[super addSubview:controlView];
		[controlView retain];
		
		[_controlView removeFromSuperview];
		[_controlView release];
		
		_controlView = controlView;
	}
}

- (void) addSubview:(UIView *)view
{
	NSAssert([_controlView isKindOfClass:[UIView class]], @"cannot add subview before controlView init");
	NSAssert([view isKindOfClass:[UIScrollView class]], @"subview must be a UIScrollView");
	
	if ([view isKindOfClass:[UIScrollView class]]) {
		UIScrollView * scrollView = (UIScrollView *)view;
		scrollView.frame = self.bounds;
		CGFloat top = _controlView.frame.origin.y + _controlView.frame.size.height;
		scrollView.contentInset = UIEdgeInsetsMake(top, 0.0f, 0.0f, 0.0f);
		// set delegate for scrolling
		NSAssert(scrollView.delegate == nil, @"delegate's already been set");
		if (scrollView.delegate == nil) {
			scrollView.delegate = self;
		}
	}
	
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
	
	// left
	center = CGPointMake(- size.width * 0.5f, size.height * 0.5f);
	for (; index < selectedIndex; ++index) {
		child = [enumerator nextObject];
		NSAssert([child isKindOfClass:[UIScrollView class]], @"subview must be a UIScrollView");
		child.center = center;
	}
	
	// middle(selected)
	center.x += size.width;
	child = [enumerator nextObject];
	NSAssert([child isKindOfClass:[UIScrollView class]], @"subview must be a UIScrollView");
	if ([child isKindOfClass:[UIScrollView class]]) {
		//self.contentOffset = child.contentOffset;
		[self scrollViewDidScroll:child];
	}
	child.center = center;
	++index;
	
	// right
	center.x += size.width;
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

- (void) setContentOffset:(CGPoint)contentOffset
{
	NSAssert([_controlView isKindOfClass:[UIView class]], @"cannot set contentOffset before controlView init");
	CGRect frame = _controlView.frame;
	
	if (contentOffset.y > 0.0f) {
		frame.origin.y = -contentOffset.y;
	} else {
		frame.origin.y = 0.0f;
	}
	_controlView.frame = frame;
	
	_contentOffset = contentOffset;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
	UIEdgeInsets edges = scrollView.contentInset;
	CGPoint offset = scrollView.contentOffset;
	self.contentOffset = CGPointMake(edges.left + offset.x, edges.top + offset.y);
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
