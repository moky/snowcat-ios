//
//  SCTableViewCell.m
//  SnowCat
//
//  Created by Moky on 14-3-18.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCClient.h"
#import "SCNib.h"
#import "SCImage.h"
#import "SCLabel.h"
#import "SCImageView.h"
#import "SCTableViewCell.h"

//typedef NS_ENUM(NSInteger, UITableViewCellStyle) {
//    UITableViewCellStyleDefault,	// Simple cell with text label and optional image view (behavior of UITableViewCell in iPhoneOS 2.x)
//    UITableViewCellStyleValue1,		// Left aligned label on left and right aligned label on right with blue text (Used in Settings)
//    UITableViewCellStyleValue2,		// Right aligned label on left with blue text and left aligned label on right (Used in Phone/Contacts)
//    UITableViewCellStyleSubtitle	// Left aligned label on top and left aligned label on bottom with gray text (Used in iPod).
//};             // available in iPhone OS 3.0
UITableViewCellStyle UITableViewCellStyleFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Default")
			return UITableViewCellStyleDefault;
		SC_SWITCH_CASE(string, @"Value1")
			return UITableViewCellStyleValue1;
		SC_SWITCH_CASE(string, @"Value2")
			return UITableViewCellStyleValue2;
		SC_SWITCH_CASE(string, @"Sub") // Subtitle
			return UITableViewCellStyleSubtitle;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

//typedef NS_ENUM(NSInteger, UITableViewCellSeparatorStyle) {
//    UITableViewCellSeparatorStyleNone,
//    UITableViewCellSeparatorStyleSingleLine,
//    UITableViewCellSeparatorStyleSingleLineEtched   // This separator style is only supported for grouped style table views currently
//};
UITableViewCellSeparatorStyle UITableViewCellSeparatorStyleFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Etched") // SingleLineEtched
			return UITableViewCellSeparatorStyleSingleLineEtched;
		SC_SWITCH_CASE(string, @"Single") // SingleLine
			return UITableViewCellSeparatorStyleSingleLine;
		SC_SWITCH_CASE(string, @"None")
			return UITableViewCellSeparatorStyleNone;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

//typedef NS_ENUM(NSInteger, UITableViewCellSelectionStyle) {
//    UITableViewCellSelectionStyleNone,
//    UITableViewCellSelectionStyleBlue,
//    UITableViewCellSelectionStyleGray
//};
UITableViewCellSelectionStyle UITableViewCellSelectionStyleFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Gray")
			return UITableViewCellSelectionStyleGray;
		SC_SWITCH_CASE(string, @"Blue")
			return UITableViewCellSelectionStyleBlue;
		SC_SWITCH_CASE(string, @"None")
			return UITableViewCellSelectionStyleNone;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

//typedef NS_ENUM(NSInteger, UITableViewCellEditingStyle) {
//    UITableViewCellEditingStyleNone,
//    UITableViewCellEditingStyleDelete,
//    UITableViewCellEditingStyleInsert
//};
UITableViewCellEditingStyle UITableViewCellEditingStyleFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Insert")
			return UITableViewCellEditingStyleInsert;
		SC_SWITCH_CASE(string, @"Delete")
			return UITableViewCellEditingStyleDelete;
		SC_SWITCH_CASE(string, @"None")
			return UITableViewCellEditingStyleNone;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

//typedef NS_ENUM(NSInteger, UITableViewCellAccessoryType) {
//    UITableViewCellAccessoryNone,                   // don't show any accessory view
//    UITableViewCellAccessoryDisclosureIndicator,    // regular chevron. doesn't track
//    UITableViewCellAccessoryDetailDisclosureButton, // blue button w/ chevron. tracks
//    UITableViewCellAccessoryCheckmark               // checkmark. doesn't track
//};
UITableViewCellAccessoryType UITableViewCellAccessoryTypeFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Check")     // Checkmark
			return UITableViewCellAccessoryCheckmark;
		SC_SWITCH_CASE(string, @"Detail")    // DetailDisclosureButton
			return UITableViewCellAccessoryDetailDisclosureButton;
		SC_SWITCH_CASE(string, @"Indicator") // DisclosureIndicator
			return UITableViewCellAccessoryDisclosureIndicator;
		SC_SWITCH_CASE(string, @"None")
			return UITableViewCellAccessoryNone;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

//typedef NS_OPTIONS(NSUInteger, UITableViewCellStateMask) {
//    UITableViewCellStateDefaultMask                     = 0,
//    UITableViewCellStateShowingEditControlMask          = 1 << 0,
//    UITableViewCellStateShowingDeleteConfirmationMask   = 1 << 1
//};
UITableViewCellStateMask UITableViewCellStateMaskFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Default")
			return UITableViewCellStateDefaultMask;
		SC_SWITCH_CASE(string, @"Edit")   // ShowingEditControl
			return UITableViewCellStateShowingEditControlMask;
		SC_SWITCH_CASE(string, @"Delete") // ShowingDeleteConfirmation
			return UITableViewCellStateShowingDeleteConfirmationMask;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

