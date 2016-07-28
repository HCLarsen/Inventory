//
//  Inventory_AppDelegate.m
//  Inventory
//
//  Created by Chris Larsen on 10-09-18.
//  Copyright home 2010 . All rights reserved.
//

#import "Inventory_AppDelegate.h"

@implementation Inventory_AppDelegate

@synthesize window;
@synthesize windowControllers;

+(void)initialize {
	// Create a dictionary
	NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
	
	// Create defaults for visible table columns
	NSArray *visibleColumns = [NSArray arrayWithObjects:@"Manufacturer", @"Part Number",  @"On Hand", @"Available", @"U Of M", nil];
	NSMutableArray *columns = [NSMutableArray array];
	for (NSString *columnName in visibleColumns) {
		NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:columnName];
		[[column headerCell] setStringValue:columnName];
		[column setEditable:NO];
		[column setWidth:70];
		NSData *columnData = [NSArchiver archivedDataWithRootObject:column];
		[columns addObject:columnData];
	}
	[defaultValues setObject:columns forKey:VisibleColumns];
	
	// Create defaults for database location
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
	basePath = [basePath stringByAppendingPathComponent:@"Inventory"];
	[defaultValues setObject:basePath forKey:DatabaseLocation];
	
	// Create defaults for list of available units
	NSArray *units = [NSArray arrayWithObjects:@"Ea", @"m", @"ft", @"kg", nil];
	[defaultValues setObject:units forKey:UnitsOfMeasure];

	// Register defaults
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

-(id)init
{
	[super init];
	
	return self;
}

-(IBAction)findParts:(id)sender {
	if (!findPartController) {
		findPartController = [[FindPartController alloc] initWithWindowNibName:@"FindRecords" withPersistentStoreCoordinator:self.persistentStoreCoordinator];
	}
	
	[findPartController showWindow:self];
}

-(IBAction)openPreferences:(id)sender {
	PreferencesController *preferences = [[PreferencesController alloc] initWithWindowNibName:@"Preferences"];
	
	[preferences showWindow:self];
}

-(void)emptyDBaseChoice:(NSAlert *)alert code:(int)choice context:(void *)v
{
	if (choice == NSAlertAlternateReturn) {
		// Will open an import file dialogue to import the files from an excel or 
		// numbers file
		NSLog(@"Importing file");
		[self importFromCSV:nil];
	} else if (choice == NSAlertOtherReturn) {
		// Will quit the application without saving the blank database
		NSLog(@"Quitting without saving");
		//self.shouldSaveOnTerminate = NO;
		exit(0);
	}
}

#pragma mark Import and Export methods

-(IBAction)exportToCSV:(id)sender {	
	// Step 1, create a string for the column headers from the attribute titles
	NSMutableString *csv = [NSMutableString stringWithFormat:@"Part Number, Manufacturer, Part Description, On Hand, On Order, Allocated, Unit of Measure"];
	
	// Step 2, create an array of strings from the objects in memory
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:self.partEntity];
	NSArray *inventory = [managedObjectContext executeFetchRequest:request error:nil];
	
	int numberOfRows = [inventory count];
	for (int i; i < numberOfRows; i++) {
		Part *aPart = [inventory objectAtIndex:i];
		[csv appendFormat:@"\n%@, %@, %@, %@, %@, %@, %@", aPart.partNumber, aPart.manufacturer, aPart.partDescription, aPart.onHand, aPart.onOrder, aPart.allocated, aPart.uOfM];
	}
	
	// Step 3, open save panel, and write the data to the file
	NSSavePanel *savePanel = [NSSavePanel savePanel];
	[savePanel setNameFieldStringValue:@"Inventory.csv"];
	[savePanel beginSheetModalForWindow:window completionHandler:^(NSInteger result){ 
		if (result == NSFileHandlingPanelOKButton) {
			NSURL *filePath = [savePanel URL];
			[csv writeToURL:filePath atomically:YES encoding: NSUTF8StringEncoding error:NULL];
		}
	}];
}

