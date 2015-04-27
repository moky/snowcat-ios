//
//  SCAnimationView.m
//  SnowCat
//
//  Created by Moky on 14-7-16.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCImage.h"
#import "SCAnimationView.h"

@interface SCAnimationView ()

@property(nonatomic, retain) NSDictionary * animations;
@property(nonatomic, retain) NSString * currentAnimation;

@end

@implementation SCAnimationView

@synthesize animations = _animations;
@synthesize currentAnimation = _currentAnimation;

- (void) dealloc
{
	[_animations release];
	[_currentAnimation release];
	
	[super dealloc];
}

- (void) _initializeSCAnimationView
{
	self.animations = nil;
	self.currentAnimation = nil;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCAnimationView];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeSCAnimationView];
	}
	return self;
}

- (instancetype) initWithImage:(UIImage *)image
{
	self = [super initWithImage:image];
	if (self) {
		[self _initializeSCAnimationView];
	}
	return self;
}

- (instancetype) initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage NS_AVAILABLE_IOS(3_0)
{
	self = [super initWithImage:image highlightedImage:highlightedImage];
	if (self) {
		[self _initializeSCAnimationView];
	}
	return self;
}

- (BOOL) setAttributes:(NSDictionary *)dict
{
	if (![super setAttributes:dict]) {
		return NO;
	}
	
	// animations
	NSDictionary * animations = [dict objectForKey:@"animations"];
	if (animations) {
		self.animations = animations;
	}
	
	// init default animation
	[self _setCurrentAnimationWithName:@"default"];
	
	return YES;
}

#pragma mark -

- (void) _setCurrentAnimationWithName:(NSString *)name
{
	NSAssert([name isKindOfClass:[NSString class]], @"error animation name: %@", name);
	// stop it
	if ([self isAnimating]) {
		[self stopAnimating];
	}
	
	if ([name isEqualToString:_currentAnimation]) {
		SCLog(@"current animation not changed: %@", name);
		return;
	}
	
	NSDictionary * dict = [_animations objectForKey:name];
	NSAssert([dict isKindOfClass:[NSDictionary class]], @"animations' item must be a dictionary: %@", dict);
	
	// animationImages
	NSArray * animationImages = [dict objectForKey:@"animationImages"];
	if (!animationImages) {
		animationImages = [dict objectForKey:@"images"];
	}
	NSAssert([animationImages isKindOfClass:[NSArray class]], @"animationImages must be an array: %@", animationImages);
	NSMutableArray * mArray = [[NSMutableArray alloc] initWithCapacity:[animationImages count]];
	
	NSEnumerator * enumerator = [animationImages objectEnumerator];
	NSDictionary * item = nil;
	UIImage * image;
	while (item = [enumerator nextObject]) {
		image = [SCImage create:item autorelease:NO];
		NSAssert([image isKindOfClass:[UIImage class]], @"image's definition error: %@", item);
		if (image) {
			[mArray addObject:image];
			[image release];
		}
	}
	NSAssert([mArray count] == [animationImages count], @"some image(s) maybe lost");
	
	self.animationImages = mArray;
	[mArray release];
	
	// animationDuration
	id animationDuration = [dict objectForKey:@"animationDuration"];
	if (!animationDuration) {
		animationDuration = [dict objectForKey:@"duration"];
	}
	if (animationDuration) {
		self.animationDuration = [animationDuration doubleValue];
	}
	
	// change current animation name
	self.currentAnimation = name;
}

- (void) startAnimating:(NSString *)name
{
	[self _setCurrentAnimationWithName:name];
	[self startAnimating];
}

- (void) startAnimation:(NSDictionary *)dict
{
	// animationRepeatCount
	id animationRepeatCount = [dict objectForKey:@"animationRepeatCount"];
	if (!animationRepeatCount) {
		animationRepeatCount = [dict objectForKey:@"repeatCount"];
	}
	if (animationRepeatCount) {
		self.animationRepeatCount = [animationRepeatCount integerValue];
	}
	
	// name
	NSString * name = [dict objectForKey:@"name"];
	
	// start it
	[self startAnimating:name];
}

@end
