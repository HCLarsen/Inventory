//
//  ColumnSelectionController.h
//  Inventory
//
//  Created by Chris Larsen on 12-06-16.
//  Copyright 2012 Chris Larsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ColumnSelectionController : NSWindowController {
	NSMutableArray *availableColumns;
	NSMutableArray *visibleColumns;
	
	NSArrayController *availableColumnsController;
	NSArrayController *visibleColumnsController;
	
	NSTableView *availableColumnsView;
	NSTableView *visibleColumnsView;
}

-(id)initWithAllColumns:(NSArray *)columns andVisibleColumnsFrom:(NSString *)aKey;
-(IBAction)addColumn:(id)sender;
-(IBAction)removeColumn:(id)sender;
-(IBAction)moveUp:(id)sender;
-(IBAction)moveDown:(id)sender;
-(IBAction)okSelection:(id)sender;
-(IBAction)cancelSelection:(id)sender;

@property (assign) IBOutlet NSTableView *availableColumnsView, *visibleColumnsView;
@property (assign) IBOutlet NSArrayController *availableColumnsController, *visibleColumnsController;

@end
