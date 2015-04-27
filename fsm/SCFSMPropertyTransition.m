//
//  SCFSMPropertyTransition.m
//  SnowCat
//
//  Created by Moky on 14-12-14.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCFSMPropertyMachine.h"
#import "SCFSMPropertyTransition.h"

@implementation SCFSMPropertyTransition

@synthesize propertyName = _propertyName;
@synthesize propertyValue = _propertyValue;
@synthesize compareType = _compareType;

- (void) dealloc
{
	[_propertyName release];
	[_propertyValue release];
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		[_propertyName release];
		_propertyName = nil;
		
		[_propertyValue release];
		_propertyValue = nil;
		
		_compareType = SCFSMPropertyTransitionCompareTypeEqual;
	}
	return self;
}

- (instancetype) initWithTargetStateName:(NSString *)name propertyName:(NSString *)key propertyValue:(id)value
{
	self = [self initWithTargetStateName:name];
	if (self) {
		self.propertyName = key;
		self.propertyValue = value;
	}
	return self;
}

- (instancetype) initWithTargetStateName:(NSString *)name propertyName:(NSString *)key propertyValue:(id)value compareType:(SCFSMPropertyTransitionCompareType)type
{
	self = [self initWithTargetStateName:name propertyName:key propertyValue:value];
	if (self) {
		self.compareType = type;
	}
	return self;
}

- (BOOL) evaluate:(SCFSMMachine *)machine
{
	SCFSMPropertyMachine * fsm = (SCFSMPropertyMachine *)machine;
	if (![fsm isKindOfClass:[SCFSMPropertyMachine class]]) {
		NSAssert(false, @"cannot evaluate a property transition on a non-property machine");
		return NO;
	}
	id object = [fsm propertyForKey:_propertyName];
	
	switch (_compareType) {
		case SCFSMPropertyTransitionCompareTypeEqual:
			return [object compare:_propertyValue] == NSOrderedSame;
			break;
			
		case SCFSMPropertyTransitionCompareTypeNotEqual:
			return [object compare:_propertyValue] != NSOrderedSame;
			break;
			
		case SCFSMPropertyTransitionCompareTypeGreater:
			return [object compare:_propertyValue] > NSOrderedSame;
			break;
			
		case SCFSMPropertyTransitionCompareTypeLower:
			return [object compare:_propertyValue] < NSOrderedSame;
			break;
			
		case SCFSMPropertyTransitionCompareTypeGreaterOrEqual:
			return [object compare:_propertyValue] >= NSOrderedSame;
			break;
			
		case SCFSMPropertyTransitionCompareTypeLowerOrEqual:
			return [object compare:_propertyValue] <= NSOrderedSame;
			break;
			
		default:
			NSAssert(false, @"unknown compare type: %u", (unsigned int)_compareType);
			break;
	}
	return NO;
}

@end
