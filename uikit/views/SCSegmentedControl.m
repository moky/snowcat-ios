//
//  SCSegmentedControl.m
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCNib.h"
#import "SCColor.h"
#import "SCImage.h"
#import "SCEventHandler.h"
#import "SCSegmentedControl.h"

//typedef NS_ENUM(NSInteger, UISegmentedControlStyle) {
//    UISegmentedControlStylePlain,     // large plain
//    UISegmentedControlStyleBordered,  // large bordered
//    UISegmentedControlStyleBar,       // small button/nav bar style. tintable
//    UISegmentedControlStyleBezeled,   // DEPRECATED. Do not use this style.
//};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
UISegmentedControlStyle UISegmentedControlStyleFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"Plain")
			return UISegmentedControlStylePlain;
		SC_SWITCH_CASE(string, @"Border") // Bordered
			return UISegmentedControlStyleBordered;
		SC_SWITCH_CASE(string, @"Bar")
			return UISegmentedControlStyleBar;
		SC_SWITCH_CASE(string, @"Bez")    // Bezeled
			return UISegmentedControlStyleBezeled;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}
#pragma clang diagnostic pop

//enum {
//    UISegmentedControlNoSegment = -1   // segment index for no selected segment
//};
//
//typedef NS_ENUM(NSInteger, UISegmentedControlSegment) {
//    UISegmentedControlSegmentAny = 0,
//    UISegmentedControlSegmentLeft = 1,   // The capped, leftmost segment. Only applies when numSegments > 1.
//    UISegmentedControlSegmentCenter = 2, // Any segment between the left and rightmost segments. Only applies when numSegments > 2.
//    UISegmentedControlSegmentRight = 3,  // The capped,rightmost segment. Only applies when numSegments > 1.
//    UISegmentedControlSegmentAlone = 4,  // The standalone segment, capped on both ends. Only applies when numSegments = 1.
//};
UISegmentedControlSegment UISegmentedControlSegmentFromString(NSString * string)
{
	SC_SWITCH_BEGIN(string)
		SC_SWITCH_CASE(string, @"No") // NoSegment
			return UISegmentedControlNoSegment;
		SC_SWITCH_CASE(string, @"Any")
			return UISegmentedControlSegmentAny;
		SC_SWITCH_CASE(string, @"Left")
			return UISegmentedControlSegmentLeft;
		SC_SWITCH_CASE(string, @"Center")
			return UISegmentedControlSegmentCenter;
		SC_SWITCH_CASE(string, @"Right")
			return UISegmentedControlSegmentRight;
		SC_SWITCH_CASE(string, @"Alone")
			return UISegmentedControlSegmentAlone;
		SC_SWITCH_DEFAULT
	SC_SWITCH_END
	
	return [string integerValue];
}

@implementation SCSegmentedControl

@synthesize scTag = _scTag;
@synthesize nodeFile = _nodeFile; // filename, use for awaked from nib

- (void) dealloc
{
	[_nodeFile release];
	
	[self removeTarget:self action:@selector(onChange:) forControlEvents:UIControlEventValueChanged];
	
	[SCResponder onDestroy:self];
	[super dealloc];
}

- (void) _initializeSCSegmentedControl
{
	_scTag = 0;
	self.nodeFile = nil;
	
	// Note that the target is not retained, so this assignment won't cause memory leaks
	[self addTarget:self action:@selector(onChange:) forControlEvents:UIControlEventValueChanged];
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _initializeSCSegmentedControl];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _initializeSCSegmentedControl];
	}
	return self;
}

// items can be NSStrings or UIImages. control is automatically sized to fit content
- (instancetype) initWithItems:(NSArray *)items
{
	self = [super initWithItems:items];
	if (self) {
		[self _initializeSCSegmentedControl];
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
	self = [self initWithItems:nil];
	if (self) {
		[self buildHandlers:dict];
	}
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

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UISegmentedControl *)segmentedControl
{
	NSAssert([dict isKindOfClass:[NSDictionary class]], @"error");
	
	// segmentedControlStyle
	NSString * segmentedControlStyle = [dict objectForKey:@"segmentedControlStyle"];
	if (segmentedControlStyle) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		segmentedControl.segmentedControlStyle = UISegmentedControlStyleFromString(segmentedControlStyle);
#pragma clang diagnostic pop
	}
	
	// momentary
	id momentary = [dict objectForKey:@"momentary"];
	if (momentary) {
		segmentedControl.momentary = [momentary boolValue];
	}
	
	// items
	NSArray * items = [dict objectForKey:@"items"];
	if (items) {
		id seg;
		UIImage * image;
		NSInteger i = -1;
		SC_FOR_EACH(seg, items) {
			++i;
			if ([seg isKindOfClass:[NSDictionary class]]) {
				image = [SCImage create:seg autorelease:NO];
				if (i < segmentedControl.numberOfSegments) {
					[segmentedControl setImage:image forSegmentAtIndex:i];
				} else {
					[segmentedControl insertSegmentWithImage:image atIndex:i animated:NO];
				}
				[image release];
			} else if ([seg isKindOfClass:[NSString class]]) {
				if (i < segmentedControl.numberOfSegments) {
					[segmentedControl setTitle:seg forSegmentAtIndex:i];
				} else {
					[segmentedControl insertSegmentWithTitle:seg atIndex:i animated:NO];
				}
			}
		}
	}
	
	// apportionsSegmentWidthsByContent
	id apportionsSegmentWidthsByContent = [dict objectForKey:@"apportionsSegmentWidthsByContent"];
	if (apportionsSegmentWidthsByContent) {
		segmentedControl.apportionsSegmentWidthsByContent = [apportionsSegmentWidthsByContent boolValue];
	}
	
	// selectedSegmentIndex
	id selectedSegmentIndex = [dict objectForKey:@"selectedSegmentIndex"];
	if (selectedSegmentIndex) {
		segmentedControl.selectedSegmentIndex = [selectedSegmentIndex integerValue];
	}
	
	// tintColor
	NSDictionary * tintColor = [dict objectForKey:@"tintColor"];
	if (tintColor) {
		SCColor * color = [SCColor create:tintColor autorelease:NO];
		segmentedControl.tintColor = color;
		[color release];
	}
	
	if (![SCControl setAttributes:dict to:segmentedControl]) {
		SCLog(@"failed to set attributes: %@", dict);
		return NO;
	}
	
	return YES;
}

#pragma mark - Value Event Interfaces

- (void) onChange:(id)sender
{
	SCLog(@"onChange: %@", sender);
	SCDoEvent(@"onChange", sender);
	
	NSString * event = [[NSString alloc] initWithFormat:@"onSelect:%d", (int)(self.selectedSegmentIndex)];
	SCDoEvent(event, sender);
	[event release];
}

@end
