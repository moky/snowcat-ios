//
//  SCWebView.m
//  SnowCat
//
//  Created by Moky on 14-3-24.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCLog.h"
#import "SCNib.h"
#import "SCDataDetectors.h"
#import "SCURL.h"
#import "SCURLRequest.h"
#import "SCEventHandler.h"
#import "SCResponder.h"
#import "SCView.h"
#import "SCWebViewDelegate.h"
#import "SCWebView.h"

//typedef NS_ENUM(NSInteger, UIWebViewNavigationType) {
//    UIWebViewNavigationTypeLinkClicked,
//    UIWebViewNavigationTypeFormSubmitted,
//    UIWebViewNavigationTypeBackForward,
//    UIWebViewNavigationTypeReload,
//    UIWebViewNavigationTypeFormResubmitted,
//    UIWebViewNavigationTypeOther
//};
UIWebViewNavigationType UIWebViewNavigationTypeFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"LinkClicked")
			return UIWebViewNavigationTypeLinkClicked;
		SC_SWITCH_CASE(string, @"FormSubmitted")
			return UIWebViewNavigationTypeFormSubmitted;
		SC_SWITCH_CASE(string, @"BackForward")
			return UIWebViewNavigationTypeBackForward;
		SC_SWITCH_CASE(string, @"Reload")
			return UIWebViewNavigationTypeReload;
		SC_SWITCH_CASE(string, @"FormResubmitted")
			return UIWebViewNavigationTypeFormResubmitted;
		SC_SWITCH_CASE(string, @"Other")
			return UIWebViewNavigationTypeOther;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

@interface SCWebView ()

@property(nonatomic, retain) id<SCWebViewDelegate> webViewDelegate;

@end

@implementation SCWebView

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib
@synthesize webViewDelegate = _webViewDelegate;

- (void) dealloc
{
	[_webViewDelegate release];
	[_nodeFile release];
	
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCWebView
{
	_scTag = 0;
	self.nodeFile = nil;
	
	self.webViewDelegate = nil;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCWebView];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeSCWebView];
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
- (void) buildHandlers:(NSDictionary *)dict
{
	[SCResponder onCreate:self withDictionary:dict];
	
	NSDictionary * delegate = [dict objectForKey:@"delegate"];
	if (delegate) {
		self.webViewDelegate = [SCWebViewDelegate create:delegate];
		// self.delegate only assign but won't retain the action delegate,
		// so don't release it now
		self.delegate = _webViewDelegate;
	}
}

// awakeFromNib
SC_UIKIT_IMPLEMENT_AWAKE_FUNCTION()

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIWebView *)webView
{
	if (![SCView setAttributes:dict to:webView]) {
		SCLog(@"failed to set attributes: %@", dict);
		return NO;
	}
	
	// loadHTMLString:baseURL:
	NSString * html = [dict objectForKey:@"html"];
	if (html) {
		NSString * baseURL = [dict objectForKey:@"baseURL"];
		NSURL * url = baseURL ? [[SCURL alloc] initWithString:baseURL isDirectory:NO] : nil;
		[webView loadHTMLString:html baseURL:url];
		[url release];
	}
	
	// loadRequest:
	NSString * urlString = [dict objectForKey:@"URL"];
	if (urlString) {
		NSURL * url = [[SCURL alloc] initWithString:urlString isDirectory:NO];
		NSURLRequest * request = [[SCURLRequest alloc] initWithURL:url];
		[webView loadRequest:request];
		[request release];
		[url release];
	}
	
	// scalesPageToFit
	id scalesPageToFit = [dict objectForKey:@"scalesPageToFit"];
	if (scalesPageToFit) {
		webView.scalesPageToFit = [scalesPageToFit boolValue];
	}
	
	// detectsPhoneNumbers (deprecated)
	
	// dataDetectorTypes
	NSString * dataDetectorTypes = [dict objectForKey:@"dataDetectorTypes"];
	if (dataDetectorTypes) {
		webView.dataDetectorTypes = UIDataDetectorTypesFromString(dataDetectorTypes);
	}
	
	// allowsInlineMediaPlayback
	id allowsInlineMediaPlayback = [dict objectForKey:@"allowsInlineMediaPlayback"];
	if (allowsInlineMediaPlayback) {
		webView.allowsInlineMediaPlayback = [allowsInlineMediaPlayback boolValue];
	}
	
	// mediaPlaybackRequiresUserAction
	id mediaPlaybackRequiresUserAction = [dict objectForKey:@"mediaPlaybackRequiresUserAction"];
	if (mediaPlaybackRequiresUserAction) {
		webView.mediaPlaybackRequiresUserAction = [mediaPlaybackRequiresUserAction boolValue];
	}
	
	// mediaPlaybackAllowsAirPlay
	id mediaPlaybackAllowsAirPlay = [dict objectForKey:@"mediaPlaybackAllowsAirPlay"];
	if (mediaPlaybackAllowsAirPlay) {
		webView.mediaPlaybackAllowsAirPlay = [mediaPlaybackAllowsAirPlay boolValue];
	}
	
	// suppressesIncrementalRendering
	id suppressesIncrementalRendering = [dict objectForKey:@"suppressesIncrementalRendering"];
	if (suppressesIncrementalRendering) {
		webView.suppressesIncrementalRendering = [suppressesIncrementalRendering boolValue];
	}
	
	// keyboardDisplayRequiresUserAction
	id keyboardDisplayRequiresUserAction = [dict objectForKey:@"keyboardDisplayRequiresUserAction"];
	if (keyboardDisplayRequiresUserAction) {
		webView.keyboardDisplayRequiresUserAction = [keyboardDisplayRequiresUserAction boolValue];
	}
	
	return YES;
}

@end
