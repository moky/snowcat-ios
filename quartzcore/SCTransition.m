//
//  SCTransition.m
//  SnowCat
//
//  Created by Moky on 14-3-27.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "scMacros.h"
#import "SCTransition.h"

//CA_EXTERN NSString * const kCAMediaTimingFunctionLinear __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
//CA_EXTERN NSString * const kCAMediaTimingFunctionEaseIn __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
//CA_EXTERN NSString * const kCAMediaTimingFunctionEaseOut __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
//CA_EXTERN NSString * const kCAMediaTimingFunctionEaseInEaseOut __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
//CA_EXTERN NSString * const kCAMediaTimingFunctionDefault __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_3_0);
CAMediaTimingFunction * CAMediaTimingFunctionFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"EaseInOut")
			return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		SC_SWITCH_CASE(string, @"EaseInEaseOut")
			return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		SC_SWITCH_CASE(string, @"EaseIn")
			return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
		SC_SWITCH_CASE(string, @"EaseOut")
			return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
		SC_SWITCH_CASE(string, @"Linear")
			return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
}

//CA_EXTERN NSString * const kCAFillModeForwards __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
//CA_EXTERN NSString * const kCAFillModeBackwards __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
//CA_EXTERN NSString * const kCAFillModeBoth __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
//CA_EXTERN NSString * const kCAFillModeRemoved __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
//CA_EXTERN NSString * const kCAFillModeFrozen CA_DEPRECATED;
NSString * const CAFillModeFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Forward")  // Forwards
			return kCAFillModeForwards;
		SC_SWITCH_CASE(string, @"Backward") // Backwards
			return kCAFillModeBackwards;
		SC_SWITCH_CASE(string, @"Both")
			return kCAFillModeBoth;
		SC_SWITCH_CASE(string, @"Remove")   // Removed
			return kCAFillModeRemoved;
//		SC_SWITCH_CASE(string, @"Froze")    // Frozen
//			return kCAFillModeFrozen;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return string;
}

/* Common transition types. */
//CA_EXTERN NSString * const kCATransitionFade
//__OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
//CA_EXTERN NSString * const kCATransitionMoveIn
//__OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
//CA_EXTERN NSString * const kCATransitionPush
//__OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
//CA_EXTERN NSString * const kCATransitionReveal
//__OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
NSString * const CATransitionTypeFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Fade")
			return kCATransitionFade;
		SC_SWITCH_CASE(string, @"Move") // MoveIn
			return kCATransitionMoveIn;
		SC_SWITCH_CASE(string, @"Push")
			return kCATransitionPush;
		SC_SWITCH_CASE(string, @"Reveal")
			return kCATransitionReveal;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	/**
	 *  From http://iphonedevwiki.net/index.php/CATransition
	 *
	 *  << 官方参数 >>
	 *
	 *  fade         - 交叉淡化过渡(不支持过渡方向)
	 *  push         - 新视图把旧视图推出去
	 *  moveIn       - 新视图移到旧视图上面
	 *  reveal       - 将旧视图移开,显示下面的新视图
	 *
	 *  -----------------------------------
	 *
	 *  << 常用参数 >>
	 *
	 *  pageCurl     - 向上翻页效果
	 *  pageUnCurl   - 向下翻页效果
	 *  rippleEffect - 滴水效果(不支持过渡方向)
	 *  suckEffect   - 收缩效果,如一块布被抽走(不支持过渡方向)
	 *  cube         - 立方体效果
	 *  oglFlip      - 上下左右翻转效果
	 *
	 *  -----------------------------------
	 *
	 *  << 未验证 >>
	 *
	 *  flip
	 *  alignedFlip
	 *  alignedCube
	 *
	 *  cameraIris
	 *  cameraIrisHollowOpen  - 相机镜头打开效果(不支持过渡方向)
	 *  cameraIrisHollowClose - 相机镜头关上效果(不支持过渡方向)
	 *
	 *  rotate                - 旋转效果 (subtype: 90cw/90ccw/180cw/180ccw)
	 *
	 *  << 黑名单 >>
	 *
	 *  spewEffect            - 新版面在屏幕下方中间位置被释放出来覆盖旧版面
	 *  genieEffect           - 旧版面在屏幕左下方或右下方被吸走,显示出下面的新版面(阿拉丁灯神?)
	 *  unGenieEffect         - 新版面在屏幕左下方或右下方被释放出来覆盖旧版面
	 *  twist                 - 版面以水平方向像龙卷风式转出来
	 *  tubey                 - 版面垂直附有弹性的转出来
	 *  swirl                 - 旧版面360度旋转并淡出,显示出新版面
	 *  charminUltra          - 旧版面淡出并显示新版面
	 *  zoomyIn               - 新版面由小放大走到前面,旧版面放大由前面消失
	 *  zoomyOut              - 新版面屏幕外面缩放出现,旧版面缩小消失
	 *  oglApplicationSuspend - 像按"home"按钮的效果
	 *  mapCurl
	 *  mapUnCurl
	 *  charminUltra
	 *  reflection
	 *  cameraIrisHollow
	 */
	return string;
}

