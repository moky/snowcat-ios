//
//  SCSearchBar.m
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "scMacros.h"
#import "SCNib.h"
#import "SCInterface.h"
#import "SCTextInputTraits.h"
#import "SCColor.h"
#import "SCImage.h"
#import "SCSearchBarDelegate.h"
#import "SCSearchBar.h"

//typedef NS_ENUM(NSInteger, UISearchBarIcon) {
//    UISearchBarIconSearch, // The magnifying glass
//    UISearchBarIconClear, // The circle with an x in it
//    UISearchBarIconBookmark, // The open book icon
//    UISearchBarIconResultsList, // The list lozenge icon
//};
UISearchBarIcon UISearchBarIconFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Search")
			return UISearchBarIconSearch;
		SC_SWITCH_CASE(string, @"Clear")
			return UISearchBarIconClear;
		SC_SWITCH_CASE(string, @"Book")
			return UISearchBarIconBookmark;
		SC_SWITCH_CASE(string, @"Results")
			return UISearchBarIconResultsList;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

@interface SCSearchBar ()

@property(nonatomic, retain) id<SCSearchBarDelegate> searchBarDelegate;

@end

@implementation SCSearchBar

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib
@synthesize searchBarDelegate = _searchBarDelegate;

- (void) dealloc
{
	[_searchBarDelegate release];
	[_nodeFile release];
	
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCSearchBar
{
	_scTag = 0;
	self.nodeFile = nil;
	
	self.searchBarDelegate = nil;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCSearchBar];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeSCSearchBar];
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
		self.searchBarDelegate = [SCSearchBarDelegate create:delegate];
		// self.delegate only assign but won't retain the action delegate,
		// so don't release it now
		self.delegate = _searchBarDelegate;
	}
}

