//
//  SCAction.h
//  SnowCat
//
//  Created by Moky on 14-3-24.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCUIKit.h"

@interface SCAction : SCObject {
	
@protected
	NSDictionary * _dict;
}

// run action with responder
// override this
- (BOOL) runWithResponder:(id)responder;

// start (immediately or lingeringly) the action
// don't override this
- (BOOL) startWithResponder:(id)responder;

@end
