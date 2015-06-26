//
//  SCSwipeTableViewCell.m
//  SnowCat
//
//  Created by Moky on 14-6-20.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCClient.h"
#import "SCNib.h"
#import "SCTableViewCell.h"
#import "SCSwipeTableViewCell.h"

@implementation SCSwipeTableViewCell

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib

- (void) dealloc
{
	[_nodeFile release];
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCSwipeTableViewCell
{
	_scTag = 0;
	self.nodeFile = nil;
	
#ifdef __IPHONE_7_0
	CGFloat systemVersion = SCSystemVersion();
	if (systemVersion >= 7.0f) {
		self.separatorInset = UIEdgeInsetsZero;
		
#ifdef __IPHONE_8_0
		if (systemVersion >= 8.0f) {
			self.layoutMargins = UIEdgeInsetsZero;
			self.preservesSuperviewLayoutMargins = NO;
		}
#endif
	}
#endif // EOF '__IPHONE_7_0'
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCSwipeTableViewCell];
	}
	return self;
}

// Designated initializer.  If the cell can be reused, you must pass in a reuse identifier.  You should use the same reuse identifier for all cells of the same form.
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier NS_AVAILABLE_IOS(3_0)
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		[self _initializeSCSwipeTableViewCell];
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	NSInteger style = UITableViewCellStyleDefault;
	if ([[dict objectForKey:@"style"] isEqualToString:@"subtitle"]) {
		style = UITableViewCellStyleSubtitle;
	}
	NSString * reuseIdentifier = [dict objectForKey:@"reuseIdentifier"];
	
	self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
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

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UISwipeTableViewCell *)swipeTableViewCell
{
	if (![SCTableViewCell setAttributes:dict to:swipeTableViewCell]) {
		return NO;
	}
	
	// indentationLeft
	id indentationLeft = [dict objectForKey:@"indentationLeft"];
	if (indentationLeft) {
		swipeTableViewCell.indentationLeft = [indentationLeft floatValue];
	}
	
	// indentationRight
	id indentationRight = [dict objectForKey:@"indentationRight"];
	if (indentationRight) {
		swipeTableViewCell.indentationRight = [indentationRight floatValue];
	}
	
	return YES;
}

@end
