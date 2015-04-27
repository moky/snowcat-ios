//
//  SCScrollRefreshView.m
//  SnowCat
//
//  Created by Moky on 15-1-11.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCNib.h"
#import "SCActivityIndicatorView.h"
#import "SCLabel.h"
#import "SCScrollRefreshView.h"

@implementation UIScrollRefreshView

@synthesize visibleText = _visibleText;
@synthesize willRefreshText = _willRefreshText;
@synthesize refreshingText = _refreshingText;
@synthesize updatedText = _updatedText;
@synthesize updatedTimeFormat = _updatedTimeFormat;

@synthesize updatedTime = _updatedTime;
@synthesize loading = _loading;

@synthesize loadingIndicator = _loadingIndicator;
@synthesize textLabel = _textLabel;
@synthesize timeLabel = _timeLabel;

@synthesize trayView = _trayView;

- (void) dealloc
{
	self.visibleText = nil;
	self.willRefreshText = nil;
	self.refreshingText = nil;
	self.updatedText = nil;
	self.updatedTimeFormat = nil;
	
	self.updatedTime = nil;
	
	self.trayView = nil;
	self.loadingIndicator = nil;
	self.textLabel = nil;
	self.timeLabel = nil;
	
	[super dealloc];
}

- (void) _initializeUIScrollRefreshView
{
	self.backgroundColor = [UIColor whiteColor];
	
	self.visibleText       = SCLocalizedString(@"Pull to refresh", nil);
	self.willRefreshText   = SCLocalizedString(@"Release to refresh", nil);
	self.refreshingText    = SCLocalizedString(@"Refreshing...", nil);
	self.updatedText       = SCLocalizedString(@"Last updated", nil);
	self.updatedTimeFormat = nil; // use default format
	
	self.updatedTime = nil;
	_loading = NO;
	
	self.loadingIndicator = nil;
	self.textLabel = nil;
	self.timeLabel = nil;
	
	self.trayView = nil;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeUIScrollRefreshView];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeUIScrollRefreshView];
	}
	return self;
}

#pragma mark -

- (void) reloadData:(UIScrollView *)scrollView
{
	[super reloadData:scrollView];
	self.updatedTime = [NSDate date];
}

- (void) setLoading:(BOOL)loading
{
	if (loading) {
		[self.loadingIndicator startAnimating];
	} else {
		[self.loadingIndicator stopAnimating];
	}
	_loading = loading;
}

- (UIView *) trayView
{
	if (!_trayView) {
		// use the last subview as tray view
		_trayView = [[self.subviews lastObject] retain];
		
		// dimension
		if (_trayView) {
			CGFloat dimension = 0.0f;
			if (self.direction == UIScrollRefreshControlDirectionTop || self.direction == UIScrollRefreshControlDirectionBottom) {
				dimension = _trayView.bounds.size.height;
			} else {
				dimension = _trayView.bounds.size.width;
			}
			NSAssert(dimension > 0.0f, @"error");
			if (dimension > 0.0f) {
				self.dimension = dimension;
			}
		}
	}
	
	if (!_trayView) {
		CGRect frame = self.bounds;
		CGFloat dimension = self.dimension;
		UIViewAutoresizing autoresizingMask = UIViewAutoresizingNone;
		
		switch (self.direction) {
			case UIScrollRefreshControlDirectionTop:
				frame.origin.y = frame.origin.y + frame.size.height - dimension;
				frame.size.height = dimension;
				autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
				break;
				
			case UIScrollRefreshControlDirectionBottom:
				frame.size.height = dimension;
				autoresizingMask = UIViewAutoresizingFlexibleWidth;
				break;
				
			case UIScrollRefreshControlDirectionLeft:
				frame.origin.x = frame.origin.x + frame.size.width - dimension;
				frame.size.width = dimension;
				autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
				break;
				
			case UIScrollRefreshControlDirectionRight:
				frame.origin.y = frame.size.height - dimension;
				frame.size.width = dimension;
				autoresizingMask = UIViewAutoresizingFlexibleHeight;
				break;
				
			default:
				NSAssert(false, @"error");
				break;
		}
		
		_trayView = [[UIView alloc] initWithFrame:frame];
		_trayView.autoresizingMask = autoresizingMask;
		
		[self addSubview:_trayView];
	}
	
	return _trayView;
}

