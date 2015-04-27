//
//  SCPickerView.m
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCNib.h"
#import "SCEventHandler.h"
#import "SCPickerViewDataSource.h"
#import "SCPickerViewDelegate.h"
#import "SCPickerView.h"

@interface SCPickerView ()

@property(nonatomic, retain) SCPickerViewDataSource * pickerViewDataSource;
@property(nonatomic, retain) SCPickerViewDelegate * pickerViewDelegate;

@end

@implementation SCPickerView

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib
@synthesize pickerViewDataSource = _pickerViewDataSource;
@synthesize pickerViewDelegate = _pickerViewDelegate;

- (void) dealloc
{
	[_pickerViewDataSource release];
	[_pickerViewDelegate release];
	[_nodeFile release];
	
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCPickerView
{
	_scTag = 0;
	self.nodeFile = nil;
	self.pickerViewDataSource = nil;
	self.pickerViewDelegate = nil;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCPickerView];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeSCPickerView];
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
		self.pickerViewDataSource = [SCPickerViewDataSource create:dataSource];
		// self.dataSource only assign but won't retain the data delegate,
		// so don't release it now
		self.dataSource = _pickerViewDataSource;
	}
	
	NSDictionary * delegate = [dict objectForKey:@"delegate"];
	if (delegate) {
		self.pickerViewDelegate = [SCPickerViewDelegate create:delegate];
		// self.delegate only assign but won't retain the action delegate,
		// so don't release it now
		self.delegate = _pickerViewDelegate;
	}
	
	// support using the SAME ONE data handler to service the data source and delegate
	if (_pickerViewDelegate.handler == nil) {
		_pickerViewDelegate.handler = _pickerViewDataSource.handler;
	} else if (_pickerViewDataSource.handler == nil) {
		_pickerViewDataSource.handler = _pickerViewDelegate.handler;
	}
}

// awakeFromNib
SC_UIKIT_IMPLEMENT_AWAKE_FUNCTION()

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIPickerView *)pickerView
{
	if (![SCView setAttributes:dict to:pickerView]) {
		return NO;
	}
	
	// showsSelectionIndicator
	id showsSelectionIndicator = [dict objectForKey:@"showsSelectionIndicator"];
	if (showsSelectionIndicator) {
		pickerView.showsSelectionIndicator = [showsSelectionIndicator boolValue];
	}
	
	return YES;
}

#pragma mark - Picker View Interfaces

- (void) didSelectRow:(NSInteger)rowIndex inComponent:(NSInteger)componentIndex
{
	SCLog(@"select row: %d, component: %d", (int)rowIndex, (int)componentIndex);
	[self onSelect:self];
}

- (void) onSelect:(id)sender
{
	SCLog(@"onSelect: %@", sender);
	SCDoEvent(@"onSelect", sender);
}

@end
