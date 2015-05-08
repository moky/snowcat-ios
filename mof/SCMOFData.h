//
//  SCMOFData.h
//  SnowCat
//
//  Created by Moky on 14-12-9.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCMOFData : NSObject {
	
@protected
	unsigned char * _dataBuffer;
}

// create an initialized buffer with length
- (instancetype) initWithLength:(unsigned long)bufferLength;

// init and call 'loadFromFile:'
- (instancetype) initWithFile:(NSString *)filename;

- (BOOL) loadFromFile:(NSString *)filename;
- (BOOL) saveToFile:(NSString *)filename;

- (BOOL) checkDataFormat;

@end