- (UIActivityIndicatorView *) loadingIndicator
{
	if (!_loadingIndicator) {
		// get indicator from subviews of trayView by class
		NSEnumerator * enumerator = [self.trayView.subviews objectEnumerator];
		UIActivityIndicatorView * aiv;
		while (aiv = [enumerator nextObject]) {
			if ([aiv isKindOfClass:[UIActivityIndicatorView class]]) {
				_loadingIndicator = [aiv retain];
				break;
			}
		}
	}
	
	if (!_loadingIndicator) {
		UIView * trayView = [self trayView];
		CGRect frame = trayView.bounds;
		
		_loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[trayView addSubview:_loadingIndicator];
		
		if (self.direction == UIScrollRefreshControlDirectionTop || UIScrollRefreshControlDirectionBottom) {
			// scroll vertical
			_loadingIndicator.center = CGPointMake(frame.size.height * 0.5f, frame.size.height * 0.5f);
		} else {
			// scroll horizontal
			_loadingIndicator.center = CGPointMake(frame.size.width * 0.5f, frame.size.width * 0.5f);
		}
	}
	return _loadingIndicator;
}

- (UILabel *) textLabel
{
	if (!_textLabel) {
		// get first label from subviews of trayView
		NSEnumerator * enumerator = [self.trayView.subviews objectEnumerator];
		UILabel * label = nil;
		while (label = [enumerator nextObject]) {
			if ([label isKindOfClass:[UILabel class]]) {
				_textLabel = [label retain];
				break;
			}
		}
	}
	
	if (!_textLabel) {
		UIView * tray = [self trayView];
		CGRect frame = tray.bounds;
		
		switch (self.direction) {
			case UIScrollRefreshControlDirectionTop:
				frame.size.height *= 0.5f;
				frame.origin.y = frame.size.height;
				break;
				
			case UIScrollRefreshControlDirectionBottom:
				frame.size.height *= 0.5f;
				break;
				
			case UIScrollRefreshControlDirectionLeft:
				frame.size.width *= 0.5f;
				frame.origin.x = frame.size.width;
				break;
				
			case UIScrollRefreshControlDirectionRight:
				frame.size.width *= 0.5f;
				break;
				
			default:
				NSAssert(false, @"error");
				break;
		}
		
		_textLabel = [[UILabel alloc] initWithFrame:frame];
		_textLabel.backgroundColor = [UIColor clearColor];
		_textLabel.textColor = [UIColor grayColor];
		
		[tray addSubview:_textLabel];
	}
	return _textLabel;
}

- (UILabel *) timeLabel
{
	if (!_timeLabel) {
		// get second label from subviews of trayView
		NSEnumerator * enumerator = [self.trayView.subviews objectEnumerator];
		UILabel * label = nil;
		UILabel * textLabel = nil;
		while (label = [enumerator nextObject]) {
			if ([label isKindOfClass:[UILabel class]]) {
				if (textLabel) {
					_timeLabel = [label retain];
					break;
				}
				textLabel = label;
			}
		}
	}
	
	if (!_timeLabel) {
		UIView * tray = [self trayView];
		CGRect frame = tray.bounds;
		
		switch (self.direction) {
			case UIScrollRefreshControlDirectionTop:
				frame.size.height *= 0.5f;
				break;
				
			case UIScrollRefreshControlDirectionBottom:
				frame.size.height *= 0.5f;
				frame.origin.y = frame.size.height;
				break;
				
			case UIScrollRefreshControlDirectionLeft:
				frame.size.width *= 0.5f;
				break;
				
			case UIScrollRefreshControlDirectionRight:
				frame.size.width *= 0.5f;
				frame.origin.x = frame.size.width;
				break;
				
			default:
				NSAssert(false, @"error");
				break;
		}
		
		_timeLabel = [[UILabel alloc] initWithFrame:frame];
		_timeLabel.backgroundColor = [UIColor clearColor];
		_timeLabel.textColor = [UIColor grayColor];
		
		[tray addSubview:_timeLabel];
	}
	return _timeLabel;
}

@end

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
