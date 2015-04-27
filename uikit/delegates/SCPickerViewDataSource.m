//
//  SCPickerViewDataSource.m
//  SnowCat
//
//  Created by Moky on 14-4-1.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCPickerViewDataSource.h"

@implementation SCPickerViewDataSource

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

#pragma mark - UIPickerViewDataSource

//@required

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	NSAssert(_handler, @"there must be a handler");
	return [_handler numberOfComponents];
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	NSAssert(_handler, @"there must be a handler");
	return [_handler numberOfRowsInComponent:component];
}

@end
