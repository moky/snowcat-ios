//
//  SCScrollRefreshControl.m
//  SnowCat
//
//  Created by Moky on 15-1-8.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCLog.h"
#import "SCEventHandler.h"
#import "SCNib.h"
#import "SCGeometry.h"
#import "SCScrollRefreshControl.h"

//typedef NS_ENUM(NSUInteger, UIScrollRefreshControlDirection) {
//	UIScrollRefreshControlDirectionTop,
//	UIScrollRefreshControlDirectionBottom,
//	UIScrollRefreshControlDirectionLeft,
//	UIScrollRefreshControlDirectionRight,
//};
UIScrollRefreshControlDirection UIScrollRefreshControlDirectionFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Top")
			return UIScrollRefreshControlDirectionTop;
		SC_SWITCH_CASE(string, @"Bottom")
			return UIScrollRefreshControlDirectionBottom;
		SC_SWITCH_CASE(string, @"Left")
			return UIScrollRefreshControlDirectionLeft;
		SC_SWITCH_CASE(string, @"Right")
			return UIScrollRefreshControlDirectionRight;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

@interface UIScrollRefreshControl ()

@property(nonatomic, assign) UIScrollView * scrollView;

@property(nonatomic, retain) SCScrollRefreshControlStateMachine * stateMachine;

@end

@implementation UIScrollRefreshControl

@synthesize direction = _direction;
@synthesize dimension = _dimension;

@synthesize scrollView = _scrollView;

@synthesize stateMachine = _stateMachine;

- (void) dealloc
{
	self.scrollView = nil;
	
	if (_stateMachine) {
		[_stateMachine stop];
		_stateMachine.delegate = nil;
		self.stateMachine = nil;
	}
	
	[super dealloc];
}

- (void) _initializeUIScrollRefreshControl
{
	self.autoresizingMask = ~UIViewAutoresizingNone;
	
	_direction = UIScrollRefreshControlDirectionBottom;
	_dimension = 80.0f;
	
	self.scrollView = nil;
	
	SCScrollRefreshControlStateMachine * machine = [[SCScrollRefreshControlStateMachine alloc] init];
	machine.delegate = self;
	self.stateMachine = machine;
	[machine start];
	[machine release];
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeUIScrollRefreshControl];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeUIScrollRefreshControl];
	}
	return self;
}

- (void) layoutSubviews
{
	UIScrollView * scrollView = [self scrollView];
	if (!scrollView) {
		// not visible
		return;
	}
	
	UIEdgeInsets contentInset = scrollView.contentInset;
	CGSize contentSize = scrollView.contentSize;
	CGRect frame = scrollView.bounds;
	
	switch (_direction) {
		case UIScrollRefreshControlDirectionTop:
			frame.origin = CGPointMake(0, -frame.size.height);
			break;
			
		case UIScrollRefreshControlDirectionBottom:
			frame.origin = CGPointMake(0, MAX(contentSize.height, frame.size.height - contentInset.top - contentInset.bottom));
			break;
			
		case UIScrollRefreshControlDirectionLeft:
			frame.origin = CGPointMake(-frame.size.width, 0);
			break;
			
		case UIScrollRefreshControlDirectionRight:
			frame.origin = CGPointMake(MAX(contentSize.width, frame.size.width - contentInset.left - contentInset.right), 0);
			break;
			
		default:
			NSAssert(false, @"error");
			break;
	}
	
	[UIView beginAnimations:nil context:NULL];
	self.frame = frame;
	[super layoutSubviews];
	[UIView commitAnimations];
}

- (CGFloat) offset:(UIScrollView *)scrollView
{
	CGSize contentSize = scrollView.contentSize;
	CGRect bounds = scrollView.bounds;
	UIEdgeInsets edges = scrollView.contentInset;
	
	switch (_direction) {
		case UIScrollRefreshControlDirectionTop:
			return - bounds.origin.y - edges.top;
			break;
			
		case UIScrollRefreshControlDirectionBottom:
			if (bounds.size.height > contentSize.height) {
				return bounds.origin.y + edges.top; // content size is not large enough
			} else {
				return bounds.origin.y + bounds.size.height - contentSize.height;
			}
			break;
			
		case UIScrollRefreshControlDirectionLeft:
			return - bounds.origin.x - edges.left;
			break;
			
		case UIScrollRefreshControlDirectionRight:
			if (bounds.size.width > contentSize.width) {
				return bounds.origin.x + edges.left; // content size is not large enough
			} else {
				return bounds.origin.x + bounds.size.width - contentSize.width;
			}
			break;
			
		default:
			NSAssert(false, @"error");
			break;
	}
	
	return 0.0f;
}

- (UIScrollView *) scrollView
{
	if (!_scrollView) {
		_scrollView = (UIScrollView *)self.superview;
		NSAssert(!_scrollView || [_scrollView isKindOfClass:[UIScrollView class]], @"error");
	}
	return _scrollView;
}

#pragma mark - SCFSMDelegate

