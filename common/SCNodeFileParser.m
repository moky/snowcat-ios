//
//  SCNodeFileParser.m
//  SnowCat
//
//  Created by Moky on 12-9-28.
//  Copyright 2012 Slanissue.com. All rights reserved.
//

#import "SCLog.h"
#import "SCMOFTransformer.h"
#import "SCClient.h"
#import "SCString.h"
#import "SCString+Extension.h"
#import "SCDictionary.h"
#import "SCNodeFileParser.h"

@interface SCNodeFileParser ()

@property(nonatomic, retain) NSString * path;
@property(nonatomic, retain) NSString * filename;
@property(nonatomic, retain) NSDictionary * root;

@property(nonatomic, readwrite) BOOL isParsed;

@end

@implementation SCNodeFileParser

@synthesize vars = _vars;

@synthesize path = _path;
@synthesize filename = _filename;
@synthesize root = _root;

@synthesize isParsed = _isParsed;

- (void) dealloc
{
	self.vars = nil;
	
	self.path = nil;
	self.filename = nil;
	self.root = nil;
	
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
		self.vars = nil;
		
		self.path = nil;
		self.filename = nil;
		self.root = nil;
		
		_isParsed = NO;
	}
	return self;
}

- (instancetype) initWithFile:(NSString *)path
{
	self = [self init];
	if (self) {
		NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
		
		path = [path simplifyPath];
		self.filename = [path lastPathComponent];
		self.path = [path substringToIndex:[path length] - [_filename length]]; // include the last '/'
		
		if (SC_NODE_FILE_PARSER_USE_OUTPUT_FILE) {
			// check whether parsed
			NSString * outFile = [NSString stringWithFormat:@"%@.%@", [_filename stringByDeletingPathExtension], SC_NODE_FILE_PARSER_OUTPUT_FILE_EXT];
			outFile = [_path stringByAppendingString:outFile];
			SCLog(@"loading data from output file: %@", outFile);
			NSDictionary * dict = [SCDictionary dictionaryWithContentsOfFile:outFile];
			if (dict) {
				// check whether the app was updated
				NSString * resourcePath = [dict objectForKey:SC_NODE_FILE_RESOURCE_PATH_KEY];
				if ([resourcePath isEqualToString:SCApplicationDirectory()]) {
					self.root = dict;
				}
			}
		}
		
		if ([_root isKindOfClass:[NSDictionary class]]) {
			_isParsed = YES;
		} else {
			// load source file
			self.root = [SCDictionary dictionaryWithContentsOfFile:path];
			NSAssert([_root isKindOfClass:[NSDictionary class]], @"failed to load file: %@", path);
		}
		
		[pool release];
	}
	return self;
}

- (BOOL) parse
{
	if (_isParsed) {
		return NO;
	}
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	// traverse all nodes
	self.root = [self parseNode:_root];
	NSAssert([_root isKindOfClass:[NSDictionary class]], @"root node must be a dictionary: %@", _root);
	
	if (SC_NODE_FILE_PARSER_USE_OUTPUT_FILE) {
		// write output
		NSString * outFile = [NSString stringWithFormat:@"%@.%@", [_filename stringByDeletingPathExtension], SC_NODE_FILE_PARSER_OUTPUT_FILE_EXT];
		outFile = [_path stringByAppendingString:outFile];
		
		if ([[NSFileManager defaultManager] isWritableFileAtPath:_path]) {
			NSMutableDictionary * mDict = [[NSMutableDictionary alloc] initWithDictionary:_root];
			// if the app was updated, the '[[NSBundle mainBundle] resourcePath]' will be changed
			[mDict setObject:SCApplicationDirectory() forKey:SC_NODE_FILE_RESOURCE_PATH_KEY];
			
			NSString * ext = [[outFile pathExtension] lowercaseString];
			if ([ext isEqualToString:@"mof"]) {
				// write as '.mof' file
				SCMOFTransformer * mof = [[SCMOFTransformer alloc] initWithObject:mDict];
				[mof saveToFile:outFile];
				[mof release];
				SCLog(@"wrote output into MOF file: %@", outFile);
			} else if ([ext isEqualToString:@"plist"]) {
				[mDict writeToFile:outFile atomically:YES];
				SCLog(@"wrote output into plist file: %@", outFile);
			} else {
				SCLog(@"cannot write to file: %@", outFile);
			}
			[mDict release];
		}
	}
	
	[pool release];
	return YES;
}

+ (instancetype) parser:(NSString *)path
{
	SCNodeFileParser * nfp = [[self alloc] initWithFile:path];
	[nfp parse];
	return [nfp autorelease];
}

- (id) node
{
	NSAssert([_root isKindOfClass:[NSDictionary class]], @"data error: %@", _root);
	
	id node = [_root objectForKey:@"Node"]; // snow cat node
	
//	if (!node) {
//		node = [_root objectForKey:@"SFNode"]; // sprite forest node
//	}
//	if (!node) {
//		node = _root; // other node
//	}
	
	NSAssert([node isKindOfClass:[NSDictionary class]], @"data error: %@", node);
	return node;
}

#pragma mark -

- (NSDictionary *) _dictionaryFromString:(NSString *)string
{
	NSObject * object = [SCString objectFromJsonString:string];
	if ([object isKindOfClass:[NSDictionary class]]) {
		// json object
		return (NSDictionary *)object;
	}
	
	// key-value (css) format string
	return [SCString dictionaryFromMapString:string];
}

- (NSString *) _prepareString:(NSString *)string
{
	string = [string replaceWithDictionary:_vars];
	return [string trim];
}

