//
//  SCDataLoader.m
//  SnowCat
//
//  Created by Moky on 15-1-20.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCClient.h"
#import "SCString.h"
#import "SCURL.h"
#import "SCURLRequest.h"
#import "SCDataLoader.h"

static NSString * SCDataLoaderTemporaryFile(NSURL * url)
{
	NSString * absoluteString = [url absoluteString];
	NSString * path = [url path];
	NSString * filename = [path lastPathComponent];
	NSString * ext = [filename pathExtension]; // get ext from last path component
	
	NSString * md5 = [SCString MD5String:absoluteString]; // use the whole url to md5
	
	filename = [NSString stringWithFormat:@"cache-%@.%@", md5, ext];
	path = [SCTemporaryDirectory() stringByAppendingPathComponent:filename];
	
	// TODO: check whether the cache file has expired
	
	return path;
}

@interface SCDataLoader ()

@property(nonatomic, retain) NSURL * url;

@property(nonatomic, assign) NSURLConnection * connection;

@property(nonatomic, readwrite) long long contentLength;

@property(nonatomic, retain) NSMutableData * receiveData;

@end

@implementation SCDataLoader

@synthesize delegate = _delegate;

@synthesize url = _url;
@synthesize connection = _connection;
@synthesize contentLength = _contentLength;
@synthesize receiveData = _receiveData;

- (void) dealloc
{
	self.delegate = nil;
	
	self.url = nil;
	self.connection = nil;
	self.receiveData = nil;
	
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		self.receiveData = nil;
		self.delegate = nil;
		
		self.url = nil;
		self.connection = nil;
		self.contentLength = 0;
	}
	return self;
}

- (instancetype) initWithContentsOfURL:(NSURL *)url delegate:(id<SCDataDelegate>)delegate
{
	self = [self init];
	
	self.url = url; // save the original url
	
	if ([url isFileURL]) {
		// 1. local file, load it directory
		self.receiveData = [NSMutableData dataWithContentsOfURL:url];
		return self;
	}
	
	BOOL isDirectory = NO;
	NSString * cacheFile = SCDataLoaderTemporaryFile(url);
	if ([[NSFileManager defaultManager] fileExistsAtPath:cacheFile isDirectory:&isDirectory])
	{
		SCLog(@"loading cache file: %@", cacheFile);
		// 2. cache file exists, load it
		url = [[SCURL alloc] initWithString:cacheFile isDirectory:NO];
		self.receiveData = [NSMutableData dataWithContentsOfURL:url];
		[url release];
	}
	else
	{
		SCLog(@"downloading remote file: %@", url);
		// 3. load from remote
		[self _initConnectionWithURL:url];
		
		self.receiveData = [NSMutableData data];
		self.delegate = delegate;
	}
	
	return self;
}

- (void) setDelegate:(id<SCDataDelegate>)delegate
{
	_delegate = delegate;
	
	if (delegate) {
		[_connection start];
	}
}

// hide the inner data object to forbid modifying outside
- (NSData *) data
{
	return _receiveData;
}

- (void) _initConnectionWithURL:(NSURL *)url
{
	SCURLRequest * req = [[SCURLRequest alloc] initWithURL:url];
	/*
	 The delegate is retained by the NSURLConnection
	 until a terminal condition is encountered.
	 */
	
	// must remember to release the connection in Failed/Finished
	self.connection = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:NO];
	
	[req release];
}

#pragma mark - NSURLConnectionDelegate

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSAssert([_receiveData isKindOfClass:[NSMutableData class]], @"error: %@", _receiveData);
	NSAssert([_url isKindOfClass:[NSURL class]], @"error: %@", _url);
	
	SCLog(@"url: %@, error: %@", _url, error);
	[_delegate onDataError:_receiveData withURL:_url];
	
	[connection release]; // release the connection and delegate
}

//- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection;
//- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;

#pragma mark - NSURLConnectionDataDelegate

//- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response;

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSAssert([_receiveData isKindOfClass:[NSMutableData class]], @"error: %@", _receiveData);
	NSAssert([_url isKindOfClass:[NSURL class]], @"error: %@", _url);
	
	SCLog(@"download start, url: %@, response: %@", _url, response);
	self.contentLength = response.expectedContentLength;
	[_receiveData setLength:0];
	
	if ([_delegate respondsToSelector:@selector(onDataStart:withURL:)]) {
		[_delegate onDataStart:_receiveData withURL:_url];
	}
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	NSAssert([_receiveData isKindOfClass:[NSMutableData class]], @"error: %@", _receiveData);
	NSAssert([_url isKindOfClass:[NSURL class]], @"error: %@", _url);
	
	[_receiveData appendData:data];
	
	if ([_delegate respondsToSelector:@selector(onDataReceive:contentLength:withURL:)]) {
		[_delegate onDataReceive:_receiveData contentLength:_contentLength withURL:_url];
	}
	SCLog(@"received %d / %lld", (int)_receiveData.length, _contentLength);
}

//- (NSInputStream *)connection:(NSURLConnection *)connection needNewBodyStream:(NSURLRequest *)request;
//- (void)connection:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten
// totalBytesWritten:(NSInteger)totalBytesWritten
//totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite;
//
//- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse;

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSAssert([_receiveData isKindOfClass:[NSMutableData class]], @"error: %@", _receiveData);
	NSAssert([_url isKindOfClass:[NSURL class]], @"error: %@", _url);
	
	[_delegate onDataLoad:_receiveData withURL:_url];
	
	// 4. save it to cache
	NSString * cacheFile = SCDataLoaderTemporaryFile(_url);
	[_receiveData writeToFile:cacheFile atomically:YES];
	
	SCLog(@"download finished, length: %u, url: %@, cache file: %@", (unsigned int)_receiveData.length, _url, cacheFile);
	
	[connection release]; // release the connection and delegate
}

@end
