//
//  SCView.m
//  SnowCat
//
//  Created by Moky on 14-3-17.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCClient.h"
#import "SCNib.h"
#import "SCString.h"
#import "SCImage.h"
#import "SCLayer.h"
#import "SCColor.h"
#import "SCViewController.h"
#import "SCView+Geometry.h"
#import "SCView+Gesture.h"
#import "SCView.h"

@implementation SCView

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

// default initializer
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

+ (BOOL) _setHierarchyAttributes:(NSDictionary *)dict to:(UIView *)view
{
	// subviews
	NSArray * subviews = [dict objectForKey:@"subviews"];
	SCView * child;
	NSDictionary * item;
	SC_FOR_EACH(item, subviews) {
		NSAssert([item isKindOfClass:[NSDictionary class]], @"subviews's item must be a dictionary: %@", item);
		SC_UIKIT_DIG_CREATION_INFO(item); // support ObjectFromFile
		
		child = [SCView create:item autorelease:NO];
		NSAssert([child isKindOfClass:[UIView class]], @"subviews item's definition error: %@", item);
		[view addSubview:child];
		SC_UIKIT_SET_ATTRIBUTES(child, SCView, item);
		[child release];
	}
	
	// scale size to fit subviews
	NSString * size = [dict objectForKey:@"size"];
	if (size && [size rangeOfString:@"ToFit"].location != NSNotFound) {
		CGRect frame = view.frame;
		frame.size = [self sizeThatFits:CGSizeZero to:view];
		view.frame = frame;
	}
	
	return YES;
}

+ (BOOL) _setRenderingAttributes:(NSDictionary *)dict to:(UIView *)view
{
	SC_SET_ATTRIBUTES_AS_BOOL(view, dict, clipsToBounds);
	SC_SET_ATTRIBUTES_AS_UICOLOR(view, dict, backgroundColor);
	SC_SET_ATTRIBUTES_AS_FLOAT(view, dict, alpha);
	
	SC_SET_ATTRIBUTES_AS_BOOL(view, dict, opaque);
	SC_SET_ATTRIBUTES_AS_BOOL(view, dict, clearsContextBeforeDrawing);
	SC_SET_ATTRIBUTES_AS_BOOL(view, dict, hidden);
	
	// contentMode
	NSString * contentMode = [dict objectForKey:@"contentMode"];
	if (contentMode) {
		view.contentMode = UIViewContentModeFromString(contentMode);
	}
	
	return YES;
}

+ (BOOL) _setIOS7Attributes:(NSDictionary *)dict to:(UIView *)view
{
#ifdef __IPHONE_7_0
	
	CGFloat systemVersion = SCSystemVersion();
	if (systemVersion < 7.0f) {
		return NO;
	}
	
	SC_SET_ATTRIBUTES_AS_UICOLOR(view, dict, tintColor);
	
//	// tintAdjustmentMode
//	NSString * tintAdjustmentMode = [dict objectForKey:@"tintAdjustmentMode"];
//	if (tintAdjustmentMode) {
//		view.tintAdjustmentMode = UIViewTintAdjustmentModeFromString(tintAdjustmentMode);
//	}
	
#endif
	return YES;
}

+ (BOOL) _setIOS8Attributes:(NSDictionary *)dict to:(UIView *)view
{
#ifdef __IPHONE_8_0
	
	CGFloat systemVersion = SCSystemVersion();
	if (systemVersion < 8.0f) {
		return NO;
	}
	
	SC_SET_ATTRIBUTES_AS_UIEDGEINSETS(view, dict, layoutMargins);
	
	SC_SET_ATTRIBUTES_AS_BOOL(view, dict, preservesSuperviewLayoutMargins);
	
	// maskView
	NSDictionary * maskView = [dict objectForKey:@"maskView"];
	if (maskView) {
		SCView * v = [SCView create:maskView autorelease:NO];
		view.maskView = v;
		SC_UIKIT_SET_ATTRIBUTES(v, SCView, maskView);
		[v release];
	}
	
#endif
	return YES;
}

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIView *)view
{
	if (![SCResponder setAttributes:dict to:view]) {
		SCLog(@"failed to set attributes: %@", dict);
		return NO;
	}
	
	// layer
	NSDictionary * layer = [dict objectForKey:@"layer"];
	if (layer) {
		NSAssert([layer isKindOfClass:[NSDictionary class]], @"error");
		SC_UIKIT_SET_ATTRIBUTES(view.layer, SCLayer, layer);
	}
	
	SC_SET_ATTRIBUTES_AS_BOOL(view, dict, userInteractionEnabled);
	
	SC_SET_ATTRIBUTES_AS_INTEGER(view, dict, tag);
	
	// UIViewGeometry
	[self setGeometryAttributes:dict to:view];
	
	// UIViewHierarchy
	[self _setHierarchyAttributes:dict to:view];
	
	// UIViewRendering
	[self _setRenderingAttributes:dict to:view];
	
	// UIGestureRecognizer
	[self setGestureAttributes:dict to:view];
	
#ifdef __IPHONE_7_0
	// (iOS 7.0)
	[self _setIOS7Attributes:dict to:view];
#endif
	
#ifdef __IPHONE_8_0
	// (iOS 8.0)
	[self _setIOS8Attributes:dict to:view];
#endif
	
	return YES;
}

@end
