//
//  SCPickerViewDelegate.m
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCAttributedString.h"
#import "SCPickerView.h"
#import "SCPickerViewDelegate.h"

@implementation SCPickerViewDelegate

@synthesize handler = _handler;

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

- (void) dealloc
{
	[_handler release];
	
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		self.handler = nil;
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	self = [self init];
	if (self) {
		// set data handler
		NSDictionary * handler = [dict objectForKey:@"handler"];
		if (handler) {
			[handler retain];
		} else {
			NSString * filename = [dict objectForKey:@"File"];
			if (filename) {
				handler = [[NSDictionary alloc] initWithObjectsAndKeys:filename, @"File", nil];
			}
		}
		if (handler) {
			SCPickerViewDataHandler * pvdh = [SCPickerViewDataHandler create:handler autorelease:NO];
			NSAssert([pvdh isKindOfClass:[SCPickerViewDataHandler class]], @"handler's definition error: %@", handler);
			self.handler = pvdh;
			[pvdh release];
			
			[handler release];
		}
	}
	return self;
}

- (void) reloadData:(UIPickerView *)pickerView
{
	NSAssert(_handler, @"there must be a handler");
	[_handler reloadData:pickerView];
}

#pragma mark - UIPickerViewDelegate

////@optional
//
//// returns width of column and height of row for each component.
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component;
//- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component;

// these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
// If you return back a different object, the old one will be released. the view will be centered in the row rect
- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)rowIndex forComponent:(NSInteger)componentIndex
{
	NSAssert(_handler, @"there must be a handler");
	
	// return title for row
	NSDictionary * row = [_handler rowAtIndex:rowIndex componentIndex:componentIndex];
	NSString * title = [row objectForKey:@"title"];
	
	NSAssert(title, @"no title found at row(%d, %d): %@", (int)componentIndex, (int)rowIndex, row);
	return title;
}

// attributed title is favored if both methods are implemented
- (NSAttributedString *) pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)rowIndex forComponent:(NSInteger)componentIndex NS_AVAILABLE_IOS(6_0)
{
	NSAssert(_handler, @"there must be a handler");
	
	// return title for row
	NSDictionary * row = [_handler rowAtIndex:rowIndex componentIndex:componentIndex];
	NSDictionary * attributedTitle = [row objectForKey:@"attributedTitle"];
	if (attributedTitle) {
		SCAttributedString * as = [SCAttributedString create:attributedTitle];
		NSAssert([as isKindOfClass:[NSAttributedString class]], @"error attributed title: %@", attributedTitle);
		return as;
	}
	
	return nil;
}

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if ([pickerView isKindOfClass:[SCPickerView class]]) {
		[(SCPickerView *)pickerView didSelectRow:row inComponent:component];
	}
}

@end
