//
//  SCTableViewHeaderFooterView.m
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCNib.h"
#import "SCColor.h"
#import "SCLabel.h"
#import "SCTableViewHeaderFooterView.h"

@implementation SCTableViewHeaderFooterView

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

- (instancetype) initWithReuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithReuseIdentifier:reuseIdentifier];
	if (self) {
		_scTag = 0;
		self.nodeFile = nil;
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	NSString * reuseIdentifier = [dict objectForKey:@"reuseIdentifier"];
	self = [self initWithReuseIdentifier:reuseIdentifier];
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

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UITableViewHeaderFooterView *)tableViewHeaderFooterView
{
	if (![SCView setAttributes:dict to:tableViewHeaderFooterView]) {
		return NO;
	}
	
	// tintColor
	NSDictionary * tintColor = [dict objectForKey:@"tintColor"];
	if (tintColor) {
		SCColor * color = [SCColor create:tintColor autorelease:NO];
		tableViewHeaderFooterView.tintColor = color;
		[color release];
	}
	
	// textLabel
	NSDictionary * textLabel = [dict objectForKey:@"textLabel"];
	if (textLabel) {
		SC_UIKIT_SET_ATTRIBUTES(tableViewHeaderFooterView.textLabel, SCLabel, textLabel);
	} else {
		NSString * text = [dict objectForKey:@"text"];
		if (text) {
			text = SCLocalizedString(text, nil);
			tableViewHeaderFooterView.textLabel.text = text;
		}
	}
	
	// detailTextLabel
	NSDictionary * detailTextLabel = [dict objectForKey:@"detailTextLabel"];
	if (detailTextLabel) {
		SC_UIKIT_SET_ATTRIBUTES(tableViewHeaderFooterView.detailTextLabel, SCLabel, detailTextLabel);
	} else {
		NSString * detail = [dict objectForKey:@"detail"];
		if (detail) {
			detail = SCLocalizedString(detail, nil);
			tableViewHeaderFooterView.detailTextLabel.text = detail;
		}
	}
	
	// contentView
	NSDictionary * contentView = [dict objectForKey:@"contentView"];
	if (contentView) {
		SC_UIKIT_SET_ATTRIBUTES(tableViewHeaderFooterView.contentView, SCView, contentView);
	}
	
	// backgroundView
	NSDictionary * backgroundView = [dict objectForKey:@"backgroundView"];
	if (backgroundView) {
		SC_UIKIT_DIG_CREATION_INFO(backgroundView); // support ObjectFromFile
		SCView * view = [SCView create:backgroundView autorelease:NO];
		NSAssert([view isKindOfClass:[UIView class]], @"backgroundView's definition error: %@", backgroundView);
		tableViewHeaderFooterView.backgroundView = view;
		SC_UIKIT_SET_ATTRIBUTES(view, SCView, backgroundView);
		[view release];
	}
	
	return YES;
}

@end