- (NSString *) _fullFilePath:(NSString *)filename
{
	NSAssert([filename length] > 0, @"filename cannot be empty");
	NSAssert([_path length] > 0, @"base path cannot be empty");
	return [filename fullFilePath:_path];
//	if ([filename rangeOfString:@"://"].location != NSNotFound) {
//		// url string
//	} else if ([filename isAbsolutePath]) {
//		// full file path
//	} else {
//		// relative file, prefix current directory to it
//		filename = [_path stringByAppendingString:filename];
//		filename = [filename simplifyPath];
//	}
//	return filename;
}

- (id) _loadFile:(NSString *)filename withReplacement:(NSDictionary *)replacement
{
#if !defined(NS_BLOCK_ASSERTIONS)
	static NSInteger s_depth_count = 0;
#endif
	
	id node = nil;
	
	NSAssert([filename length] > 0, @"filename cannot be empty");
	NSAssert(!replacement || [replacement isKindOfClass:[NSDictionary class]], @"replacement must be a dictionary if set: %@", replacement);
	
#if !defined(NS_BLOCK_ASSERTIONS)
	NSAssert(++s_depth_count < 256, @"dead cycle detected: %@", filename);
#endif
	
	// parsing next include file
	filename = [self _fullFilePath:filename];
	SCNodeFileParser * parser = [[[[self class] alloc] initWithFile:filename] autorelease];
	parser.vars = replacement;
	[parser parse];
	node = [parser node];
	
#if !defined(NS_BLOCK_ASSERTIONS)
	NSAssert(--s_depth_count >= 0, @"overflow: %@", filename);
#endif
	
	return node;
}

- (NSArray *) parseArrayNode:(NSArray *)node
{
	NSMutableArray * mArray = [NSMutableArray arrayWithCapacity:[node count]];
	
	NSEnumerator * enumerator = [node objectEnumerator];
	id child;
	while (child = [enumerator nextObject]) {
		child = [self parseNode:child];
		if (child) {
			[mArray addObject:child];
		}
	}
	
	return mArray;
}

- (NSDictionary *) parseDictionaryNode:(NSDictionary *)node
{
	NSMutableDictionary * mDict = [NSMutableDictionary dictionaryWithCapacity:[node count]];
	
	NSEnumerator * keyEnumerator = [node keyEnumerator];
	NSString * key;
	id child;
	while (key = [keyEnumerator nextObject]) {
		child = [node objectForKey:key];
		key = [key trim];
		NSAssert([key length] > 0, @"key cannot be empty: %@", node);
		if ([key isEqualToString:@"File"]) {
			NSString * filename = [self _prepareString:(NSString *)child];
			child = [self _fullFilePath:filename];
		} else {
			key = [self _prepareString:key];
			child = [self parseNode:child];
		}
		if (child) {
			[mDict setObject:child forKey:key];
		}
	}
	
	return mDict;
}

- (id) parseStringNode:(NSString *)string
{
	string = [self _prepareString:string];
	NSString * lowercaseString = [string lowercaseString];
	
	// include file
	NSRange range = [lowercaseString rangeOfString:@"include file=\""];
	if (range.location == NSNotFound) {
		return string; // plain string
	}
	
	// get include filename
	NSString * filename = [string substringFromIndex:range.location + range.length];
	range = [filename rangeOfString:@"\""];
	if (range.location == NSNotFound) {
		NSAssert(false, @"parse error, string = %@", string);
		return string; // as plain string
	}
	filename = [filename substringToIndex:range.location];
	filename = [filename trim];
	NSAssert([filename length] > 0, @"filename cannot be empty: %@", string);
	
	// get replacement
	NSDictionary * replacement = nil;
	range = [lowercaseString rangeOfString:@"replace=\""];
	if (range.location != NSNotFound) {
		NSString * tmp = [string substringFromIndex:range.location + range.length];
		range = [tmp rangeOfString:@"\""];
		if (range.location == NSNotFound) {
			NSAssert(false, @"parse error, string = %@", string);
			return string; // as plain string
		}
		tmp = [tmp substringToIndex:range.location];
		replacement = [self _dictionaryFromString:tmp];
	}
	// replacement hierarchy
	if (replacement) {
		if (_vars) {
			// use the vars of child node file to replace the vars of parent node file
			replacement = [SCDictionary mergeDictionary:_vars withAttributes:replacement];
		}
	} else {
		replacement = _vars;
	}
	
	// load from file
	id node = [self _loadFile:filename withReplacement:replacement];
	NSAssert([node isKindOfClass:[NSDictionary class]], @"failed to load data from file: %@", filename);
	
	// get attributes
	range = [lowercaseString rangeOfString:@"attributes=\""];
	if (range.location != NSNotFound) {
		NSString * tmp = [string substringFromIndex:range.location + range.length];
		range = [tmp rangeOfString:@"\"" options:NSBackwardsSearch];
		NSAssert(range.location != NSNotFound, @"parse error, string = %@", tmp);
		if (range.location != NSNotFound) {
			tmp = [tmp substringToIndex:range.location];
			NSDictionary * attributes = [self _dictionaryFromString:tmp];
			// set attributes
			node = [SCDictionary mergeDictionary:node withAttributes:attributes];
		}
	}
	
	return node;
}

- (id) parseNode:(id)node
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	if ([node isKindOfClass:[NSArray class]]) {
		node = [self parseArrayNode:(NSArray *)node]; // array node
	} else if ([node isKindOfClass:[NSDictionary class]]) {
		node = [self parseDictionaryNode:(NSDictionary *)node]; // dictionary node
	} else if ([node isKindOfClass:[NSString class]]) {
		node = [self parseStringNode:(NSString *)node]; // node from string
	}
	
	[node retain];
	[pool release];
	return [node autorelease];
}

@end
