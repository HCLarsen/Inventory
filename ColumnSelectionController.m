//
//  ColumnSelectionController.m
//  Inventory
//
//  Created by Chris Larsen on 12-06-16.
//  Copyright 2012 Chris Larsen. All rights reserved.
//

#import "ColumnSelectionController.h"
#include "NSString+WordsAndCharacters.h"

@implementation ColumnSelectionController

@synthesize availableColumnsController, visibleColumnsController;
@synthesize availableColumnsView, visibleColumnsView;

-(id)initWithAllColumns:(NSArray *)columns andVisibleColumnsFrom:(NSString *)aKey {
	[super initWithWindowNibName:@"ColumnSelection"];
	
	availableColumns = [[NSMutableArray alloc] init];
	for (NSString *columnName in columns) {
		[availableColumns addObject:[columnName nameFromKey]];
	}
	visibleColumns = [[NSMutableArray alloc] init];

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSMutableArray *columnList = [defaults objectForKey:aKey];
	for (NSData *columnData in columnList) {
		NSTableColumn *column = [NSUnarchiver unarchiveObjectWithData:columnData];
		[visibleColumns addObject:column];
		if ([availableColumns containsObject:[column identifier]]) {
			[availableColumns removeObject:[column identifier]];
		}
	}
	
	return self;
}

-(IBAction)addColumn:(id)sender {
	for (NSString *columnName in [availableColumnsController selectedObjects]) {
		NSTableColumn *newColumn = [[NSTableColumn alloc] initWithIdentifier:columnName];
		[[newColumn headerCell] setStringValue:columnName];
		[newColumn sizeToFit];
		[visibleColumnsController addObject:newColumn];
	}
	
	[availableColumnsController removeObjects:[availableColumnsController selectedObjects]];
}

-(IBAction)removeColumn:(id)sender {
	NSArray *columns = [visibleColumnsController selectedObjects];
	[visibleColumnsController removeObjects:columns];
	[availableColumnsController addObjects:[columns valueForKeyPath:@"identifier"]];
}

-(IBAction)moveUp:(id)sender {
	int itemIndex = [visibleColumnsView selectedRow];
	if (itemIndex <=0) {
		return;
	}
	NSTableColumn *activeColumn = [visibleColumns objectAtIndex:itemIndex];
	[visibleColumnsController removeObject:activeColumn];
	[visibleColumnsController insertObject:activeColumn atArrangedObjectIndex:itemIndex-1];
}

-(IBAction)moveDown:(id)sender {
	int itemIndex = [visibleColumnsView selectedRow];
	if (itemIndex >=[visibleColumns count]-1) {
		return;
	}
	NSTableColumn *activeColumn = [visibleColumns objectAtIndex:itemIndex];
	[visibleColumnsController removeObject:activeColumn];
	[visibleColumnsController insertObject:activeColumn atArrangedObjectIndex:itemIndex+1];
}

-(IBAction)okSelection:(id)sender {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSMutableArray *columns = [NSMutableArray array];
	for (NSTableColumn *column in [visibleColumnsController arrangedObjects]) {
		NSData *columnData = [NSArchiver archivedDataWithRootObject:column];
		[columns addObject:columnData];
	}	
	[defaults setObject:columns forKey:@"Visible Columns"];

	[NSApp endSheet:[self window] returnCode:NSOKButton];
}

-(IBAction)cancelSelection:(id)sender {
	[NSApp endSheet:[self window]];
}

@end
