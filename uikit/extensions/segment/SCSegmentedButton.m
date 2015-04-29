//
//  SCSegmentedButton.m
//  SnowCat
//
//  Created by Moky on 15-4-13.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCNib.h"
#import "SCButton.h"
#import "SCSegmentedButton.h"

//typedef NS_ENUM(NSUInteger, UISegmentedButtonAutoLayoutDirection) {
//	UISegmentedButtonAutoLayoutNone,
//	UISegmentedButtonAutoLayoutDirectionVertical,
//	UISegmentedButtonAutoLayoutDirectionHorizontal,
//};
UISegmentedButtonAutoLayoutDirection UISegmentedButtonAutoLayoutDirectionFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Horizontal")
			return UISegmentedButtonAutoLayoutDirectionHorizontal;
		SC_SWITCH_CASE(string, @"Vertical")
			return UISegmentedButtonAutoLayoutDirectionVertical;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

@implementation UISegmentedButton

@synthesize selectedSegmentIndex = _selectedSegmentIndex;
@synthesize direction = _direction;

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		_selectedSegmentIndex = UISegmentedButtonNoSegment;
		_direction = UISegmentedButtonAutoLayoutNone;
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		_selectedSegmentIndex = UISegmentedButtonNoSegment;
		_direction = UISegmentedButtonAutoLayoutNone;
	}
	return self;
}

- (NSUInteger) numberOfSegments
{
	return [self.subviews count];
}

- (void) setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex
{
	NSAssert(selectedSegmentIndex >= -1 && selectedSegmentIndex < self.numberOfSegments, @"error segment index: %d", (int)selectedSegmentIndex);
	
	if (_selectedSegmentIndex != selectedSegmentIndex) {
		UIButton * button;
		
		// unselect the old item
		if (_selectedSegmentIndex != UISegmentedButtonNoSegment) {
			button = [self buttonForSegmentAtIndex:_selectedSegmentIndex];
			button.selected = NO;
		}
		
		// select the new item
		if (selectedSegmentIndex != UISegmentedButtonNoSegment) {
			button = [self buttonForSegmentAtIndex:selectedSegmentIndex];
			button.selected = YES;
		}
		
		// change value
		_selectedSegmentIndex = selectedSegmentIndex;
		
		if (selectedSegmentIndex != UISegmentedButtonNoSegment) {
			// send out message 'onChange:'
			[self _performControlEvent:UIControlEventValueChanged];
		}
	}
}

- (void) insertSubview:(UIView *)view atIndex:(NSInteger)index
{
	NSUInteger count = [self.subviews count];
	if (index < count) {
		view.tag = index;
		[super insertSubview:view atIndex:index];
		// increase the tag of followed button(s)
		++index;
		for (; index < count; ++index) {
			view = [self buttonForSegmentAtIndex:index];
			view.tag = index; // tag++
		}
	} else if (index == count) {
		view.tag = index;
		[self addSubview:view];
	} else {
		NSAssert(false, @"error index: %d >= %u", (int)index, (unsigned int)count);
	}
}

- (void) _layoutButtons
{
	if (_direction == UISegmentedButtonAutoLayoutNone) {
		return;
	}
	NSUInteger count = [self.subviews count];
	NSAssert(count > 0, @"buttons not found");
	
	CGRect bounds = CGRectMake(0.0f, 0.0f, self.bounds.size.width, self.bounds.size.height);
	if (_direction == UISegmentedButtonAutoLayoutDirectionHorizontal) {
		bounds.size.width /= count;
	} else {
		bounds.size.height /= count;
	}
	CGPoint center = CGPointMake(bounds.size.width * 0.5f, bounds.size.height * 0.5f);
	
	NSEnumerator * enumerator = [self.subviews objectEnumerator];
	UIButton * btn;
	while (btn = [enumerator nextObject]) {
		btn.bounds = bounds;
		btn.center = center;
		if (_direction == UISegmentedButtonAutoLayoutDirectionHorizontal) {
			center.x += bounds.size.width;
		} else {
			center.y += bounds.size.height;
		}
	}
}

- (void) layoutSubviews
{
	[super layoutSubviews];
	[self _layoutButtons];
}

- (void) setDirection:(UISegmentedButtonAutoLayoutDirection)direction
{
	//if (_direction != direction) {
		_direction = direction;
		if (_direction != UISegmentedButtonAutoLayoutNone) {
			[self setNeedsLayout];
		}
	//}
}

- (void) didAddSubview:(UIView *)subview
{
	[super didAddSubview:subview];
	
	NSAssert([subview isKindOfClass:[UIButton class]], @"must be a button: %@", subview);
	UIButton * button = (UIButton *)subview;
	[button addTarget:self action:@selector(_onClickSegment:) forControlEvents:UIControlEventTouchUpInside];
	
	if (_direction != UISegmentedButtonAutoLayoutNone) {
		[self setNeedsLayout];
	}
}