- (void) machine:(SCFSMMachine *)machine enterState:(SCFSMState *)state
{
	SCLog(@"state name: %@", state.name);
	SCScrollRefreshControlState * srcs = (SCScrollRefreshControlState *)state;
	NSAssert([srcs isKindOfClass:[SCScrollRefreshControlState class]], @"error state: %@", state);
	
	UIScrollView * scrollView = [self scrollView];
	if (!scrollView) {
		// not visible
		return;
	}
	
	if (srcs.state == UIScrollRefreshControlStateRefreshing) {
		UIEdgeInsets contentInset = scrollView.contentInset;
		switch (_direction) {
			case UIScrollRefreshControlDirectionTop:
				contentInset.top += self.dimension;
				break;
				
			case UIScrollRefreshControlDirectionBottom:
				contentInset.bottom += self.dimension;
				break;
				
			case UIScrollRefreshControlDirectionLeft:
				contentInset.left += self.dimension;
				break;
				
			case UIScrollRefreshControlDirectionRight:
				contentInset.right += self.dimension;
				break;
				
			default:
				NSAssert(false, @"error");
				break;
		}
		
		[UIView beginAnimations:nil context:NULL];
		scrollView.contentInset = contentInset;
		[UIView commitAnimations];
	}
}

- (void) machine:(SCFSMMachine *)machine exitState:(SCFSMState *)state
{
	SCLog(@"state name: %@", state.name);
	SCScrollRefreshControlState * srcs = (SCScrollRefreshControlState *)state;
	NSAssert([srcs isKindOfClass:[SCScrollRefreshControlState class]], @"error state: %@", state);
	
	UIScrollView * scrollView = [self scrollView];
	if (!scrollView) {
		// not visible
		return;
	}
	
	if (srcs.state == UIScrollRefreshControlStateRefreshing) {
		UIEdgeInsets contentInset = scrollView.contentInset;
		switch (_direction) {
			case UIScrollRefreshControlDirectionTop:
				contentInset.top -= self.dimension;
				break;
				
			case UIScrollRefreshControlDirectionBottom:
				contentInset.bottom -= self.dimension;
				break;
				
			case UIScrollRefreshControlDirectionLeft:
				contentInset.left -= self.dimension;
				break;
				
			case UIScrollRefreshControlDirectionRight:
				contentInset.right -= self.dimension;
				break;
				
			default:
				NSAssert(false, @"error");
				break;
		}
		
		[UIView beginAnimations:nil context:NULL];
		scrollView.contentInset = contentInset;
		[UIView commitAnimations];
	} else if (srcs.state == UIScrollRefreshControlStateDefault) {
		// make self in the front
		if (_direction == UIScrollRefreshControlDirectionBottom ||
			_direction == UIScrollRefreshControlDirectionRight) {
			[scrollView bringSubviewToFront:self];
		}
	}
}

#pragma mark Scroll

// called on start of dragging (may require some time and or distance to move)
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	_stateMachine.controlDimension = [self dimension];
	_stateMachine.controlOffset = [self offset:scrollView];
	_stateMachine.pulling = YES;
	[_stateMachine tick];
	
	[self setNeedsLayout]; // for moving to correct position in good time
}

// any offset changes
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
	_stateMachine.controlDimension = [self dimension];
	_stateMachine.controlOffset = [self offset:scrollView];
	[_stateMachine tick];
}

// called on finger up if the user dragged
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView
{
	_stateMachine.controlDimension = [self dimension];
	_stateMachine.controlOffset = [self offset:scrollView];
	_stateMachine.pulling = NO;
	[_stateMachine tick];
}

// called on data reloaded
- (void) reloadData:(UIScrollView *)scrollView
{
	_stateMachine.controlDimension = [self dimension];
	_stateMachine.controlOffset = [self offset:scrollView];
	_stateMachine.dataLoaded = YES;
	[_stateMachine tick];
}

@end

#pragma mark -

@implementation SCScrollRefreshControl

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib

- (void) dealloc
{
	[_nodeFile release];
	
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		_scTag = 0;
		self.nodeFile = nil;
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		_scTag = 0;
		self.nodeFile = nil;
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

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIScrollRefreshControl *)scrollRefreshControl
{
	if (![SCView setAttributes:dict to:scrollRefreshControl]) {
		return NO;
	}
	
	// direction
	NSString * direction = [dict objectForKey:@"direction"];
	if (direction) {
		scrollRefreshControl.direction = UIScrollRefreshControlDirectionFromString(direction);
	}
	
	// dimension
	id dimension = [dict objectForKey:@"dimension"];
	if (dimension) {
		scrollRefreshControl.dimension = [dimension floatValue];
	}
	
	return YES;
}

- (void) machine:(SCFSMMachine *)machine enterState:(SCFSMState *)state
{
	[super machine:machine enterState:state];
	
	NSString * event = nil;
	
	SCScrollRefreshControlState * srcs = (SCScrollRefreshControlState *)state;
	NSAssert([srcs isKindOfClass:[SCScrollRefreshControlState class]], @"error state: %@", state);
	
	switch (srcs.state) {
		case UIScrollRefreshControlStateDefault:
			event = @"onHide";
			break;
			
		case UIScrollRefreshControlStateVisible:
			event = @"onShow";
			break;
			
		case UIScrollRefreshControlStateWillRefresh:
			event = @"onHint";
			break;
			
		case UIScrollRefreshControlStateRefreshing:
			event = @"onRefresh";
			break;
			
		default:
			event = @"onError";
			break;
	}
	
	SCLog(@"%@: %@", event, self);
	SCDoEvent(event, self);
}

@end
