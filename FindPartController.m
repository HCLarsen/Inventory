//
//  FindPartController.m
//  Inventory
//
//  Created by Chris Larsen on 12-07-08.
//  Copyright 2012 Chris Larsen. All rights reserved.
//

#import "FindPartController.h"

@implementation FindPartController

-(id)initWithWindowNibName:(NSString *)windowNibName withPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator
{
	if (![super initWithWindowNibName:windowNibName withPersistentStoreCoordinator:coordinator]) 
		return nil;
	
	[self setSearchEntity:[[self.managedObjectModel entitiesByName] objectForKey:@"Part"]];
	
	NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"manufacturer" ascending:YES];
	NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"partNumber" ascending:YES];
	
	[self setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor1, sortDescriptor2, nil]];	
	
	return self;
}

-(void)windowDidLoad {
	[super windowDidLoad];
	
	[[self window] setTitle:@"Inventory"];	
}

-(IBAction)newRecord:(id)sender {
	NSLog(@"Creating new part");
	PartWindowController *newWindowController = [[PartWindowController alloc] initNewPartWithPersistentStoreCoordinator:[managedObjectContext persistentStoreCoordinator]];
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"New Window" object:newWindowController];	
}

-(IBAction)openRecord:(id)sender {
	if ([objectsTableView selectedRow] <= [[objectsList arrangedObjects] count]) {
		Part *thisPart = [[objectsList arrangedObjects] objectAtIndex:[objectsTableView selectedRow]];
		PartWindowController *newWindowController = [[PartWindowController alloc] 
													 initWithPart:thisPart 
													 inManagedObjectContext:managedObjectContext];
		
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		[nc postNotificationName:@"New Window" object:newWindowController];
	}
}

@end
