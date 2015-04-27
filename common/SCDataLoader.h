//
//  SCDataLoader.h
//  SnowCat
//
//  Created by Moky on 15-1-20.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCDataDelegate <NSObject>

- (void) onDataLoad:(NSData *)data withURL:(NSURL *)url; // download finished
- (void) onDataError:(NSData *)data withURL:(NSURL *)url; // download failed

@optional
- (void) onDataStart:(NSData *)data withURL:(NSURL *)url; // start to download
- (void) onDataReceive:(NSData *)data contentLength:(long long)contentLength withURL:(NSURL *)url;

@end

#pragma mark -

@interface SCDataLoader : NSObject<NSURLConnectionDataDelegate>

@property(nonatomic, assign) id<SCDataDelegate> delegate;

@property(nonatomic, readonly) NSData * data; // received data (maybe from cache file)

- (instancetype) initWithContentsOfURL:(NSURL *)url delegate:(id<SCDataDelegate>)delegate;

@end
