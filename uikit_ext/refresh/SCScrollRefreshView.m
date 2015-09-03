//
//  SCScrollRefreshView.m
//  SnowCat
//
//  Created by Moky on 15-1-11.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCNib.h"
#import "SCActivityIndicatorView.h"
#import "SCLabel.h"
#import "SCScrollRefreshView.h"

@implementation SCScrollRefreshView

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

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIScrollRefreshView *)scrollRefreshView
{
	if (![SCScrollRefreshControl setAttributes:dict to:scrollRefreshView]) {
		return NO;
	}
	
	// visibleText
	NSString * visibleText = [dict objectForKey:@"visibleText"];
	if (!visibleText) {
		visibleText = [dict objectForKey:@"text"];
	}
	if (visibleText) {
		scrollRefreshView.visibleText = SCLocalizedString(visibleText, nil);
	}
	
	// willRefreshText
	NSString * willRefreshText = [dict objectForKey:@"willRefreshText"];
	if (willRefreshText) {
		scrollRefreshView.willRefreshText = SCLocalizedString(willRefreshText, nil);
	}
	
	// refreshingText
	NSString * refreshingText = [dict objectForKey:@"refreshingText"];
	if (refreshingText) {
		scrollRefreshView.refreshingText = SCLocalizedString(refreshingText, nil);
	}
	
	// updatedText
	NSString * updatedText = [dict objectForKey:@"updatedText"];
	if (updatedText) {
		scrollRefreshView.updatedText = SCLocalizedString(updatedText, nil);
	}
	
	// terminatedText
	NSString * terminatedText = [dict objectForKey:@"terminatedText"];
	if (terminatedText) {
		scrollRefreshView.terminatedText = SCLocalizedString(terminatedText, nil);
	}
	
	// updatedTime
	
	// loading
	
	// trayView
	NSDictionary * trayView = [dict objectForKey:@"trayView"];
	if (trayView) {
		SCView * tray = [SCView create:trayView autorelease:NO];
		[scrollRefreshView addSubview:tray];
		SC_UIKIT_SET_ATTRIBUTES(tray, SCView, trayView);
		scrollRefreshView.trayView = tray;
		[tray release];
	}
	
	// loadingIndicator
	NSDictionary * loadingIndicator = [dict objectForKey:@"loadingIndicator"];
	if (loadingIndicator) {
		SCActivityIndicatorView * aiv = [SCActivityIndicatorView create:loadingIndicator autorelease:NO];
		[scrollRefreshView.trayView addSubview:aiv];
		SC_UIKIT_SET_ATTRIBUTES(aiv, SCActivityIndicatorView, loadingIndicator);
		scrollRefreshView.loadingIndicator = aiv;
		[aiv release];
	}
	
	// textLabel
	NSDictionary * textLabel = [dict objectForKey:@"textLabel"];
	if (textLabel) {
		SCLabel * label = [SCLabel create:textLabel autorelease:NO];
		[scrollRefreshView.trayView addSubview:label];
		SC_UIKIT_SET_ATTRIBUTES(label, SCLabel, textLabel);
		scrollRefreshView.textLabel = label;
		[label release];
	}
	
	// timeLabel
	NSDictionary * timeLabel = [dict objectForKey:@"timeLabel"];
	if (timeLabel) {
		SCLabel * label = [SCLabel create:timeLabel autorelease:NO];
		[scrollRefreshView.trayView addSubview:label];
		SC_UIKIT_SET_ATTRIBUTES(label, SCLabel, timeLabel);
		scrollRefreshView.timeLabel = label;
		[label release];
	}
	
	return YES;
}

@end
