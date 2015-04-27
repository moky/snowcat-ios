//
//  SCSwipeTableViewCell.m
//  SnowCat
//
//  Created by Moky on 14-6-20.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCClient.h"
#import "SCNib.h"
#import "SCSwipeTableViewCell.h"

typedef NS_ENUM(NSInteger, UITableViewCellIndentationStatus) {
	UITableViewCellIndentationNone,
	UITableViewCellIndentationLeft,
	UITableViewCellIndentationRight
};

@interface UISwipeTableViewCell ()

@property(nonatomic, readwrite) UITableViewCellIndentationStatus indentationStatus;

@end

@implementation UISwipeTableViewCell

@synthesize indentationLeft = _indentationLeft;
@synthesize indentationRight = _indentationRight;
@synthesize indentationStatus = _indentationStatus;

- (void) _initializeUISwipeTableViewCell
{
	_indentationLeft = 0.0f;
	_indentationRight = 0.0f;
	_indentationStatus = UITableViewCellIndentationNone;
	
	UISwipeGestureRecognizer * recognizer;
	// swipe left
	recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(_handleSwipeGesture:)];
	recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
	[self.contentView addGestureRecognizer:recognizer];
	[recognizer autorelease];
	// swipe right
	recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(_handleSwipeGesture:)];
	recognizer.direction = UISwipeGestureRecognizerDirectionRight;
	[self.contentView addGestureRecognizer:recognizer];
	[recognizer autorelease];
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeUISwipeTableViewCell];
	}
	return self;
}

// Designated initializer.  If the cell can be reused, you must pass in a reuse identifier.  You should use the same reuse identifier for all cells of the same form.
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier NS_AVAILABLE_IOS(3_0)
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		[self _initializeUISwipeTableViewCell];
	}
	return self;
}

- (void) _handleSwipeGesture:(UISwipeGestureRecognizer *)recognizer
{
	UISwipeGestureRecognizerDirection direction = recognizer.direction;
	UITableViewCellIndentationStatus status = _indentationStatus;
	
	if (direction == UISwipeGestureRecognizerDirectionLeft) {
		if (status == UITableViewCellIndentationLeft) {
			status = UITableViewCellIndentationNone;
		} else if (status == UITableViewCellIndentationNone && _indentationRight > 0) {
			status = UITableViewCellIndentationRight;
		}
	} else if (direction == UISwipeGestureRecognizerDirectionRight) {
		if (status == UITableViewCellIndentationRight) {
			status = UITableViewCellIndentationNone;
		} else if (status == UITableViewCellIndentationNone && _indentationLeft > 0) {
			status = UITableViewCellIndentationLeft;
		}
	}
	
	self.indentationStatus = status;
}

- (void) setIndentationStatus:(UITableViewCellIndentationStatus)indentationStatus
{
	if (indentationStatus != _indentationStatus) {
		_indentationStatus = indentationStatus;
		
		UIView * contentView = self.contentView;
		CGSize size = contentView.bounds.size;;
		
		[UIView beginAnimations:nil context:NULL];
		switch (indentationStatus) {
			case UITableViewCellIndentationNone:
				contentView.center = CGPointMake(size.width * 0.5, size.height * 0.5);
				break;
				
			case UITableViewCellIndentationLeft:
				contentView.center = CGPointMake(size.width * 0.5 + _indentationLeft, size.height * 0.5);
				break;
				
			case UITableViewCellIndentationRight:
				contentView.center = CGPointMake(size.width * 0.5 - _indentationRight, size.height * 0.5);
				break;
				
			default:
				NSAssert(false, @"unrecognized status: %d", (int)indentationStatus);
				break;
		}
		[UIView commitAnimations];
	}
}

- (void) onReuse:(id)sender
{
	// fix the bug while table view cell reused.
//	UITableViewCellIndentationStatus status = _indentationStatus;
	self.indentationStatus = UITableViewCellIndentationNone;
//	self.indentationStatus = status;
}

@end

#pragma mark -

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
