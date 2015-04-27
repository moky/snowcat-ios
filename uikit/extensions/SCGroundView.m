//
//  SCGroundView.m
//  SnowCat
//
//  Created by Moky on 15-1-27.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "SCNib.h"
#import "SCGeometry.h"
#import "SCGroundView.h"

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

@implementation SCGroundView

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib

- (void) dealloc
{
	self.nodeFile = nil;
	
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCGroundView
{
	_scTag = 0;
	self.nodeFile = nil;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCGroundView];
	}
	return self;
}

// default initializer
- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeSCGroundView];
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

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIGroundView *)groundView
{
	if (![SCView setAttributes:dict to:groundView]) {
		return NO;
	}
	
	// ground
	NSString * ground = [dict objectForKey:@"ground"];
	if (ground) {
		groundView.ground = CGRectFromStringWithNode(ground, groundView);
	}
	
	return YES;
}

@end