// awakeFromNib
SC_UIKIT_IMPLEMENT_AWAKE_FUNCTION()

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UISearchBar *)searchBar
{
	[searchBar sizeToFit];
	
	// set general attributes after
	if (![SCView setAttributes:dict to:searchBar]) {
		return NO;
	}
	
	// barStyle
	NSString * barStyle = [dict objectForKey:@"barStyle"];
	if (barStyle) {
		searchBar.barStyle = UIBarStyleFromString(barStyle);
	}
	
	// delegate
	
	// text
	NSString * text = [dict objectForKey:@"text"];
	if (text) {
		text = SCLocalizedString(text, nil);
		searchBar.text = text;
	}
	
	// prompt
	NSString * prompt = [dict objectForKey:@"prompt"];
	if (prompt) {
		prompt = SCLocalizedString(prompt, nil);
		searchBar.prompt = prompt;
	}
	
	// placeholder
	NSString * placeholder = [dict objectForKey:@"placeholder"];
	if (placeholder) {
		placeholder = SCLocalizedString(placeholder, nil);
		searchBar.placeholder = placeholder;
	}
	
	// showsBookmarkButton
	id showsBookmarkButton = [dict objectForKey:@"showsBookmarkButton"];
	if (showsBookmarkButton) {
		searchBar.showsBookmarkButton = [showsBookmarkButton boolValue];
	}
	
	// showsCancelButton
	id showsCancelButton = [dict objectForKey:@"showsCancelButton"];
	if (showsCancelButton) {
		searchBar.showsCancelButton = [showsCancelButton boolValue];
	}
	
	// showsSearchResultsButton
	id showsSearchResultsButton = [dict objectForKey:@"showsSearchResultsButton"];
	if (showsSearchResultsButton) {
		searchBar.showsSearchResultsButton = [showsSearchResultsButton boolValue];
	}
	
	// searchResultsButtonSelected
	id searchResultsButtonSelected = [dict objectForKey:@"searchResultsButtonSelected"];
	if (searchResultsButtonSelected) {
		searchBar.searchResultsButtonSelected = [searchResultsButtonSelected boolValue];
	}
	
	// tintColor
	NSDictionary * tintColor = [dict objectForKey:@"tintColor"];
	if (tintColor) {
		SCColor * color = [SCColor create:tintColor autorelease:NO];
		searchBar.tintColor = color;
		[color release];
	}
	
	// translucent
	id translucent = [dict objectForKey:@"translucent"];
	if (translucent) {
		searchBar.translucent = [translucent boolValue];
	}
	
	// autocapitalizationType
	NSString * autocapitalizationType = [dict objectForKey:@"autocapitalizationType"];
	if (autocapitalizationType) {
		searchBar.autocapitalizationType = UITextAutocapitalizationTypeFromString(autocapitalizationType);
	}
	
	// autocorrectionType
	NSString * autocorrectionType = [dict objectForKey:@"autocorrectionType"];
	if (autocorrectionType) {
		searchBar.autocorrectionType = UITextAutocorrectionTypeFromString(autocorrectionType);
	}
	
	// spellCheckingType
	NSString * spellCheckingType = [dict objectForKey:@"spellCheckingType"];
	if (spellCheckingType) {
		searchBar.spellCheckingType = UITextSpellCheckingTypeFromString(spellCheckingType);
	}
	
	// keyboardType
	NSString * keyboardType = [dict objectForKey:@"keyboardType"];
	if (keyboardType) {
		searchBar.keyboardType = UIKeyboardTypeFromString(keyboardType);
	}
	
	// scopeButtonTitles
	NSArray * scopeButtonTitles = [dict objectForKey:@"scopeButtonTitles"];
	if (scopeButtonTitles) {
		NSMutableArray * a = [[NSMutableArray alloc] initWithCapacity:[scopeButtonTitles count]];
		NSEnumerator * e = [scopeButtonTitles objectEnumerator];
		NSString * s;
		while (s = [e nextObject]) {
			s = SCLocalizedString(s, nil);
			NSAssert([s isKindOfClass:[NSString class]], @"error: %@ in %@", s, scopeButtonTitles);
			if (s) {
				[a addObject:s];
			}
		}
		searchBar.scopeButtonTitles = a;
		[a release];
	}
	
	// selectedScopeButtonIndex
	id selectedScopeButtonIndex = [dict objectForKey:@"selectedScopeButtonIndex"];
	if (selectedScopeButtonIndex) {
		searchBar.selectedScopeButtonIndex = [selectedScopeButtonIndex integerValue];
	}
	
	// showsScopeBar
	id showsScopeBar = [dict objectForKey:@"showsScopeBar"];
	if (showsScopeBar) {
		searchBar.showsScopeBar = [showsScopeBar boolValue];
	}
	
	// inputAccessoryView
	NSDictionary * inputAccessoryView = [dict objectForKey:@"inputAccessoryView"];
	if (inputAccessoryView) {
		SC_UIKIT_DIG_CREATION_INFO(inputAccessoryView); // support ObjectFromFile
		SCView * view = [SCView create:inputAccessoryView autorelease:NO];
		NSAssert([view isKindOfClass:[UIView class]], @"inputAccessoryView's definition error: %@", inputAccessoryView);
		searchBar.inputAccessoryView = view;
		SC_UIKIT_SET_ATTRIBUTES(view, SCView, inputAccessoryView);
		[view release];
	}
	
	// backgroundImage
	NSDictionary * backgroundImage = [dict objectForKey:@"backgroundImage"];
	if (backgroundImage) {
		SCImage * image = [SCImage create:backgroundImage autorelease:NO];
		searchBar.backgroundImage = image;
		[image release];
	}
	
	// scopeBarBackgroundImage
	NSDictionary * scopeBarBackgroundImage = [dict objectForKey:@"scopeBarBackgroundImage"];
	if (scopeBarBackgroundImage) {
		SCImage * image = [SCImage create:scopeBarBackgroundImage autorelease:NO];
		searchBar.scopeBarBackgroundImage = image;
		[image release];
	}
	
	// searchFieldBackgroundPositionAdjustment
	NSString * searchFieldBackgroundPositionAdjustment = [dict objectForKey:@"searchFieldBackgroundPositionAdjustment"];
	if (searchFieldBackgroundPositionAdjustment) {
		searchBar.searchFieldBackgroundPositionAdjustment = UIOffsetFromString(searchFieldBackgroundPositionAdjustment);
	}
	
	// searchTextPositionAdjustment
	NSString * searchTextPositionAdjustment = [dict objectForKey:@"searchTextPositionAdjustment"];
	if (searchTextPositionAdjustment) {
		searchBar.searchTextPositionAdjustment = UIOffsetFromString(searchTextPositionAdjustment);
	}
	
	return YES;
}

@end
