//
//  CLFindManagedObjectController.m
//  Inventory
//
//  Created by Chris Larsen on 12-08-07.
//  Copyright 2012 Chris Larsen. All rights reserved.
//

#import "CLFindManagedObjectController.h"

@implementation CLFindManagedObjectController

@synthesize objectsTableView;
@synthesize objectsList;
@synthesize searchField;
@synthesize searchEntity;
@synthesize sortDescriptors;

-(void)windowDidLoad {
	[objectsTableView setDoubleAction:@selector(openRecord:)];
	
	[self reDrawTable];
	[self reloadList:nil];
}

-(void)reDrawTable {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *visibleColumns = [defaults objectForKey:@"Visible Columns"];
	
	int n = [[objectsTableView tableColumns] count];
	for (int i = 0; i<n; i++) {
		[objectsTableView removeTableColumn:[[objectsTableView tableColumns] objectAtIndex:0]];
	}
	
	for (NSData *columnData in visibleColumns) {
		NSTableColumn *column = [NSUnarchiver unarchiveObjectWithData:columnData];
		NSString *keyPath = [NSString stringWithFormat:@"arrangedObjects.%@", [[column identifier] keyFromName]];
		[column bind:@"value" toObject:objectsList withKeyPath:keyPath options:nil];
		[column setEditable:NO];
		[objectsTableView addTableColumn:column];
	}
}

-(IBAction)reloadList:(id)sender
{	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:searchEntity];
	[request setSortDescriptors:self.sortDescriptors];
	
	NSArray *array = [managedObjectContext executeFetchRequest:request error:nil];
	[objectsList setContent:array];
}

-(void)saveTable {
	// Saves state of the tableView, such as columns, and column width.
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSMutableArray *columns = [NSMutableArray array];
	for (NSTableColumn *column in [objectsTableView tableColumns]) {
		NSData *columnData = [NSArchiver archivedDataWithRootObject:column];
		[columns addObject:columnData];
	}
	
	[defaults setObject:columns forKey:@"Visible Columns"];
}

-(IBAction)openColumnSelection:(id)sender {
	[self saveTable];	// Saves current state of the tableColumns first
	
	NSArray *allColumns = [[self.searchEntity attributesByName] allKeys];
	ColumnSelectionController *columnSelector = [[ColumnSelectionController alloc] initWithAllColumns:allColumns andVisibleColumnsFrom:@"Visible Columns"];
	
	[NSApp beginSheet:[columnSelector window]
	   modalForWindow:[self window] 
		modalDelegate:self 
	   didEndSelector:@selector(didEndSheet:returnCode:contextInfo:)
		  contextInfo:nil];	
}

- (void)didEndSheet:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
	if (returnCode == NSOKButton) {
		[self reDrawTable];
	}
	
	[sheet orderOut:self];
}

-(IBAction)deleteRecord:(id)sender {
	// Implement this action
	NSManagedObject *objectToDelete = [[objectsList arrangedObjects] objectAtIndex:[objectsTableView selectedRow]];
	[self.managedObjectContext deleteObject:objectToDelete];
	[self reloadList:nil];
	[self.managedObjectContext save:nil];	
}

@end