- (void) willRemoveSubview:(UIView *)subview
{
	NSAssert([subview isKindOfClass:[UIButton class]], @"must be a button: %@", subview);
	UIButton * button = (UIButton *)subview;
	[button removeTarget:self action:@selector(_onClickSegment:) forControlEvents:UIControlEventTouchUpInside];
	
	[super willRemoveSubview:subview];
}

- (void) _onClickSegment:(UIButton *)button
{
	NSInteger index = button.tag;
	NSAssert(index >= 0 && index < self.numberOfSegments, @"error segment: %d", (int)index);
	self.selectedSegmentIndex = index;
}

- (void) _performControlEvent:(UIControlEvents)controlEvent
{
	NSSet * targets;
	NSObject * target;
	NSArray * actions;
	NSEnumerator * targetEnumerator;
	NSEnumerator * actionEnumerator;
	NSString * action;
	SEL selector;
	
	// get all targets
	targets = [self allTargets];
	targetEnumerator = [targets objectEnumerator];
	while (target = [targetEnumerator nextObject]) {
		// get all actions for target
		actions = [self actionsForTarget:target forControlEvent:controlEvent];
		actionEnumerator = [actions objectEnumerator];
		while (action = [actionEnumerator nextObject]) {
			// perform selector
			selector = NSSelectorFromString(action);
			[target performSelector:selector withObject:self];
		}
	}
}

- (void) insertSegmentWithButton:(UIButton *)button atIndex:(NSUInteger)segment animated:(BOOL)animated
{
	if (animated) {
		[UIView beginAnimations:nil context:NULL];
	}
	
	[self insertSubview:button atIndex:segment];
	
	if (animated) {
		[UIView commitAnimations];
	}
}

- (void) removeSegmentAtIndex:(NSUInteger)segment animated:(BOOL)animated
{
	if (animated) {
		[UIView beginAnimations:nil context:NULL];
	}
	
	UIView * view = [self buttonForSegmentAtIndex:segment];
	[view removeFromSuperview];
	
	if (animated) {
		[UIView commitAnimations];
	}
}

- (void) removeAllSegments
{
	NSUInteger count = [self numberOfSegments];
	NSInteger index;
	for (index = count - 1; index >= 0; --index) {
		[self removeSegmentAtIndex:index animated:NO];
	}
}

- (void) setButton:(UIButton *)button forSegmentAtIndex:(NSUInteger)segment
{
	UIButton * old = [self buttonForSegmentAtIndex:segment];
	if (button != old) {
		[old removeFromSuperview];
		[self insertSubview:button atIndex:segment];
	}
}

- (UIButton *) buttonForSegmentAtIndex:(NSUInteger)segment
{
	NSAssert(segment < self.numberOfSegments, @"segment error: %u >= %u", (unsigned int)segment, (unsigned int)self.numberOfSegments);
	UIView * view = [self.subviews objectAtIndex:segment];
	NSAssert([view isKindOfClass:[UIButton class]], @"error button: %@", view);
	return (UIButton *)view;
}

- (void) setEnabled:(BOOL)enabled forSegmentAtIndex:(NSUInteger)segment
{
	UIButton * button = [self buttonForSegmentAtIndex:segment];
	button.enabled = enabled;
}

- (BOOL) isEnabledForSegmentAtIndex:(NSUInteger)segment
{
	UIButton * button = [self buttonForSegmentAtIndex:segment];
	return button.enabled;
}

@end

#pragma mark -

@implementation SCSegmentedButton

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib

- (void) dealloc
{
	self.nodeFile = nil;
	
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCSegmentedScrollView
{
	_scTag = 0;
	self.nodeFile = nil;
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

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UISegmentedButton *)segmentedButton
{
	if (![SCControl setAttributes:dict to:segmentedButton]) {
		return NO;
	}
	
	// items
	NSArray * items = [dict objectForKey:@"items"];
	if (items) {
		NSUInteger count = [items count];
		NSDictionary * d;
		SCButton * btn;
		for (NSUInteger i = 0; i < count; ++i) {
			d = [items objectAtIndex:i];
			NSAssert([d isKindOfClass:[NSDictionary class]], @"segmented button's item must be a dictionary: %@", d);
			SC_UIKIT_DIG_CREATION_INFO(d); // support ObjectFromFile
			
			btn = [SCButton create:d autorelease:NO];
			[segmentedButton insertSegmentWithButton:btn atIndex:i animated:NO];
			SC_UIKIT_SET_ATTRIBUTES(btn, SCButton, d);
			[btn release];
		}
	}
	
	// selectedSegmentIndex
	id selectedSegmentIndex = [dict objectForKey:@"selectedSegmentIndex"];
	if (selectedSegmentIndex) {
		segmentedButton.selectedSegmentIndex = [selectedSegmentIndex integerValue];
	}
	
	// direction
	NSString * direction = [dict objectForKey:@"direction"];
	if (direction) {
		segmentedButton.direction = UISegmentedButtonAutoLayoutDirectionFromString(direction);
	}
	
	return YES;
}

@end
