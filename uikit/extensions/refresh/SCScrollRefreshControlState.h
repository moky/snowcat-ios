//
//  SCScrollRefreshControlState.h
//  SnowCat
//
//  Created by Moky on 15-1-9.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

#import "SCFSMState.h"
#import "SCFSMMachine.h"

typedef NS_ENUM(NSUInteger, UIScrollRefreshControlState) {
	UIScrollRefreshControlStateDefault,     // default state is hidden
	UIScrollRefreshControlStateVisible,     // pull to visible but cannot refresh yet
	UIScrollRefreshControlStateWillRefresh, // dragging distance enough to refresh, but still dragging
	UIScrollRefreshControlStateRefreshing,  // refreshing after drag end
};

@interface SCScrollRefreshControlState : SCFSMState

@property(nonatomic, readonly) UIScrollRefreshControlState state;

- (instancetype) initWithState:(UIScrollRefreshControlState)state;

@end

#pragma mark -

@interface SCScrollRefreshControlStateMachine : SCFSMMachine

// the size of refresh control, minimum size to show all subviews
@property(nonatomic, readwrite) CGFloat controlDimension;
// the current offset
@property(nonatomic, readwrite) CGFloat controlOffset;

// while pulling begin, set it TRUE; after pulling end, set it FALSE
@property(nonatomic, readwrite, getter=isPulling) BOOL pulling;
// while data loaded, set it TRUE; after read, set it FALSE automactilly
@property(nonatomic, readwrite, getter=isDataLoaded) BOOL dataLoaded;

@end

// state names
UIKIT_EXTERN NSString * const kUIScrollRefreshControlStateNameDefault;
UIKIT_EXTERN NSString * const kUIScrollRefreshControlStateNameVisible;
UIKIT_EXTERN NSString * const kUIScrollRefreshControlStateNameWillRefresh;
UIKIT_EXTERN NSString * const kUIScrollRefreshControlStateNameRefreshing;
