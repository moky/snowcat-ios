//
//  SCPageScrollViewDataSource.m
//  SnowCat
//
//  Created by Moky on 14-7-6.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCNodeFileParser.h"
#import "SCDictionary.h"
#import "SCView.h"
#import "SCPageScrollView.h"
#import "SCPageScrollViewDataSource.h"

@interface SCPageScrollViewDataSource ()

@property(nonatomic, retain) NSString * filename;
@property(nonatomic, retain) NSMutableArray * subviews;
@property(nonatomic, retain) NSDictionary * template; // template for creating each subview

@end

@implementation SCPageScrollViewDataSource

@synthesize filename = _filename;
@synthesize subviews = _subviews;
@synthesize template = _template;

- (void) dealloc
{
	[_filename release];
	[_subviews release];
	[_template release];
	
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		self.filename = nil;
		self.subviews = nil;
		self.template = nil;
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	self = [self init];
	if (self) {
		// data file
		NSString * filename = [dict objectForKey:@"File"];
		if (filename) {
			self.filename = filename;
		}
		// subviews
		NSArray * subviews = [dict objectForKey:@"subviews"];
		if (subviews) {
			NSAssert([subviews isKindOfClass:[NSArray class]], @"subviews' definition error: %@", dict);
			[self setData:subviews];
		}
		// template
		NSDictionary * template = [dict objectForKey:@"template"];
		if (template) {
			NSAssert([template isKindOfClass:[NSDictionary class]], @"template's definition error: %@", dict);
			self.template = template;
		}
	}
	return self;
}

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

- (void) setData:(NSArray *)array
{
	NSAssert([array isKindOfClass:[NSArray class]], @"data error: %@", array);
	NSMutableArray * mArray = [array mutableCopy];
	self.subviews = mArray;
	[mArray release];
}

- (void) reloadData:(UIPageScrollView *)pageScrollView
{
	if (!_filename) {
		//NSAssert([_subviews isKindOfClass:[NSMutableArray class]], @"no data");
		return;
	}
	
	SCNodeFileParser * parser = [SCNodeFileParser parser:_filename];
	NSDictionary * node = [parser node];
	NSAssert([node isKindOfClass:[NSDictionary class]], @"node file data error: %@", _filename);
	
	// subviews
	NSArray * subviews = [node objectForKey:@"subviews"];
	if (!subviews) {
		subviews = [node objectForKey:@"rows"];
	}
	if (subviews) {
		NSAssert([subviews isKindOfClass:[NSArray class]], @"data file error: %@", _filename);
		[self setData:subviews];
	}
	
	// template
	NSDictionary * template = [node objectForKey:@"template"];
	if (!template) {
		template = [[node objectForKey:@"templates"] objectForKey:@"cell"];
	}
	if (template) {
		NSAssert([template isKindOfClass:[NSDictionary class]], @"data file error: %@", _filename);
		self.template = template;
	}
}

#pragma mark -

- (UIScrollView *) _scrollViewInPageScrollView:(UIView *)pageScrollView
{
	NSEnumerator * enumerator = [pageScrollView.subviews objectEnumerator];
	UIScrollView * scrollView;
	while (scrollView = [enumerator nextObject]) {
		if ([scrollView isKindOfClass:[UIScrollView class]]) {
			return scrollView;
		}
	}
	NSAssert(false, @"cannot find inner scroll view: %@", pageScrollView);
	return nil;
}

- (UIView *) _buildSubview:(NSDictionary *)dict atIndex:(NSUInteger)index withPageScrollView:(UIView *)pageScrollView
{
	if (_template && ![dict objectForKey:@"Class"]) {
		// when the item includes 'Class', means it is a UIView's definition,
		// not just a key-value data,
		// so we create it directly, no need replacing.
		dict = [SCDictionary replaceDictionary:_template withData:dict];
	}
	SCView * view = [SCView create:dict];
	NSAssert([view isKindOfClass:[UIView class]], @"subview's definition error: %@", dict);
	if (view) {
		[dict retain];
		[_subviews replaceObjectAtIndex:index withObject:view];
		
		// add this view to parent view before setting attribute,
		// so it can get variables from parent such as 'size', 'center', ...
		UIScrollView * scrollView = [self _scrollViewInPageScrollView:pageScrollView];
		[scrollView addSubview:view];
		SC_UIKIT_SET_ATTRIBUTES(view, SCView, dict);
		[view removeFromSuperview];
		
		[dict release];
	}
	return view;
}

- (UIView *) _subviewAtIndex:(NSUInteger)index withPageScrollView:(UIView *)pageScrollView
{
	if (index >= [_subviews count]) {
		//NSAssert(false, @"error index: %d, count: %d", index, [_subviews count]);
		return nil;
	}
	
	UIView * view = [_subviews objectAtIndex:index];
	if ([view isKindOfClass:[UIView class]]) {
		return view;
	}
	NSAssert([view isKindOfClass:[NSDictionary class]], @"subview's definition must be a dictionary: %@", view);
	return [self _buildSubview:(NSDictionary *)view atIndex:index withPageScrollView:pageScrollView];
}

- (void) _resizeView:(UIView *)view withFrame:(CGRect)frame
{
	if (frame.size.width <= 0 || frame.size.height <= 0) {
		NSAssert(false, @"frame error: %@", NSStringFromCGRect(frame));
		return;
	}
	CGRect bounds = view.bounds;
	CGFloat rw = bounds.size.width / frame.size.width;
	CGFloat rh = bounds.size.height / frame.size.height;
	CGFloat r = MAX(rw, rh);
	if (r <= 1) {
		return;
	}
	bounds.size.width /= r;
	bounds.size.height /= r;
	view.bounds = bounds;
}

#pragma mark - SCPageScrollViewDataSource

- (NSUInteger) presentationCountForPageScrollView:(UIPageScrollView *)pageScrollView
{
	return [_subviews count];
}

- (UIView *) pageScrollView:(UIPageScrollView *)pageScrollView viewAtIndex:(NSUInteger)index
{
	UIView * view = [self _subviewAtIndex:index withPageScrollView:pageScrollView];
	[self _resizeView:view withFrame:pageScrollView.bounds];
	return view;
}

- (UIView *) pageScrollView:(UIPageScrollView *)pageScrollView viewBeforeView:(UIView *)view
{
	NSUInteger index = view ? [_subviews indexOfObject:view] : NSNotFound;
	NSUInteger count = [_subviews count];
	if (index == NSNotFound || count == 0) {
		NSAssert(false, @"error: %@", view);
		return nil;
	}
	if (index == 0) {
		index = count - 1;
	} else {
		index = index - 1;
	}
	return [self pageScrollView:pageScrollView viewAtIndex:index];
}

- (UIView *) pageScrollView:(UIPageScrollView *)pageScrollView viewAfterView:(UIView *)view
{
	NSUInteger index = view ? [_subviews indexOfObject:view] : NSNotFound;
	NSUInteger count = [_subviews count];
	if (index == NSNotFound || count == 0) {
		NSAssert(false, @"error: %@", view);
		return nil;
	}
	if (++index == count) {
		index = 0;
	}
	return [self pageScrollView:pageScrollView viewAtIndex:index];
}

@end
