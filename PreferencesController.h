//
//  PreferencesController.h
//  Inventory
//
//  Created by Chris Larsen on 12-05-31.
//  Copyright 2012 Chris Larsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define DatabaseLocation @"DatabaseLocation"
#define UnitsOfMeasure @"UnitsOfMeasure"
#define VisibleColumns @"VisibleColumns"

@interface PreferencesController : NSWindowController {
	NSView *generalView;
	NSView *backUpView;
	NSView *adminView;
	
	NSBox *box;
	
	NSPathControl *mainPath;
	NSTableView *unitsView;
	NSArrayController *unitsController;

	BOOL autoBackUp;
	int backUpFrequency;
	int backUpDate;
	
	BOOL admin;	// test, will later be determined by user login permissions
}

-(IBAction)showGeneralView:(id)sender;
-(IBAction)showBackUpView:(id)sender;
-(IBAction)showUsersView:(id)sender;
-(IBAction)resetDefaults:(id)sender;
-(IBAction)acceptChanges:(id)sender;
-(void)resizeWindowFrom:(NSSize)currentSize to:(NSSize)newSize;

@property (assign) IBOutlet NSView *generalView, *backUpView, *usersView;
@property (assign) IBOutlet NSBox *box;
@property (assign) IBOutlet NSPathControl *mainPath;
@property (assign) IBOutlet NSTableView *unitsView;
@property (assign) IBOutlet NSArrayController *unitsController;
@property (assign) IBOutlet BOOL autoBackUp;
@property (assign) IBOutlet int backUpFrequency, backUpDate;
@property (assign) BOOL admin;

@end
