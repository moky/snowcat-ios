//
//  SCScrollRefreshView+State.m
//  SnowCat
//
//  Created by Moky on 15-1-19.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCDate+Extension.h"
#import "SCEventHandler.h"
#import "SCScrollRefreshView.h"

@implementation UIScrollRefreshView (State)

- (void) machine:(SCFSMMachine *)machine enterState:(SCFSMState *)state
{
	[super machine:machine enterState:state];
	
	SCScrollRefreshControlState * srcs = (SCScrollRefreshControlState *)state;
	NSAssert([srcs isKindOfClass:[SCScrollRefreshControlState class]], @"error state: %@", state);
	
	switch (srcs.state) {
		case UIScrollRefreshControlStateDefault:
			// DON'T set text lable here, set in 'exitState'
			// because the state machine will enter default state immediately when start,
			// but we don't hope to create subviews in that moment
			break;
			
		case UIScrollRefreshControlStateVisible:
			self.textLabel.text = self.visibleText;
			break;
			
		case UIScrollRefreshControlStateWillRefresh:
			self.textLabel.text = self.willRefreshText;
			break;
			
		case UIScrollRefreshControlStateRefreshing:
			self.textLabel.text = self.refreshingText;
			self.loading = YES;
			break;
			
		default:
			NSAssert(false, @"error");
			break;
	}
	
	[self setNeedsLayout];
}

- (void) machine:(SCFSMMachine *)machine exitState:(SCFSMState *)state
{
	SCScrollRefreshControlState * srcs = (SCScrollRefreshControlState *)state;
	NSAssert([srcs isKindOfClass:[SCScrollRefreshControlState class]], @"error state: %@", state);
	
	switch (srcs.state) {
		case UIScrollRefreshControlStateDefault:
		{
			NSDate * time = self.updatedTime;
			if (time) {
				NSString * format = self.updatedTimeFormat;
				NSString * str = format ? [time stringWithFormat:format] : [time humanReadableString];
				self.timeLabel.text = [NSString stringWithFormat:@"%@: %@", self.updatedText, str];
			}
		}
			break;
			
		case UIScrollRefreshControlStateVisible:
			self.textLabel.text = nil;
			break;
			
		case UIScrollRefreshControlStateWillRefresh:
			self.textLabel.text = nil;
			break;
			
		case UIScrollRefreshControlStateRefreshing:
			self.textLabel.text = nil;
			self.loading = NO;
			break;
			
		default:
			NSAssert(false, @"error");
			break;
	}
	
	[super machine:machine exitState:state];
}

- (void) layoutSubviews
{
	[super layoutSubviews];
	[self _layoutSubviews];
}

- (void) _layoutSubviews
{
	UIView * tray = [self trayView];
	CGRect bounds = tray.bounds;
	
	UIActivityIndicatorView * indicator = [self loadingIndicator];
	UILabel * textLabel = [self textLabel];
	UILabel * timeLabel = [self timeLabel];
	
	[textLabel sizeToFit];
	[timeLabel sizeToFit];
	
	CGRect frame1 = indicator.frame;
	CGRect frame2 = textLabel.frame;
	CGRect frame3 = timeLabel.frame;
	
	switch (self.direction) {
		case UIScrollRefreshControlDirectionTop:
		{
			CGFloat right = MAX(frame2.size.width, frame3.size.width);
			
			indicator.center = CGPointMake((bounds.size.width - right) * 0.5f,
										   bounds.size.height * 0.5f);
			
			textLabel.center = CGPointMake(indicator.center.x + (frame1.size.width + frame2.size.width) * 0.5f,
										   indicator.center.y + frame2.size.height * 0.5f);
			
			timeLabel.center = CGPointMake(indicator.center.x + (frame1.size.width + frame3.size.width) * 0.5f,
										   indicator.center.y - frame3.size.height * 0.5f);
		}
			break;
			
		case UIScrollRefreshControlDirectionBottom:
		{
			CGFloat right = MAX(frame2.size.width, frame3.size.width);
			
			indicator.center = CGPointMake((bounds.size.width - right) * 0.5f,
										   bounds.size.height * 0.5f);
			
			textLabel.center = CGPointMake(indicator.center.x + (frame1.size.width + frame2.size.width) * 0.5f,
										   indicator.center.y - frame2.size.height * 0.5f);
			
			timeLabel.center = CGPointMake(indicator.center.x + (frame1.size.width + frame3.size.width) * 0.5f,
										   indicator.center.y + frame3.size.height * 0.5f);
		}
			break;
			
		case UIScrollRefreshControlDirectionLeft:
		{
			CGFloat down = MAX(frame2.size.height, frame3.size.height);
			
			indicator.center = CGPointMake(bounds.size.width * 0.5f,
										   (bounds.size.height - down) * 0.5f);
			
			textLabel.center = CGPointMake(indicator.center.x + frame2.size.width * 0.5f,
										   indicator.center.y + (frame1.size.height + frame2.size.height) * 0.5f);
			
			timeLabel.center = CGPointMake(indicator.center.x - frame3.size.width * 0.5f,
										   indicator.center.y + (frame1.size.height + frame3.size.height) * 0.5f);
		}
			break;
			
		case UIScrollRefreshControlDirectionRight:
		{
			CGFloat down = MAX(frame2.size.height, frame3.size.height);
			
			indicator.center = CGPointMake(bounds.size.width * 0.5f,
										   (bounds.size.height - down) * 0.5f);
			
			textLabel.center = CGPointMake(indicator.center.x - frame2.size.width * 0.5f,
										   indicator.center.y + (frame1.size.height + frame2.size.height) * 0.5f);
			
			timeLabel.center = CGPointMake(indicator.center.x + frame3.size.width * 0.5f,
										   indicator.center.y + (frame1.size.height + frame3.size.height) * 0.5f);
		}
			break;
			
		default:
			break;
	}
}

@end

@implementation SCScrollRefreshView (State)

- (void) machine:(SCFSMMachine *)machine enterState:(SCFSMState *)state
{
	[super machine:machine enterState:state];
	
	NSString * event = nil;
	
	SCScrollRefreshControlState * srcs = (SCScrollRefreshControlState *)state;
	NSAssert([srcs isKindOfClass:[SCScrollRefreshControlState class]], @"error state: %@", state);
	
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
			
		default:
			event = @"onError";
			break;
	}
	
	SCLog(@"%@: %@", event, self);
	SCDoEvent(event, self);
}

@end
