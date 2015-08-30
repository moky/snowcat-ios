//
//  SCScrollRefreshControl.m
//  SnowCat
//
//  Created by Moky on 15-1-8.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCEventHandler.h"
#import "SCNib.h"
#import "SCGeometry.h"
#import "SCFSMProtocol.h"
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
	
	UIScrollRefreshControlState * srcs = (UIScrollRefreshControlState *)state;
	NSAssert([srcs isKindOfClass:[UIScrollRefreshControlState class]], @"error state: %@", state);
	
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
			
		case UIScrollRefreshControlStateTerminated:
			event = @"onEnd";
			break;
			
		default:
			event = @"onError";
			break;
	}
	
	SCLog(@"%@: %@", event, self);
	SCDoEvent(event, self);
}

@end
