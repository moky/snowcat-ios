//
//  SCSegmentedScrollView.m
//  SnowCat
//
//  Created by Moky on 15-4-9.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
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
				UIView * item;
				SC_FOR_EACH(item, view.subviews) {
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
		NSDictionary * item;
		SCScrollView * scrollView;
		SC_FOR_EACH(item, scrollViews) {
			NSAssert([item isKindOfClass:[NSDictionary class]], @"item must be a dictionary");
			scrollView = [SCScrollView create:item autorelease:NO];
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
