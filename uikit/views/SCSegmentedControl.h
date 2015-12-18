//
//  SCSegmentedControl.h
//  SnowCat
//
//  Created by Moky on 14-4-2.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "SCControl.h"

#if !TARGET_OS_TV
UIKIT_EXTERN UISegmentedControlStyle UISegmentedControlStyleFromString(NSString * string);
#endif

UIKIT_EXTERN UISegmentedControlSegment UISegmentedControlSegmentFromString(NSString * string);

@interface SCSegmentedControl : UISegmentedControl<SCUIKit>

+ (BOOL) setAttributes:(NSDictionary *)dict to:(UISegmentedControl *)segmentedControl;

// Value Event Interfaces
- (void) onChange:(id)sender;

@end
