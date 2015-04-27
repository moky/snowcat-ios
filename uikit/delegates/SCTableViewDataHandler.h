//
//  SCTableViewDataHandler.h
//  SnowCat
//
//  Created by Moky on 14-4-12.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import "SCUIKit.h"

@protocol SCTableViewDataHandler <NSObject>

- (void) reloadData:(UITableView *)tableView;

// section
- (NSArray *) sections;
- (NSUInteger) numberOfSections;
- (NSDictionary *) sectionAtIndex:(NSInteger)sectionIndex;

// rows
- (NSArray *) rowsInSection:(NSInteger)sectionIndex;
- (NSUInteger) numberOfRowsInSection:(NSInteger)sectionIndex;
- (NSDictionary *) rowAtIndex:(NSInteger)rowIndex sectionIndex:(NSInteger)sectionIndex;

- (BOOL) removeRowAtIndexPath:(NSIndexPath *)indexPath;

// tempate
- (NSDictionary *) templates;
- (NSDictionary *) cellTemplate;
- (NSDictionary *) cellTemplateForSection:(NSInteger)sectionIndex;

- (CGSize) cellSize;

@end

@interface SCTableViewDataHandler : SCObject<SCTableViewDataHandler>

@end
