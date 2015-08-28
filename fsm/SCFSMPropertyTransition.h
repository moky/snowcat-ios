//
//  SCFSMPropertyTransition.h
//  SnowCat
//
//  Created by Moky on 14-12-14.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "SCFSMProtocol.h"

typedef NS_ENUM(NSUInteger, SCFSMPropertyTransitionCompareType) {
	SCFSMPropertyTransitionCompareTypeEqual,
	SCFSMPropertyTransitionCompareTypeNotEqual,
	SCFSMPropertyTransitionCompareTypeGreater,
	SCFSMPropertyTransitionCompareTypeLower,
	SCFSMPropertyTransitionCompareTypeGreaterOrEqual,
	SCFSMPropertyTransitionCompareTypeLowerOrEqual,
	//SCFSMPropertyTransitionCompareTypeFunctionCompare,
};

@interface SCFSMPropertyTransition : SCFSMTransition

@property(nonatomic, retain) NSString * propertyName;
@property(nonatomic, retain) id propertyValue;
@property(nonatomic, readwrite) SCFSMPropertyTransitionCompareType compareType; // default is SCFSMPropertyTransitionCompareTypeEqual

- (instancetype) initWithTargetStateName:(NSString *)name
							propertyName:(NSString *)key
						   propertyValue:(id)value;

- (instancetype) initWithTargetStateName:(NSString *)name
							propertyName:(NSString *)key
						   propertyValue:(id)value
							 compareType:(SCFSMPropertyTransitionCompareType)type;

@end
