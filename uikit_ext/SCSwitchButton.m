//
//  SCSwitchButton.m
//  SnowCat
//
//  Created by Moky on 14-10-22.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "SCEventHandler.h"
#import "SCSwitchButton.h"

@implementation SCSwitchButton

- (void) setSelected:(BOOL)selected
{
	if (selected != self.selected) {
		// value changed, fire event
		NSString * eventName = selected ? @"onSwitchOn" : @"onSwitchOff";
		SCDoEvent(eventName, self);
	}
	[super setSelected:selected];
}

- (void) onClick:(id)sender
{
	self.selected = !self.selected;
	[super onClick:sender];
}

@end
