//
//  CLFindManagedObjectController.h
//  Inventory
//
//  Created by Chris Larsen on 12-08-07.
//  Copyright 2012 Chris Larsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSString+WordsAndCharacters.h"
#import "CLManagingWindowController.h"
#import "ColumnSelectionController.h"

@interface CLFindManagedObjectController : CLManagingWindowController {
	NSTableView *objectsTableView;
	NSArrayController *objectsList;
	NSSearchField *searchField;
	
	NSEntityDescription *searchEntity;
	NSArray *sortDescriptors;
}

@property (nonatomic, retain) IBOutlet NSTableView *objectsTableView;
@property (nonatomic, retain) IBOutlet NSArrayController *objectsList;
@property (assign) IBOutlet NSSearchField *searchField;

@property (nonatomic, retain) NSEntityDescription *searchEntity;
@property (nonatomic, retain) NSArray *sortDescriptors;

-(void)reDrawTable;
-(void)saveTable;

-(IBAction)reloadList:(id)sender;
-(IBAction)openColumnSelection:(id)sender;

-(IBAction)deleteRecord:(id)sender;

@end
