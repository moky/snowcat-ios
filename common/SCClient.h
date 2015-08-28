//
//  SCClient.h
//  SnowCat
//
//  Created by Moky on 14-6-7.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import "SlanissueToolkit.h"

@interface SCClient : S9Client

@property(nonatomic, readonly) NSString * urlParameters;

+ (instancetype) getInstance;

- (BOOL) openURL:(NSString *)url;

@end
