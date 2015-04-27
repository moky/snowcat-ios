//
//  SCImageView.m
//  SnowCat
//
//  Created by Moky on 14-3-18.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCNib.h"
#import "SCImage.h"
#import "SCImageView.h"

@implementation SCImageView

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib

- (void) dealloc
{
	self.nodeFile = nil;
	
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCImageView
{
	_scTag = 0;
	self.nodeFile = nil;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCImageView];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeSCImageView];
	}
	return self;
}

- (instancetype) initWithImage:(UIImage *)image
{
	self = [super initWithImage:image];
	if (self) {
		[self _initializeSCImageView];
	}
	return self;
}

- (instancetype) initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage NS_AVAILABLE_IOS(3_0)
{
	self = [super initWithImage:image highlightedImage:highlightedImage];
	if (self) {
		[self _initializeSCImageView];
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	id image = [dict objectForKey:@"image"];
	if (!image) {
		image = [dict objectForKey:@"File"];
	}
	SCImage * image1 = [SCImage create:image autorelease:NO];
	SCImage * image2 = nil;
	
	id highlightedImage = [dict objectForKey:@"highlightedImage"];
	if (highlightedImage) {
		image2 = [SCImage create:highlightedImage autorelease:NO];
		self = [self initWithImage:image1 highlightedImage:image2];
	} else {
		self = [self initWithImage:image1];
	}
	
	if (self) {
		[self buildHandlers:dict];
		
		// set delegate for remote image
		if ([image1 isKindOfClass:[SCImage class]]) {
			image1.delegate = self;
		}
		if ([image2 isKindOfClass:[SCImage class]]) {
			image2.delegate = self;
		}
	}
	
	[image2 release];
	[image1 release];
	return self;
}

// buildHandlers:
SC_UIKIT_IMELEMENT_BUILD_HANDLERS_FUNCTION()

// awakeFromNib
SC_UIKIT_IMPLEMENT_AWAKE_FUNCTION()

// create:
SC_UIKIT_IMPLEMENT_CREATE_FUNCTIONS()

// setAttributes:
SC_UIKIT_IMPLEMENT_SET_ATTRIBUTES_FUNCTION()

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UIImageView *)imageView
{
	if (![SCView setAttributes:dict to:imageView]) {
		return NO;
	}
	
	// userInteractionEnabled (has already been set by SCView)
	
	// highlighted
	id highlighted = [dict objectForKey:@"highlighted"];
	if (highlighted) {
		imageView.highlighted = [highlighted boolValue];
	}
	
	// animationImages (UIImages)
	NSArray * animationImages = [dict objectForKey:@"animationImages"];
	if (animationImages) {
		NSAssert([animationImages isKindOfClass:[NSArray class]], @"animationImages must be an array: %@", animationImages);
		NSUInteger count = [animationImages count];
		NSMutableArray * mArray = [[NSMutableArray alloc] initWithCapacity:count];
		
		NSEnumerator * enumerator = [animationImages objectEnumerator];
		NSDictionary * item;
		SCImage * image;
		while (item = [enumerator nextObject]) {
			image = [SCImage create:item autorelease:NO];
			NSAssert([image isKindOfClass:[UIImage class]], @"animationImages item's definition error: %@", item);
			if (image) {
				[mArray addObject:image];
				[image release];
			}
		}
		
		imageView.animationImages = mArray;
		[mArray release];
	}
	
	// highlightedAnimationImages (UIImages)
	NSArray * highlightedAnimationImages = [dict objectForKey:@"highlightedAnimationImages"];
	if (highlightedAnimationImages) {
		NSAssert([highlightedAnimationImages isKindOfClass:[NSArray class]], @"highlightedAnimationImages must be an array: %@", highlightedAnimationImages);
		NSUInteger count = [highlightedAnimationImages count];
		NSMutableArray * mArray = [[NSMutableArray alloc] initWithCapacity:count];
		
		NSEnumerator * enumerator = [highlightedAnimationImages objectEnumerator];
		NSDictionary * item;
		SCImage * image;
		while (item = [enumerator nextObject]) {
			image = [SCImage create:item autorelease:NO];
			NSAssert([image isKindOfClass:[UIImage class]], @"highlightedAnimationImages item's definition error: %@", item);
			if (image) {
				[mArray addObject:image];
				[image release];
			}
		}
		
		imageView.highlightedAnimationImages = mArray;
		[mArray release];
	}
	
	// animationDuration
	id animationDuration = [dict objectForKey:@"animationDuration"];
	if (animationDuration) {
		imageView.animationDuration = [animationDuration doubleValue];
	}
	
	// animationRepeatCount
	id animationRepeatCount = [dict objectForKey:@"animationRepeatCount"];
	if (animationRepeatCount) {
		imageView.animationRepeatCount = [animationRepeatCount integerValue];
	}
	
	// auto start animation
	if (animationImages || highlightedAnimationImages) {
		[imageView startAnimating];
	}
	
	return YES;
}

#pragma mark - SCDataDelegate

- (void) onDataLoad:(NSData *)data withURL:(NSURL *)url
{
	UIImage * image1 = self.image;
	// reset self.image
	[image1 retain];
	[self performSelectorOnMainThread:@selector(setImage:) withObject:nil waitUntilDone:YES];
	[self performSelectorOnMainThread:@selector(setImage:) withObject:image1 waitUntilDone:YES];
	[image1 release];
	
	UIImage * image2 = self.image;
	// reset self.highlightedImage
	[image2 retain];
	[self performSelectorOnMainThread:@selector(setHighlightedImage:) withObject:nil waitUntilDone:YES];
	[self performSelectorOnMainThread:@selector(setHighlightedImage:) withObject:image2 waitUntilDone:YES];
	[image2 release];
}

- (void) onDataError:(NSData *)data withURL:(NSURL *)url
{
	// show error image
}

- (void) onDataStart:(NSData *)data withURL:(NSURL *)url
{
	// show loading image
}

- (void) onDataReceive:(NSData *)data contentLength:(long long)contentLength withURL:(NSURL *)url
{
	// TODO: update progress here
}

@end
