//
//  SCView+Gesture.h
//  SnowCat
//
//  Created by Moky on 14-11-11.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCView.h"

#define UISwipeGestureRecognizerDirectionHorizontal (UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight)
#define UISwipeGestureRecognizerDirectionVertical   (UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown)
#define UISwipeGestureRecognizerDirectionAll        (UISwipeGestureRecognizerDirectionHorizontal | UISwipeGestureRecognizerDirectionVertical)

#pragma mark -

@protocol UIViewDragGestureDelegate <NSObject>

@required

// pan to drag
- (void) onDragStart:(UIPanGestureRecognizer *)recognizer;
- (void) onDrag:(UIPanGestureRecognizer *)recognizer;
- (void) onDragEnd:(UIPanGestureRecognizer *)recognizer;

@end

@protocol UIViewScaleGestureDelegate <NSObject>

@required

// pinch to scale
- (void) onScale:(UIPinchGestureRecognizer *)recognizer;

@end

@protocol UIViewRotationGestureDelegate <NSObject>

@required

// rotation
- (void) onRotation:(UIRotationGestureRecognizer *)recogniaer;

@end

#pragma mark -

@interface SCView (Gesture)

+ (BOOL) setGestureAttributes:(NSDictionary *)dict to:(UIView *)view;

// name:
//    Tap, LongPress, Pan, Pinch, Rotation, Swipe, ...
+ (BOOL) addGestureRecognizerWithName:(NSString *)name to:(UIView *)view;

@end
