//
//  SCView+Gesture.m
//  SnowCat
//
//  Created by Moky on 14-11-11.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCEventHandler.h"
#import "SCView+Gesture.h"

@implementation SCView (Gesture)

+ (BOOL) setGestureAttributes:(NSDictionary *)dict to:(UIView *)view
{
	NSArray * gestures = [dict objectForKey:@"gestures"];
	if (!gestures) {
		return NO;
	}
	NSAssert([gestures isKindOfClass:[NSArray class]], @"guestures must be an array: %@", gestures);
	
	NSEnumerator * enumerator = [gestures objectEnumerator];
	NSString * name = nil;
	while (name = [enumerator nextObject]) {
		[self addGestureRecognizerWithName:name to:view];
	}
	
	return YES;
}

+ (BOOL) addGestureRecognizerWithName:(NSString *)name to:(UIView *)view
{
	UIGestureRecognizer * recognizer = [self _newGestureRecognizer:name];
	NSAssert([recognizer isKindOfClass:[UIGestureRecognizer class]], @"gesture error: %@ -> %@", name, recognizer);
	if (recognizer) {
		[view addGestureRecognizer:recognizer];
		[recognizer release];
		return YES;
	} else {
		return NO;
	}
}

+ (UIGestureRecognizer *) _newGestureRecognizer:(NSString *)name
{
	if ([name isEqualToString:@"Tap"]) {
		// Tap
		UITapGestureRecognizer * recognizer;
		recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTapGesture:)];
		return recognizer;
	}
	
	if ([name isEqualToString:@"LongPress"]) {
		// LongPress
		UILongPressGestureRecognizer * recognizer;
		recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_handleLongPressGesture:)];
		return recognizer;
	}
	
	if ([name isEqualToString:@"Pan"]) {
		// Pan
		UIPanGestureRecognizer * recognizer;
		recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePanGesture:)];
		return recognizer;
	}
	
	if ([name isEqualToString:@"Pinch"]) {
		// Pinch
		UIPinchGestureRecognizer * recognizer;
		recognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePinchGesture:)];
		return recognizer;
	}
	
	if ([name isEqualToString:@"Rotation"]) {
		// Rotation
		UIRotationGestureRecognizer * recognizer;
		recognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(_handleRotationGesture:)];
		return recognizer;
	}
	
	// swipe
	UISwipeGestureRecognizerDirection direction = 0;
	
	if ([name isEqualToString:@"SwipeLeft"])
	{
		direction = UISwipeGestureRecognizerDirectionLeft;
	}
	else if ([name isEqualToString:@"SwipeRight"])
	{
		direction = UISwipeGestureRecognizerDirectionRight;
	}
	else if ([name isEqualToString:@"SwipeUp"])
	{
		direction = UISwipeGestureRecognizerDirectionUp;
	}
	else if ([name isEqualToString:@"SwipeDown"])
	{
		direction = UISwipeGestureRecognizerDirectionDown;
	}
	else if ([name isEqualToString:@"SwipeHorizontal"])
	{
		direction = UISwipeGestureRecognizerDirectionHorizontal;
	}
	else if ([name isEqualToString:@"SwipeVertical"])
	{
		direction = UISwipeGestureRecognizerDirectionVertical;
	}
	else if ([name isEqualToString:@"Swipe"])
	{
		direction = UISwipeGestureRecognizerDirectionAll;
	}
	else
	{
		NSAssert(false, @"unrecognized gesture name: %@", name);
		return nil;
	}
	
	UISwipeGestureRecognizer * recognizer;
	recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(_handleSwipeGesture:)];
	recognizer.direction = direction;
	return recognizer;
}

#pragma mark click

+ (void) _handleTapGesture:(UITapGestureRecognizer *)recognizer
{
	SCLog(@"recognizer: %@", recognizer);
	if (recognizer.state == UIGestureRecognizerStateEnded) {
		// only send event while tap gesture ended
		SCDoEvent(@"onTap", recognizer.view);
	}
}

+ (void) _handleLongPressGesture:(UILongPressGestureRecognizer *)recognizer
{
	SCLog(@"recognizer: %@", recognizer);
	if (recognizer.state == UIGestureRecognizerStateBegan) {
		// only send event while long press gesture began
		SCDoEvent(@"onLongPress", recognizer.view);
	}
}

