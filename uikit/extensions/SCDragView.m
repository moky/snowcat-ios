//
//  SCDragView.m
//  SnowCat
//
//  Created by Moky on 14-11-14.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCNib.h"
#import "SCGeometry.h"
#import "SCDragView.h"

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

@implementation SCDragView

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

+ (void) _checkGestures:(NSArray *)gestures with:(UIDragView *)dragView
{
	if (gestures) {
		NSEnumerator * enumerator = [gestures objectEnumerator];
		NSString * name = nil;
		while (name = [enumerator nextObject]) {
			if ([name isEqualToString:@"Pan"]) {
				return; // already add
			}
		}
	}
	[SCView addGestureRecognizerWithName:@"Pan" to:dragView];
}

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIDragView *)dragView
{
	if (![SCGroundView setAttributes:dict to:dragView]) {
		return NO;
	}
	
	// make sure the 'Pan' gesture has been added
	NSArray * gestures = [dict objectForKey:@"gestures"];
	[self _checkGestures:gestures with:dragView];
	
	return YES;
}

@end
