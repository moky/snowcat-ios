//
//  SCScrollRefreshView+State.m
//  SnowCat
//
//  Created by Moky on 15-1-19.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCFSMProtocol.h"
#import "SCEventHandler.h"
#import "SCScrollRefreshView.h"

@implementation SCScrollRefreshView (State)

- (void) machine:(SCFSMMachine *)machine enterState:(SCFSMState *)state
{
	[super machine:machine enterState:state];
	
	NSString * event = nil;
	
	UIScrollRefreshControlState * srcs = (UIScrollRefreshControlState *)state;
	NSAssert([srcs isKindOfClass:[UIScrollRefreshControlState class]], @"error state: %@", state);
	
	switch (srcs.state) {
		case UIScrollRefreshControlStateDefault:
			event = @"onHide";
			break;
			
		case UIScrollRefreshControlStateVisible:
			event = @"onShow";
			break;
			
		case UIScrollRefreshControlStateWillRefresh:
			event = @"onHint";
			break;
			
		case UIScrollRefreshControlStateRefreshing:
			event = @"onRefresh";
			break;
			
		case UIScrollRefreshControlStateTerminated:
			event = @"onEnd";
			break;
			
		default:
			event = @"onError";
			break;
	}
	
	SCLog(@"%@: %@", event, self);
	SCDoEvent(event, self);
}

@end
