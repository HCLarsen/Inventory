//
//  Inventory_AppDelegate.h
//  Inventory
//
//  Created by Chris Larsen on 10-09-18.
//  Copyright home 2010 . All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Part.h"
#include "PartWindowController.h"
#include "PreferencesController.h"
#include "ColumnSelectionController.h"
#include "NSString+WordsAndCharacters.h"
#include "FindPartController.h"


@interface Inventory_AppDelegate : NSObject 
{
    NSWindow *window;
	NSMutableArray *windowControllers;
	FindPartController *findPartController;
	
	IBOutlet NSTableView *inventoryTable;
    	
	NSEntityDescription *partEntity;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
	
}

-(IBAction)openPreferences:(id)sender;
-(IBAction)exportToCSV:(id)sender;
-(IBAction)importFromCSV:(id)sender;
-(IBAction)findParts:(id)sender;
-(IBAction)createPart:(id)sender;
-(IBAction)saveAction:sender;

@property (nonatomic, retain) IBOutlet NSWindow *window;
@property (retain) NSMutableArray *windowControllers;

@property (nonatomic, retain, readonly) NSEntityDescription *partEntity;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

@end
