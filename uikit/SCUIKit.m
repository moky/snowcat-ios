//
//  SCUI.m
//  SnowCat
//
//  Created by Moky on 14-3-17.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCLog.h"
#import "SCString.h"
#import "SCDictionary.h"
#import "SCNodeFileParser.h"
#import "SCUIKit.h"

@implementation SCUIKit

// create:
SC_IMPLEMENT_CREATE_FUNCTION()
+ (id) create:(NSDictionary *)dict autorelease:(BOOL)autorelease
{
	// try as scobject
	id object = [SCObject create:dict autorelease:autorelease];
	if (object) {
		return object;
	}
	
	NSString * className = [dict objectForKey:@"Class"];
	NSAssert(className, @"invalid class: %@", dict);
	
	// try 'UI' prefix
	className = [[NSString alloc] initWithFormat:@"UI%@", className];
	Class class = NSClassFromString(className);
	[className release];
	
	NSAssert(class, @"invalid class: %@", dict);
	
	// create object
	object = [class alloc];
	if ([object conformsToProtocol:@protocol(SCUIKit)]) {
		[object initWithDictionary:dict];
	} else {
		SCLog(@"[WARNING] classname: %@", [dict objectForKey:@"Class"]);
		[object init];
	}
	
	if (object && autorelease) {
		return [object autorelease];
	} else {
		return object;
	}
}

+ (NSDictionary *) _dictionaryFromString:(NSString *)string
{
	NSObject * object = [SCString objectFromJsonString:string];
	if ([object isKindOfClass:[NSDictionary class]]) {
		// json object
		return (NSDictionary *)object;
	}
	
	// key-value (css) format string
	return [SCString dictionaryFromMapString:string];
}

+ (NSDictionary *) dictionaryByDiggingCreationInfo:(NSDictionary *)dict
{
	NSString * className = [dict objectForKey:@"Class"];
	if ([className isEqualToString:@"ObjectFromFile"]) {
		NSString * file = [dict objectForKey:@"File"];
		NSAssert([file length] > 0, @"filename cannot be epmty");
		
		SCNodeFileParser * parser = [SCNodeFileParser parser:file];
		NSDictionary * node = [parser node];
		NSAssert([node isKindOfClass:[NSDictionary class]], @"fail to load data from file: %@", file);
		
		// replace
		id replacement = [dict objectForKey:@"replace"];
		if ([replacement isKindOfClass:[NSString class]]) {
			replacement = [self _dictionaryFromString:replacement];
		}
		if (replacement) {
			NSAssert([replacement isKindOfClass:[NSDictionary class]], @"replace error: %@", dict);
			node = [SCDictionary replaceDictionary:node withData:replacement];
		}
		// attributes
		id attributes = [dict objectForKey:@"attributes"];
		if ([attributes isKindOfClass:[NSString class]]) {
			attributes = [self _dictionaryFromString:attributes];
		}
		if (attributes) {
			NSAssert([attributes isKindOfClass:[NSDictionary class]], @"attributes error: %@", dict);
			node = [SCDictionary mergeDictionary:node withAttributes:attributes];
		}
		dict = node;
	}
	return dict;
}

@end

@implementation SCUIKit (relationship)

+ (UIResponder *) getTarget:(NSString *)target responder:(UIResponder *)responder
{
	NSAssert(!target || [target isKindOfClass:[NSString class]], @"target must be defined as a string: %@", target);
	NSAssert([responder isKindOfClass:[UIResponder class]], @"responder error");
	// reserved words
	if (!target || [target isEqualToString:@"self"]) {
		return responder;
	} else if ([target isEqualToString:@"parent"]) {
		if ([responder isKindOfClass:[UIView class]]) {
			return [(UIView *)responder superview];
		} else if ([responder isKindOfClass:[UIViewController class]]) {
			return [(UIViewController *)responder parentViewController];
		}
		NSAssert(false, @"error target: %@ for responder: %@", target, responder);
		return nil;
	} else if ([target isEqualToString:@"window"]) {
		// root window
		if ([responder isKindOfClass:[UIViewController class]]) {
			responder = [(UIViewController *)responder view];
		}
		if ([responder isKindOfClass:[UIView class]]) {
			UIView * view = (UIView *)responder;
			if (view.window) {
				return view.window;
			}
		}
		return [[UIApplication sharedApplication] keyWindow];
	} else if ([responder respondsToSelector:NSSelectorFromString(target)]) {
		// child getter
		if ([target isEqualToString:@"view"]) {
			return [(id)responder view];
		} else if ([target isEqualToString:@"rootViewController"]) {
			return [(id)responder rootViewController];
		}
		NSAssert(false, @"unsupport target: %@ for responder: %@", target, responder);
		return nil;
	}
	
	// target by format: xxx.xxx.xxx
	NSRange range = [target rangeOfString:@"."];
	if (range.location != NSNotFound) {
		NSString * str1 = [target substringToIndex:range.location];
		NSString * str2 = [target substringFromIndex:range.location + 1];
		return [self getTarget:str2 responder:[self getTarget:str1 responder:responder]];
	}
	
	// get children
	NSArray * children = nil;
	if ([responder isKindOfClass:[UIView class]]) {
		children = [(UIView *)responder subviews];
	} else if ([responder isKindOfClass:[UIViewController class]]) {
		children = [(UIViewController *)responder childViewControllers];
	}
	NSAssert(children, @"error target: %@ for responder: %@", target, responder);
	
	// check scTag
	NSInteger tag = [target integerValue];
	NSEnumerator * enumerator = [children objectEnumerator];
	id<SCUIKit> kit;
	while (kit = [enumerator nextObject]) {
		if ([kit conformsToProtocol:@protocol(SCUIKit)]) {
			if ([kit scTag] == tag) {
				return kit;
			}
		}
	}
	
	NSAssert(false, @"no such target: %@ for responder: %@", target, responder);
	return nil;
}

@end