@implementation SCTableViewCell

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib

- (void) dealloc
{
	[_nodeFile release];
	
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCTableViewCell
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
		[self _initializeSCTableViewCell];
	}
	return self;
}

// Designated initializer.  If the cell can be reused, you must pass in a reuse identifier.  You should use the same reuse identifier for all cells of the same form.
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier NS_AVAILABLE_IOS(3_0)
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		[self _initializeSCTableViewCell];
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	NSInteger style = UITableViewCellStyleFromString([dict objectForKey:@"style"]);
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

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UITableViewCell *)tableViewCell
{
	if (![SCView setAttributes:dict to:tableViewCell]) {
		return NO;
	}
	
	// imageView
	NSDictionary * imageView = [dict objectForKey:@"imageView"];
	if (imageView) {
		SC_UIKIT_SET_ATTRIBUTES(tableViewCell.imageView, SCImageView, imageView);
	} else {
		id image = [dict objectForKey:@"image"];
		if (image) {
			SCImage * img = [SCImage create:image autorelease:NO];
			tableViewCell.imageView.image = img;
			[img release];
		}
	}
	
	// textLabel
	NSDictionary * textLabel = [dict objectForKey:@"textLabel"];
	if (textLabel) {
		SC_UIKIT_SET_ATTRIBUTES(tableViewCell.textLabel, SCLabel, textLabel);
	} else {
		NSString * text = [dict objectForKey:@"text"];
		if (text) {
			text = SCLocalizedString(text, nil);
			tableViewCell.textLabel.text = text;
		}
	}
	
	// detailTextLabel
	NSDictionary * detailTextLabel = [dict objectForKey:@"detailTextLabel"];
	if (detailTextLabel) {
		SC_UIKIT_SET_ATTRIBUTES(tableViewCell.detailTextLabel, SCLabel, detailTextLabel);
	} else {
		NSString * detail = [dict objectForKey:@"detail"];
		if (detail) {
			detail = SCLocalizedString(detail, nil);
			tableViewCell.detailTextLabel.text = detail;
		}
	}
	
	// contentView
	NSDictionary * contentView = [dict objectForKey:@"contentView"];
	if (contentView) {
		SC_UIKIT_DIG_CREATION_INFO(contentView); // support ObjectFromFile
		SC_UIKIT_SET_ATTRIBUTES(tableViewCell.contentView, SCView, contentView);
	}
	
	// backgroundView
	NSDictionary * backgroundView = [dict objectForKey:@"backgroundView"];
	if (backgroundView) {
		SC_UIKIT_DIG_CREATION_INFO(backgroundView); // support ObjectFromFile
		SCView * view = [SCView create:backgroundView autorelease:NO];
		NSAssert([view isKindOfClass:[UIView class]], @"backgroundView's definition error: %@", backgroundView);
		tableViewCell.backgroundView = view;
		SC_UIKIT_SET_ATTRIBUTES(view, SCView, backgroundView);
		[view release];
	}
	
	// selectedBackgroundView
	NSDictionary * selectedBackgroundView = [dict objectForKey:@"selectedBackgroundView"];
	if (selectedBackgroundView) {
		SC_UIKIT_DIG_CREATION_INFO(selectedBackgroundView); // support ObjectFromFile
		SCView * view = [SCView create:selectedBackgroundView autorelease:NO];
		NSAssert([view isKindOfClass:[UIView class]], @"selectedBackgroundView's definition error: %@", selectedBackgroundView);
		tableViewCell.selectedBackgroundView = view;
		SC_UIKIT_SET_ATTRIBUTES(view, SCView, selectedBackgroundView);
		[view release];
	}
	
	// multipleSelectionBackgroundView
	NSDictionary * multipleSelectionBackgroundView = [dict objectForKey:@"multipleSelectionBackgroundView"];
	if (multipleSelectionBackgroundView) {
		SC_UIKIT_DIG_CREATION_INFO(multipleSelectionBackgroundView); // support ObjectFromFile
		SCView * view = [SCView create:multipleSelectionBackgroundView autorelease:NO];
		NSAssert([view isKindOfClass:[UIView class]], @"multipleSelectionBackgroundView's definition error: %@", multipleSelectionBackgroundView);
		tableViewCell.multipleSelectionBackgroundView = view;
		SC_UIKIT_SET_ATTRIBUTES(view, SCView, multipleSelectionBackgroundView);
		[view release];
	}
	
	// selectionStyle
	NSString * selectionStyle = [dict objectForKey:@"selectionStyle"];
	if (selectionStyle) {
		tableViewCell.selectionStyle = UITableViewCellSelectionStyleFromString(selectionStyle);
	}
	
	// selected
	id selected = [dict objectForKey:@"selected"];
	if (selected) {
		tableViewCell.selected = [selected boolValue];
	}
	
	// highlighted
	id highlighted = [dict objectForKey:@"highlighted"];
	if (highlighted) {
		tableViewCell.highlighted = [highlighted boolValue];
	}
	
	// showsReorderControl
	id showsReorderControl = [dict objectForKey:@"showsReorderControl"];
	if (showsReorderControl) {
		tableViewCell.showsReorderControl = [showsReorderControl boolValue];
	}
	
	// shouldIndentWhileEditing
	id shouldIndentWhileEditing = [dict objectForKey:@"shouldIndentWhileEditing"];
	if (shouldIndentWhileEditing) {
		tableViewCell.shouldIndentWhileEditing = [shouldIndentWhileEditing boolValue];
	}
	
	// accessoryType
	NSString * accessoryType = [dict objectForKey:@"accessoryType"];
	if (accessoryType) {
		tableViewCell.accessoryType = UITableViewCellAccessoryTypeFromString(accessoryType);
	}
	
	// accessoryView
	NSDictionary * accessoryView = [dict objectForKey:@"accessoryView"];
	if (accessoryView) {
		SC_UIKIT_DIG_CREATION_INFO(accessoryView); // support ObjectFromFile
		SCView * view = [SCView create:accessoryView autorelease:NO];
		NSAssert([view isKindOfClass:[UIView class]], @"accessoryView's definition error: %@", accessoryView);
		tableViewCell.accessoryView = view;
		SC_UIKIT_SET_ATTRIBUTES(view, SCView, accessoryView);
		[view release];
	}
	
	// editingAccessoryType
	NSString * editingAccessoryType = [dict objectForKey:@"editingAccessoryType"];
	if (editingAccessoryType) {
		tableViewCell.editingAccessoryType = UITableViewCellAccessoryTypeFromString(editingAccessoryType);
	}
	
	// editingAccessoryView
	NSDictionary * editingAccessoryView = [dict objectForKey:@"editingAccessoryView"];
	if (editingAccessoryView) {
		SC_UIKIT_DIG_CREATION_INFO(editingAccessoryView); // support ObjectFromFile
		SCView * view = [SCView create:editingAccessoryView autorelease:NO];
		NSAssert([view isKindOfClass:[UIView class]], @"editingAccessoryView's definition error: %@", editingAccessoryView);
		tableViewCell.editingAccessoryView = view;
		SC_UIKIT_SET_ATTRIBUTES(view, SCView, editingAccessoryView);
		[view release];
	}
	
	// indentationLevel
	id indentationLevel = [dict objectForKey:@"indentationLevel"];
	if (indentationLevel) {
		tableViewCell.indentationLevel = [indentationLevel integerValue];
	}
	
	// indentationWidth
	id indentationWidth = [dict objectForKey:@"indentationWidth"];
	if (indentationWidth) {
		tableViewCell.indentationWidth = [indentationWidth floatValue];
	}
	
	// editing
	id editing = [dict objectForKey:@"editing"];
	if (editing) {
		tableViewCell.editing = [editing boolValue];
	}
	
#ifdef __IPHONE_7_0
	// (iOS 7.0)
	CGFloat systemVersion = SCSystemVersion();
	if (systemVersion >= 7.0f) {
		
		// separatorInset
		NSString * separatorInset = [dict objectForKey:@"separatorInset"];
		if (separatorInset) {
			tableViewCell.separatorInset = UIEdgeInsetsFromString(separatorInset);
		}
		
	}
#endif // EOF '__IPHONE_7_0'
	
	return YES;
}

+ (void) resetCell:(UITableViewCell *)cell withTableView:(UITableView *)tableView
{
	//
	// 1. bounds
	//
	CGRect bounds = CGRectMake(0, 0, tableView.bounds.size.width, tableView.rowHeight);
	// cell
	bounds.origin = cell.bounds.origin;
	cell.bounds = bounds;
	// content view
	bounds.origin = cell.contentView.bounds.origin;
	cell.contentView.bounds = bounds;
	
	//
	// 2. editing
	//
	cell.editing = tableView.editing;
	
#ifdef __IPHONE_7_0
	CGFloat systemVersion = SCSystemVersion();
	if (systemVersion >= 7.0f) {
		//
		// 3. separator
		//
		cell.separatorInset = tableView.separatorInset;
	}
#endif // EOF '__IPHONE_7_0'
	
	//
	// 4. clear subviews
	//
	NSArray * subviews = cell.contentView.subviews;
	if ([subviews count] > 0) {
		[subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	}
	subviews = cell.backgroundView.subviews;
	if ([subviews count] > 0) {
		[subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	}
	subviews = cell.selectedBackgroundView.subviews;
	if ([subviews count] > 0) {
		[subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	}
}

@end