#pragma mark drag

+ (void) _handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
	SCLog(@"recognizer: %@", recognizer);
	UIView * view = recognizer.view;
	
	id<UIViewDragGestureDelegate> delegate = nil;
	if ([view conformsToProtocol:@protocol(UIViewDragGestureDelegate)]) {
		delegate = (id<UIViewDragGestureDelegate>)view;
	}
	
	switch (recognizer.state) {
		case UIGestureRecognizerStateBegan:
			[delegate onDragStart:recognizer];
			break;
			
		case UIGestureRecognizerStateChanged:
			[delegate onDrag:recognizer];
			break;
			
		case UIGestureRecognizerStateEnded:
			[delegate onDragEnd:recognizer];
			// only send event while drag gesture ended
			SCDoEvent(@"onPan", recognizer.view);
			break;
			
		case UIGestureRecognizerStateCancelled:
			[delegate onDragEnd:recognizer];
			break;
			
		default:
			break;
	}
}

#pragma mark scale

+ (void) _handlePinchGesture:(UIPinchGestureRecognizer *)recognizer
{
	SCLog(@"recognizer: %@", recognizer);
	UIView * view = recognizer.view;
	
	id<UIViewScaleGestureDelegate> delegate = nil;
	if ([view conformsToProtocol:@protocol(UIViewScaleGestureDelegate)]) {
		delegate = (id<UIViewScaleGestureDelegate>)view;
	}
	
	switch (recognizer.state) {
		case UIGestureRecognizerStateBegan:
			break;
			
		case UIGestureRecognizerStateChanged:
			[delegate onScale:recognizer];
			break;
			
		case UIGestureRecognizerStateEnded:
			// only send event while pinch gesture ended
			SCDoEvent(@"onPinch", recognizer.view);
			break;
			
		case UIGestureRecognizerStateCancelled:
			break;
			
		default:
			break;
	}
}

#pragma mark rotation

+ (void) _handleRotationGesture:(UIRotationGestureRecognizer *)recognizer
{
	SCLog(@"recognizer: %@", recognizer);
	UIView * view = recognizer.view;
	
	id<UIViewRotationGestureDelegate> delegate = nil;
	if ([view conformsToProtocol:@protocol(UIViewRotationGestureDelegate)]) {
		delegate = (id<UIViewRotationGestureDelegate>)view;
	}
	
	switch (recognizer.state) {
		case UIGestureRecognizerStateBegan:
			break;
			
		case UIGestureRecognizerStateChanged:
			[delegate onRotation:recognizer];
			break;
			
		case UIGestureRecognizerStateEnded:
			// only send event while rotation gesture ended
			SCDoEvent(@"onRotation", recognizer.view);
			break;
			
		case UIGestureRecognizerStateCancelled:
			break;
			
		default:
			break;
	}
}

#pragma mark swipe

+ (void) _handleSwipeGesture:(UISwipeGestureRecognizer *)recognizer
{
	SCLog(@"recognizer: %@", recognizer);
	UISwipeGestureRecognizerDirection direction = recognizer.direction;
	if (direction == UISwipeGestureRecognizerDirectionLeft)
	{
		SCDoEvent(@"onSwipeLeft", recognizer.view);
	}
	else if (direction == UISwipeGestureRecognizerDirectionRight)
	{
		SCDoEvent(@"onSwipeRight", recognizer.view);
	}
	else if (direction == UISwipeGestureRecognizerDirectionUp)
	{
		SCDoEvent(@"onSwipeUp", recognizer.view);
	}
	else if (direction == UISwipeGestureRecognizerDirectionDown)
	{
		SCDoEvent(@"onSwipeDown", recognizer.view);
	}
	else if (direction == UISwipeGestureRecognizerDirectionHorizontal)
	{
		SCDoEvent(@"onSwipeHorizontal", recognizer.view);
	}
	else if (direction == UISwipeGestureRecognizerDirectionVertical)
	{
		SCDoEvent(@"onSwipeVertical", recognizer.view);
	}
	else if (direction == UISwipeGestureRecognizerDirectionAll)
	{
		SCDoEvent(@"onSwipe", recognizer.view);
	}
	else
	{
		NSAssert(false, @"error recognizer: %@", recognizer);
	}
}

@end
