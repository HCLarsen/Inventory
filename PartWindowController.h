//
//  PartWindowController.h
//  Inventory
//
//  Created by Chris Larsen on 10-11-17.
//  Copyright 2010 home. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "CLLockableWindowController.h"
#import "Part.h"
#import "PreferencesController.h"

@interface PartWindowController : CLLockableWindowController {
	Part *inPart;
	
	IBOutlet NSTextField *partNumberField;
	IBOutlet NSTextField *manufacturerField;
	IBOutlet NSTextField *partDescriptionField;
	IBOutlet NSTextView *partDescriptionView;
	IBOutlet NSTextField *availableField;
	IBOutlet NSTextField *onHandField;
	IBOutlet NSTextField *committedField;
	IBOutlet NSTextField *onOrderField;
	IBOutlet NSPopUpButton *uOfMPopUp;
}

-(id)initWithPart:(Part *)aPart inManagedObjectContext:(NSManagedObjectContext *)moc;
-(id)initWithPart:(Part *)aPart withPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)psc;
-(id)initNewPartWithManagedObjectContext:(NSManagedObjectContext *)moc;
-(id)initNewPartWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)psc;

@property (nonatomic, assign) Part *inPart;

@end
