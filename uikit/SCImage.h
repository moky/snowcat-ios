//
//  SCImage.h
//  SnowCat
//
//  Created by Moky on 14-3-17.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCDataLoader.h"
#import "SCUIKit.h"

UIKIT_EXTERN UIImageOrientation UIImageOrientationFromString(NSString * string);

@interface UIImage (IO)

- (BOOL) writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile;

@end

@interface SCImage : UIImage<SCUIKit, SCDataDelegate>

@property(nonatomic, assign) id<SCDataDelegate> delegate;

//
// while filename is a remote URL, this method only create an empty SCImage,
// it won't start downloading until the delegate is set
//
+ (UIImage *) imageNamed:(NSString *)filename;

@end
