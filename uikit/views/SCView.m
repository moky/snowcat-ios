//
//  SCView.m
//  SnowCat
//
//  Created by Moky on 14-3-17.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCLog.h"
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
	NSEnumerator * enumerator = [subviews objectEnumerator];
	NSDictionary * item;
	while (item = [enumerator nextObject]) {
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
	// clipsToBounds
	id clipsToBounds = [dict objectForKey:@"clipsToBounds"];
	if (clipsToBounds) {
		view.clipsToBounds = [clipsToBounds boolValue];
	}
	
	// background color
	id backgroundColor = [dict objectForKey:@"backgroundColor"];
	if (backgroundColor) {
		SCColor * color = [SCColor create:backgroundColor autorelease:NO];
		view.backgroundColor = color;
		[color release];
	}
	
	// alpha
	id alpha = [dict objectForKey:@"alpha"];
	if (alpha) {
		view.alpha = [alpha floatValue];
	}
	
	// opaque
	id opaque = [dict objectForKey:@"opaque"];
	if (opaque) {
		view.opaque = [opaque boolValue];
	}
	
	// clearsContextBeforeDrawing
	id clearsContextBeforeDrawing = [dict objectForKey:@"clearsContextBeforeDrawing"];
	if (clearsContextBeforeDrawing) {
		view.clearsContextBeforeDrawing = [clearsContextBeforeDrawing boolValue];
	}
	
	// hidden
	id hidden = [dict objectForKey:@"hidden"];
	if (hidden) {
		view.hidden = [hidden boolValue];
	}
	
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
	
	// tintColor
	NSDictionary * tintColor = [dict objectForKey:@"tintColor"];
	if (tintColor) {
		SCColor * color = [SCColor create:tintColor autorelease:NO];
		view.tintColor = color;
		[color release];
	}
	
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
	
	// layoutMargins
	NSString * layoutMargins = [dict objectForKey:@"layoutMargins"];
	if (layoutMargins) {
		view.layoutMargins = UIEdgeInsetsFromString(layoutMargins);
	}
	
	// preservesSuperviewLayoutMargins
	id preservesSuperviewLayoutMargins = [dict objectForKey:@"preservesSuperviewLayoutMargins"];
	if (preservesSuperviewLayoutMargins) {
		view.preservesSuperviewLayoutMargins = [preservesSuperviewLayoutMargins boolValue];
	}
	
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
	
	// userInteractionEnabled
	id userInteractionEnabled = [dict objectForKey:@"userInteractionEnabled"];
	if (userInteractionEnabled) {
		view.userInteractionEnabled = [userInteractionEnabled boolValue];
	}
	
	// tag
	id tag = [dict objectForKey:@"tag"];
	if (tag) {
		view.tag = [tag integerValue];
	}
	
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

@implementation UIView (Snapshot)

- (UIImage *) snapshot:(NSString *)filename
{
	UIImage * image = SCSnapshot(self);
	if (filename) {
		[image writeToFile:filename atomically:YES];
	}
	return image;
}

@end
