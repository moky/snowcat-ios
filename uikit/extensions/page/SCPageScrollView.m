//
//  SCPageScrollView.m
//  SnowCat
//
//  Created by Moky on 14-3-29.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCNib.h"
#import "SCEventHandler.h"
#import "SCScrollView.h"
#import "SCPageControl.h"
#import "SCPageScrollViewDataSource.h"
#import "SCPageScrollView.h"

//typedef NS_ENUM(NSInteger, SCPageScrollViewScrollDirection) {
//	UIPageScrollViewDirectionVertical,
//	UIPageScrollViewDirectionHorizontal,
//};
UIPageScrollViewDirection UIPageScrollViewDirectionFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Vertical")
			return UIPageScrollViewDirectionVertical;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return UIPageScrollViewDirectionHorizontal;
}

@interface UIPageScrollView ()

@property(nonatomic, retain) UIScrollView * scrollView;

@end

@implementation UIPageScrollView

@synthesize dataSource = _dataSource;

@synthesize direction = _direction;
@synthesize pageCount = _pageCount;
@synthesize currentPage = _currentPage;

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;

@synthesize animated = _animated;

@synthesize preloadedPageCount = _preloadedPageCount;

- (void) dealloc
{
	if (_scrollView.delegate == self) {
		// must remove the delegate here, otherwise it will cause crash
		// when the scroll view is running animation.
		_scrollView.delegate = nil;
	}
	[_scrollView release];
	
	[_pageControl release];
	
	[super dealloc];
}

- (void) _initializeUIPageScrollView
{
	self.clipsToBounds = YES; // use the container view to clips, instead of the inner scroll view
	
	self.dataSource = nil;
	
	_direction = UIPageScrollViewDirectionHorizontal;
	_pageCount = 0;
	_currentPage = 0;
	
	// page control
	self.pageControl = nil;
	
	_animated = NO;
	
	_preloadedPageCount = 1;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeUIPageScrollView];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeUIPageScrollView];
	}
	return self;
}

// lazy-load
- (UIScrollView *) scrollView
{
	if (!_scrollView) {
		// create an empty scroll view
		_scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
		// default properties
		_scrollView.pagingEnabled = YES;
		_scrollView.directionalLockEnabled = YES;
		_scrollView.showsHorizontalScrollIndicator = NO;
		_scrollView.showsVerticalScrollIndicator = NO;
		_scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_scrollView.clipsToBounds = NO; // scroll view's default value is YES, here it's always NO
		_scrollView.delegate = self; // rob the controlling from the scroll view
		[super addSubview:_scrollView];
	}
	return _scrollView;
}

// while the frame/bounds or page count change
// we should call this function to recalculate the content size
- (void) _adjustContentSize
{
	UIScrollView * scrollView = self.scrollView;
	// set content size of scroll view
	CGSize size = self.bounds.size;
	
	if (_direction == UIPageScrollViewDirectionHorizontal)
	{
		scrollView.contentSize = CGSizeMake(size.width * _pageCount, size.height);
		scrollView.contentOffset = CGPointMake(size.width * _currentPage, 0);
	}
	else // UIPageScrollViewDirectionVertical
	{
		scrollView.contentSize = CGSizeMake(size.width, size.height * _pageCount);
		scrollView.contentOffset = CGPointMake(0, size.height * _currentPage);
	}
}

// change the page count, and resize the content size
- (void) setPageCount:(NSUInteger)pageCount
{
	_pageCount = pageCount;
	_pageControl.numberOfPages = pageCount;
	
	[self _adjustContentSize];
}

// change the current page, and pre-load next page
- (void) setCurrentPage:(NSUInteger)page
{
	[self _showSubviewToIndex:page + _preloadedPageCount]; // pre-load next views
	
	UIScrollView * scrollView = self.scrollView;
	CGSize size = scrollView.bounds.size;
	
	//NSAssert(page < _pageCount, @"error page: %d, count: %d", page, _pageCount);
	CGPoint offset = (_direction == UIPageScrollViewDirectionHorizontal) ?
					CGPointMake(page * size.width, 0) :
					CGPointMake(0, page * size.height);
	
	if (_animated) {
		[scrollView setContentOffset:offset animated:YES];
	} else {
		scrollView.contentOffset = offset;
	}
	
	if (_currentPage == page) {
		// not change
		return;
	}
	
	// update
	_currentPage = page;
	_pageControl.currentPage = page;
}

- (void) layoutSubviews
{
	[super layoutSubviews];
	
	self.scrollView.frame = self.bounds;
	
	[self _adjustContentSize];
	[self setCurrentPage:_currentPage]; // for adjusting the scroll view's content offset
}

- (CGSize) contentSize
{
	return self.scrollView.contentSize;
}

- (void) setContentSize:(CGSize)contentSize
{
	self.scrollView.contentSize = contentSize;
}

- (void) addSubview:(UIView *)view
{
	NSAssert([_scrollView isKindOfClass:[UIScrollView class]], @"inner scroll view error: %@", _scrollView);
	[self.scrollView addSubview:view];
}

// lazy load subviews
- (void) _showSubviewToIndex:(NSUInteger)index
{
	NSUInteger last = [self.scrollView.subviews count];
	if (last >= _pageCount) {
		// all subviews have been shown
		return;
	}
	
	for (; last <= index; ++last) {
		SCLog(@"last: %u, index: %u, count: %u", (unsigned int)last, (unsigned int)index, (unsigned int)_pageCount);
		[self showSubviewAtIndex:last];
	}
}

