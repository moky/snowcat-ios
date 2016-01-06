//
//  SCSearchBar.m
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
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
#if !TARGET_OS_TV
		SC_SWITCH_CASE(string, @"Clear")
			return UISearchBarIconClear;
		SC_SWITCH_CASE(string, @"Book")    // Bookmark
			return UISearchBarIconBookmark;
		SC_SWITCH_CASE(string, @"Results") // ResultsList
			return UISearchBarIconResultsList;
#endif
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
#if !TARGET_OS_TV
	self = [self initWithFrame:CGRectZero];
#else
	// TODO: init
#endif
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
	
#if !TARGET_OS_TV
	// barStyle
	NSString * barStyle = [dict objectForKey:@"barStyle"];
	if (barStyle) {
		searchBar.barStyle = UIBarStyleFromString(barStyle);
	}
#endif
	
	// delegate
	
	SC_SET_ATTRIBUTES_AS_LOCALIZED_STRING(searchBar, dict, text);
	SC_SET_ATTRIBUTES_AS_LOCALIZED_STRING(searchBar, dict, prompt);
	SC_SET_ATTRIBUTES_AS_LOCALIZED_STRING(searchBar, dict, placeholder);
	
#if !TARGET_OS_TV
	SC_SET_ATTRIBUTES_AS_BOOL(searchBar, dict, showsBookmarkButton);
	SC_SET_ATTRIBUTES_AS_BOOL(searchBar, dict, showsCancelButton);
	SC_SET_ATTRIBUTES_AS_BOOL(searchBar, dict, showsSearchResultsButton);
	SC_SET_ATTRIBUTES_AS_BOOL(searchBar, dict, searchResultsButtonSelected);
#endif
	
	SC_SET_ATTRIBUTES_AS_UICOLOR(searchBar, dict, tintColor);
	
	SC_SET_ATTRIBUTES_AS_BOOL(searchBar, dict, translucent);
	
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
		NSString * s;
		SC_FOR_EACH(s, scopeButtonTitles) {
			s = SCLocalizedString(s, nil);
			NSAssert([s isKindOfClass:[NSString class]], @"error: %@ in %@", s, scopeButtonTitles);
			if (s) {
				[a addObject:s];
			}
		}
		searchBar.scopeButtonTitles = a;
		[a release];
	}
	
	SC_SET_ATTRIBUTES_AS_INTEGER(searchBar, dict, selectedScopeButtonIndex);
	SC_SET_ATTRIBUTES_AS_BOOL(searchBar, dict, showsScopeBar);
	
	// inputAccessoryView
	NSDictionary * inputAccessoryView = [dict objectForKey:@"inputAccessoryView"];
	if (inputAccessoryView) {
		SC_UIKIT_DIG_CREATION_INFO(inputAccessoryView); // support ObjectFromFile
		SCView * view = [SCView create:inputAccessoryView];
		NSAssert([view isKindOfClass:[UIView class]], @"inputAccessoryView's definition error: %@", inputAccessoryView);
		searchBar.inputAccessoryView = view;
		SC_UIKIT_SET_ATTRIBUTES(view, SCView, inputAccessoryView);
	}
	
	SC_SET_ATTRIBUTES_AS_UIIMAGE(searchBar, dict, backgroundImage);
	SC_SET_ATTRIBUTES_AS_UIIMAGE(searchBar, dict, scopeBarBackgroundImage);
	
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