-(IBAction)importFromCSV:(id)sender {	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documents = [paths objectAtIndex:0];
	
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	NSURL *directory = [NSURL URLWithString:documents];
	[openPanel setDirectoryURL:directory];
	[openPanel beginSheetModalForWindow:window completionHandler:^(NSInteger result){
		if (result == NSFileHandlingPanelOKButton) {
			// First inquire if the user wants to replace the database, or add to it
			if ([sender isKindOfClass:[NSMenuItem class]]) {	// Only ask if this method is called from the menu option
				NSAlert *alert = [[NSAlert alloc] init];
				[alert addButtonWithTitle:@"Replace Existing"];
				[alert addButtonWithTitle:@"Add to Existing"];
				[alert setMessageText:@"Replace or Add to Existing Database?"];
				[alert setInformativeText:@"Do you want to add the CSV contents to the database, or replace it?"];
				[alert setAlertStyle:NSWarningAlertStyle];
				
				if ([alert runModal] == NSAlertFirstButtonReturn) {
					// If the user selected Replace, then the current database is deleted before the information is imported
					NSFetchRequest *request = [[NSFetchRequest alloc] init];
					[request setEntity:self.partEntity];
					NSArray *inventory = [managedObjectContext executeFetchRequest:request error:nil];
					
					for (id aPart in inventory) {						
						[[self managedObjectContext] deleteObject:aPart];
					}
					[self saveAction:nil];	// save empty array to the database
				}
			}
 			
			NSURL *filePath = [openPanel URL];
			NSString *fileString = [NSString stringWithContentsOfURL:filePath encoding:NSUTF8StringEncoding error:NULL];			
			NSArray *rows = [fileString componentsSeparatedByString:@"\n"];	
			for (int i=1; i<[rows count]; i++){
				NSArray *columns = [[rows objectAtIndex:i] componentsSeparatedByString:@","];
				Part *aPart = [[Part alloc] initWithEntity:[self partEntity] insertIntoManagedObjectContext:managedObjectContext];
				[aPart setPartNumber:[[columns objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
				[aPart setManufacturer:[[columns objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
				[aPart setPartDescription:[[columns objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
				[aPart setOnHand:[NSNumber numberWithInt:[[columns objectAtIndex:3] intValue]]];
				[aPart setOnOrder:[NSNumber numberWithInt:[[columns objectAtIndex:4] intValue]]];
				[aPart setAllocated:[NSNumber numberWithInt:[[columns objectAtIndex:5] intValue]]];
				[aPart setUOfM:[[columns objectAtIndex:6] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
			}
			[self saveAction:nil];
		}
		
	}];	
}

#pragma mark Entity control methods

-(IBAction)createPart:(id)sender
{
	PartWindowController *newWindowController = [[PartWindowController alloc] initNewPartWithManagedObjectContext:managedObjectContext];
	[[self windowControllers] addObject:newWindowController];
}

#pragma mark Core Data Methods

- (NSEntityDescription *)partEntity {
	if (partEntity) return partEntity;

	partEntity = [[managedObjectModel entitiesByName] objectForKey:@"Part"];
	return partEntity;
}

/**
    Returns the support directory for the application, used to store the Core Data
    store file.  This code uses a directory named "Inventory" for
    the content, either in the NSApplicationSupportDirectory location or (if the
    former cannot be found), the system's temporary directory.
 */

- (NSString *)applicationSupportDirectory {
	// This directory should be loaded from the defaults, not calculated each time

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *path = [defaults objectForKey:DatabaseLocation];
	return path;
}


/**
    Creates, retains, and returns the managed object model for the application 
    by merging all of the models found in the application bundle.
 */
 
- (NSManagedObjectModel *)managedObjectModel {

    if (managedObjectModel) return managedObjectModel;
	
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
    Returns the persistent store coordinator for the application.  This 
    implementation will create and return a coordinator, having added the 
    store for the application to it.  (The directory for the store is created, 
    if necessary.)
 */

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {

    if (persistentStoreCoordinator) return persistentStoreCoordinator;

    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSAssert(NO, @"Managed object model is nil");
        NSLog(@"%@:%s No model to generate a store from", [self class], _cmd);
        return nil;
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *applicationSupportDirectory = [self applicationSupportDirectory];
    NSError *error = nil;
    
    if ( ![fileManager fileExistsAtPath:applicationSupportDirectory isDirectory:NULL] ) {
		if (![fileManager createDirectoryAtPath:applicationSupportDirectory withIntermediateDirectories:NO attributes:nil error:&error]) {
            NSAssert(NO, ([NSString stringWithFormat:@"Failed to create App Support directory %@ : %@", applicationSupportDirectory,error]));
            NSLog(@"Error creating application support directory at %@ : %@",applicationSupportDirectory,error);
            return nil;
		}
    }
    
    NSURL *url = [NSURL fileURLWithPath: [applicationSupportDirectory stringByAppendingPathComponent: @"inventory.dbase"]];
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: mom];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSXMLStoreType 
                                                configuration:nil 
                                                URL:url 
                                                options:nil 
                                                error:&error]){
        [[NSApplication sharedApplication] presentError:error];
        [persistentStoreCoordinator release], persistentStoreCoordinator = nil;
        return nil;
    }    

    return persistentStoreCoordinator;
}

/**
    Returns the managed object context for the application (which is already
    bound to the persistent store coordinator for the application.) 
 */
 
- (NSManagedObjectContext *) managedObjectContext {

    if (managedObjectContext) return managedObjectContext;

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    managedObjectContext = [[NSManagedObjectContext alloc] init];
    [managedObjectContext setPersistentStoreCoordinator: coordinator];

    return managedObjectContext;
}

/**
    Returns the NSUndoManager for the application.  In this case, the manager
    returned is that of the managed object context for the application.
 */
 
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
    return [[self managedObjectContext] undoManager];
}


/**
    Performs the save action for the application, which is to send the save:
    message to the application's managed object context.  Any encountered errors
    are presented to the user.
 */
 
- (IBAction) saveAction:(id)sender {

    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%s unable to commit editing before saving", [self class], _cmd);
    }

    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

#pragma mark App Delegate Methods
/**
    Implementation of the applicationShouldTerminate: method, used here to
    handle the saving of changes in the application managed object context
    before the application terminates.
 */
 
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
	// Saves state of the tableView, such as columns, and column width.
	//[self saveTable];
		
    if (!managedObjectContext) return NSTerminateNow;

    if (![managedObjectContext commitEditing]) {
        NSLog(@"%@:%s unable to commit editing to terminate", [self class], _cmd);
        return NSTerminateCancel;
    }

    if (![managedObjectContext hasChanges]) return NSTerminateNow;

    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
    
        // This error handling simply presents error information in a panel with an 
        // "Ok" button, which does not include any attempt at error recovery (meaning, 
        // attempting to fix the error.)  As a result, this implementation will 
        // present the information to the user and then follow up with a panel asking 
        // if the user wishes to "Quit Anyway", without saving the changes.

        // Typically, this process should be altered to include application-specific 
        // recovery steps.  
                
        BOOL result = [sender presentError:error];
        if (result) return NSTerminateCancel;

        NSString *question = NSLocalizedString(@"Could not save changes while quitting.  Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        [alert release];
        alert = nil;
        
        if (answer == NSAlertAlternateReturn) return NSTerminateCancel;
    }
	
    return NSTerminateNow;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[self managedObjectContext];	// Creates the core data objects such as the model, context and persistant store.
	
	// Determine if database is empty, and give appropriate options
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:self.partEntity];
	NSError *error = nil;
	NSArray *inventory = [managedObjectContext executeFetchRequest:request error:&error];
	
	if ([inventory count] == 0) {
		NSAlert *alert = [NSAlert alertWithMessageText:@"No Database Found" 
										 defaultButton:@"Start New" 
									   alternateButton:@"Import Database" 
										   otherButton:@"Exit Application"
							 informativeTextWithFormat:@"The inventory database was not found, or the database is empty.  Would you like to import an inventory list, start a new database, or exit the application without saving?"];
		NSInteger choice = [alert runModal];
		
		if (choice == NSAlertAlternateReturn) {
			// Will open an import file dialogue to import the files from a CSV
			[self importFromCSV:nil];
		} else if (choice == NSAlertOtherReturn) {
			// Will quit the application without saving the blank database
			exit(0);
		}
	}
	
	[self findParts:nil];
}

/**
    Implementation of dealloc, to release the retained variables.
 */
 
- (void)dealloc 
{
    [window release];
	[windowControllers release];
    [managedObjectContext release];
    [persistentStoreCoordinator release];
    [managedObjectModel release];
	
    [super dealloc];
}

@end