- (UIView *) showSubviewAtIndex:(NSUInteger)index
{
	UIView * view = [_dataSource pageScrollView:self viewAtIndex:index];
	CGSize size = self.bounds.size;
	
	if (_direction == UIPageScrollViewDirectionHorizontal)
	{
		view.center = CGPointMake(size.width * (index + 0.5), size.height * 0.5);
	}
	else // UIPageScrollViewDirectionVertical
	{
		view.center = CGPointMake(size.width * 0.5, size.height * (index + 0.5));
	}
	
	[self addSubview:view];
	return view;
}

- (void) reloadData
{
	NSAssert(_dataSource, @"there must be a data source");
	// clear
	NSArray * subviews = self.scrollView.subviews;
	NSInteger index = [subviews count];
	while (--index >= 0) {
		[[subviews objectAtIndex:index] removeFromSuperview];
	}
	
	// refresh data source
	[_dataSource reloadData:self];
	
	// page count
	[self setPageCount:[_dataSource presentationCountForPageScrollView:self]];
	
	// show first subview
	[self setCurrentPage:0];
}

- (void) scrollToNextPage
{
	NSUInteger page = _currentPage + 1;
	if (page >= _pageCount) {
		BOOL animated = _animated;
		_animated = NO;
		self.currentPage = 0;
		_animated = animated;
	} else {
		self.currentPage = page;
	}
}

#pragma mark - UIScrollViewDelegate

// any offset changes, perform cover flow effect
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (_direction == UIPageScrollViewDirectionHorizontal)
	{
		scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
	}
	else // UIPageScrollViewDirectionVertical
	{
		scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
	}
}

// called when scroll view grinds to a halt
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	CGSize size = scrollView.frame.size;
	CGPoint offset = scrollView.contentOffset;
	
	NSUInteger page = (_direction == UIPageScrollViewDirectionHorizontal) ?
					(size.width > 0 ? round(offset.x / size.width) : 0) :
					(size.height > 0 ? round(offset.y / size.height) : 0);
	
	[self setCurrentPage:page];
}

@end

#pragma mark -

@interface SCPageScrollView ()

@property(nonatomic, retain) id<UIPageScrollViewDataSource> pageScrollViewDataSource;

@end

@implementation SCPageScrollView

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib

@synthesize pageScrollViewDataSource = _pageScrollViewDataSource;

- (void) dealloc
{
	[_pageScrollViewDataSource release];
	
	[_nodeFile release];
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCPageScrollView
{
	_scTag = 0;
	self.nodeFile = nil;
	
	self.pageScrollViewDataSource = nil;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCPageScrollView];
	}
	return self;
}

// default initializer
- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeSCPageScrollView];
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
	
	NSDictionary * dataSource = [dict objectForKey:@"dataSource"];
	if (dataSource) {
		self.pageScrollViewDataSource = [SCPageScrollViewDataSource create:dataSource];
		// self.dataSource only assign but won't retain the data delegate,
		// so don't release it now
		self.dataSource = _pageScrollViewDataSource;
	}
}

// awakeFromNib
SC_UIKIT_IMPLEMENT_AWAKE_FUNCTION()

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIPageScrollView *)pageScrollView
{
	if (![SCView setAttributes:dict to:pageScrollView]) {
		return NO;
	}
	
	// page control view
	NSDictionary * pageControl = [dict objectForKey:@"pageControl"];
	if (pageControl) {
		SC_UIKIT_DIG_CREATION_INFO(pageControl); // support ObjectFromFile
		SCPageControl * pc = [SCPageControl create:pageControl autorelease:NO];
		NSAssert([pc isKindOfClass:[UIPageControl class]], @"pageControl's definition error: %@", pageControl);
		if (pc) {
			//[pageScrollView addSubview:pc];
			[pageScrollView insertSubview:pc aboveSubview:pageScrollView.scrollView];
			
			pc.userInteractionEnabled = NO;
			SC_UIKIT_SET_ATTRIBUTES(pc, SCPageControl, pageControl);
			pageScrollView.pageControl = pc;
			[pc release];
		}
	}
	
	// direction
	NSString * direction = [dict objectForKey:@"direction"];
	if (direction) {
		pageScrollView.direction = UIPageScrollViewDirectionFromString(direction);
	}
	
	// animated
	id animated = [dict objectForKey:@"animated"];
	if (animated) {
		pageScrollView.animated = [animated boolValue];
	}
	
	// preloadedPageCount
	id preloadedPageCount = [dict objectForKey:@"preloadedPageCount"];
	if (preloadedPageCount) {
		pageScrollView.preloadedPageCount = [preloadedPageCount integerValue];
	}
	
	// load data
	[pageScrollView reloadData];
	
	return YES;
}

- (void) setCurrentPage:(NSUInteger)currentPage
{
	[super setCurrentPage:currentPage];
	[self onFocus:currentPage];
}

- (void) onFocus:(NSUInteger)page
{
	// onFocus:0
	NSString * event = [[NSString alloc] initWithFormat:@"onFocus:%u", (unsigned int)page];
	//SCLog(@"%@: %@", event, self);
	id<SCEventDelegate> delegate = [SCEventHandler delegateForResponder:self];
	if (delegate) {
		[delegate doEvent:event withResponder:self];
	}
	[event release];
	
	// onFocus
	UIView * view = page < [self.scrollView.subviews count] ? [self.scrollView.subviews objectAtIndex:page] : nil;
	event = @"onFocus";
	//SCLog(@"%@: %@", event, view);
	delegate = [SCEventHandler delegateForResponder:view];
	if (delegate) {
		[delegate doEvent:@"onFocus" withResponder:view];
	}
}

@end