/* Common transition subtypes. */
//CA_EXTERN NSString * const kCATransitionFromRight __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
//CA_EXTERN NSString * const kCATransitionFromLeft __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
//CA_EXTERN NSString * const kCATransitionFromTop __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
//CA_EXTERN NSString * const kCATransitionFromBottom __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
NSString * const CATransitionSubtypeFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Right")  // FromRight
			return kCATransitionFromRight;
		SC_SWITCH_CASE(string, @"Left")   // FromLeft
			return kCATransitionFromLeft;
		SC_SWITCH_CASE(string, @"Top")    // FromTop
			return kCATransitionFromTop;
		SC_SWITCH_CASE(string, @"Bottom") // FromBottom
			return kCATransitionFromBottom;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return string;
}

@interface SCTransition ()

@property(nonatomic, retain) CATransition * animation;

@end

@implementation SCTransition

@synthesize animation = _animation;

- (void) dealloc
{
	[_animation release];
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		self.animation = nil;
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	self = [self init];
	if (self) {
		CATransition * trans = [[CATransition alloc] init];
		trans.delegate = self;
		trans.removedOnCompletion = YES;
		self.animation = trans;
		[trans release];
	}
	return self;
}

// create:
SC_IMPLEMENT_CREATE_FUNCTIONS()

- (BOOL) setAttributes:(NSDictionary *)dict
{
	// duration
	id duration = [dict objectForKey:@"duration"];
	if (duration) {
		_animation.duration = [duration doubleValue];
	}
	
	// type
	NSString * type = [dict objectForKey:@"type"];
	if (type) {
		_animation.type = CATransitionTypeFromString(type);
	}
	
	// subtype
	NSString * subtype = [dict objectForKey:@"subtype"];
	if (subtype) {
		_animation.subtype = CATransitionSubtypeFromString(subtype);
	}
	
	// startProgress
	id startProgress = [dict objectForKey:@"startProgress"];
	if (startProgress) {
		_animation.startProgress = [startProgress floatValue];
	}
	
	// endProgress
	id endProgress = [dict objectForKey:@"endProgress"];
	if (endProgress) {
		_animation.endProgress = [endProgress floatValue];
	}
	
	// removedOnCompletion
	id removedOnCompletion = [dict objectForKey:@"removedOnCompletion"];
	if (removedOnCompletion) {
		_animation.removedOnCompletion = [removedOnCompletion boolValue];
	}
	
	// timingFunction
	NSString * timingFunction = [dict objectForKey:@"timingFunction"];
	if (timingFunction) {
		_animation.timingFunction = CAMediaTimingFunctionFromString(timingFunction);
	}
	
	// fillMode
	NSString * fillMode = [dict objectForKey:@"fillMode"];
	if (fillMode) {
		_animation.fillMode = CAFillModeFromString(fillMode);
	}
	
	return YES;
}

- (void) runWithView:(UIView *)view
{
	[view.layer addAnimation:_animation forKey:nil];
}

@end
