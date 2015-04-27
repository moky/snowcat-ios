//
//  SCActionView.m
//  SnowCat
//
//  Created by Moky on 14-3-25.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCTransition.h"
#import "SCView.h"
#import "SCActionView.h"

@implementation SCActionView

- (BOOL) _setAttributes:(NSDictionary *)dict withView:(UIView *)view
{
	return SC_UIKIT_SET_ATTRIBUTES(view, SCView, dict);
}

- (BOOL) _addSubview:(NSDictionary *)dict withView:(UIView *)view
{
	SC_UIKIT_DIG_CREATION_INFO(dict); // support ObjectFromFile
	SCView * child = [SCView create:dict autorelease:NO];
	NSAssert([child isKindOfClass:[UIView class]], @"subview's definition error: %@", dict);
	[view addSubview:child];
	SC_UIKIT_SET_ATTRIBUTES(child, SCView, dict);
	[child release];
	return YES;
}

- (BOOL) _removeFromSuperview:(UIView *)view
{
	[view removeFromSuperview];
	return YES;
}

- (BOOL) _transitionWithView:(UIView *)view
{
	// transition
	NSDictionary * transition = [_dict objectForKey:@"transition"];
	if (transition) {
		SCTransition * trans = [SCTransition create:transition autorelease:NO];
		NSAssert([trans isKindOfClass:[SCTransition class]], @"transition's definition error: %@", transition);
		[trans setAttributes:transition];
		[trans runWithView:view];
		[trans release];
		return YES;
	}
	return NO;
}

- (BOOL) runWithResponder:(id)responder
{
	if ([responder isKindOfClass:[UIViewController class]]) {
		responder = [(UIViewController *)responder view];
	}
	NSAssert([responder isKindOfClass:[UIView class]], @"definition error: %@, responder: %@", _dict, responder);
	
	UIView * view = (UIView *)responder;
	
	NSString * selector = [_dict objectForKey:@"selector"];
	
	BOOL flag = NO;
	
	//----------------------------------------------------------- set attributes
	if ([selector isEqualToString:@"setAttributes:"])
	{
		NSDictionary * attributes = [_dict objectForKey:@"attributes"];
		NSAssert([attributes isKindOfClass:[NSDictionary class]], @"attributes's definition error: %@", _dict);
		flag = [self _setAttributes:attributes
						   withView:view];
		[self _transitionWithView:view];
	}
	//-------------------------------------------------------------- add subview
	else if ([selector isEqualToString:@"addSubview:"])
	{
		NSDictionary * child = [_dict objectForKey:@"view"];
		NSAssert([child isKindOfClass:[NSDictionary class]], @"subview's definition error: %@", _dict);
		flag = [self _addSubview:child
						withView:view];
		[self _transitionWithView:view];
	}
	//---------------------------------------------------- remove from superview
	else if ([selector isEqualToString:@"removeFromSuperview"])
	{
		[self _transitionWithView:view.superview];
		flag = [self _removeFromSuperview:view];
	}
	
	NSAssert(flag, @"invalid action: %@, responder: %@", _dict, responder);
	return flag;
}

@end
