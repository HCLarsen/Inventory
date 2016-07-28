//
//  PartWindowController.m
//  Inventory
//
//  Created by Chris Larsen on 10-11-17.
//  Copyright 2010 home. All rights reserved.
//

#import "PartWindowController.h"

@implementation PartWindowController

@synthesize inPart;

-(id)initWithPart:(Part *)aPart inManagedObjectContext:(NSManagedObjectContext *)moc
{
	[super initWithWindowNibName:@"PartDetails" withManagedObjectContext:moc];
	[self setInPart:aPart];
	[self setNewRecord:NO];
	[self setOpenForEditing:NO];
	[self setMandatoryFields:[NSDictionary dictionaryWithObjectsAndKeys:
							  partNumberField, @"Part Number", 
							  manufacturerField, @"Manufacturer", nil]];
	
	[self showWindow:self];
	
	return self;
}

-(id)initWithPart:(Part *)aPart withPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)psc
{
	[super initWithWindowNibName:@"PartDetails" withPersistentStoreCoordinator:psc];
	[self setInPart:aPart];
	[self setNewRecord:NO];
	[self setOpenForEditing:NO];
	[self setMandatoryFields:[NSDictionary dictionaryWithObjectsAndKeys:
							  partNumberField, @"Part Number", 
							  manufacturerField, @"Manufacturer", nil]];
	
	[self showWindow:self];
	
	return self;
}

-(id)initNewPartWithManagedObjectContext:(NSManagedObjectContext *)moc
{
	[super initWithWindowNibName:@"PartDetails" withManagedObjectContext:moc];
	
	NSEntityDescription *partEntity = [[managedObjectModel entitiesByName] objectForKey:@"Part"];
	Part *aPart = [[NSManagedObject alloc] initWithEntity:partEntity insertIntoManagedObjectContext:nil];
	
	[self setInPart:aPart];
	[self setNewRecord:YES];
	[self setOpenForEditing:YES];	
	[self setMandatoryFields:[NSDictionary dictionaryWithObjectsAndKeys:
							  partNumberField, @"Part Number", 
							  manufacturerField, @"Manufacturer", nil]];

	[self showWindow:self];

	return self;
}

-(id)initNewPartWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)psc
{
	[super initWithWindowNibName:@"PartDetails" withPersistentStoreCoordinator:psc];
	
	NSEntityDescription *partEntity = [[managedObjectModel entitiesByName] objectForKey:@"Part"];
	Part *aPart = [[NSManagedObject alloc] initWithEntity:partEntity insertIntoManagedObjectContext:[self managedObjectContext]];
	
	[self setInPart:aPart];
	[self setNewRecord:YES];
	[self setOpenForEditing:YES];	
	[self setMandatoryFields:[NSDictionary dictionaryWithObjectsAndKeys:
							  partNumberField, @"Part Number", 
							  manufacturerField, @"Manufacturer", nil]];
	
	[self showWindow:self];
	
	return self;
}

-(void)dealloc
{
	[inPart release];
	
	[super dealloc];
}

-(IBAction)cancel:(id)sender
{
	[super cancel:sender];
	
	[partNumberField setStringValue:[inPart partNumber]];
	[manufacturerField setStringValue:[inPart manufacturer]];
	[partDescriptionField setStringValue:[inPart partDescription]];
	[availableField setIntValue:[[inPart available] intValue]];
	[onHandField setIntValue:[[inPart onHand] intValue]];
	[committedField setIntValue:[[inPart allocated] intValue]];
	[onOrderField setIntValue:[[inPart onOrder] intValue]];
	[uOfMPopUp selectItemWithTitle:[inPart uOfM]];
}

-(IBAction)save:(id)sender 
{	
	[super save:sender];
	
	[inPart setPartNumber:[partNumberField stringValue]];
	[inPart setManufacturer:[manufacturerField stringValue]];
	[inPart setPartDescription:[partDescriptionField stringValue]];
	[inPart setOnHand:[NSNumber numberWithInt:[onHandField intValue]]];
	[inPart setAllocated:[NSNumber numberWithInt:[committedField intValue]]];
	[inPart setOnOrder:[NSNumber numberWithInt:[onOrderField intValue]]];
	[inPart setUOfM:[uOfMPopUp titleOfSelectedItem]];
	
	// If inventory values changed, the quantity available must be updated
	[availableField setIntValue:[[inPart available] intValue]];
	
	// If this is a newly created part, we need to insert it into the database.
	if ([self newRecord]) {
		NSLog(@"Inserting new record into dBase");
		[self setNewRecord:NO];
	}
	
	NSError *error = nil;
	
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%s unable to commit editing before saving", [self class], _cmd);
    }
	
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
	
}

#pragma mark textField Delegate Methods

- (BOOL)control:(NSControl*)control textView:(NSTextView*)textView doCommandBySelector:(SEL)commandSelector
{
	// This method makes multi-line text editing possible
    BOOL result = NO;
	
    if (commandSelector == @selector(insertNewline:))
    {
        // new line action:
        // always insert a line-break character and don’t cause the receiver to end editing
        [textView insertNewlineIgnoringFieldEditor:self];
        result = YES;
    }
    return result;
}

-(void)windowDidLoad
{
	[super windowDidLoad];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *unitsOfMeasure = [defaults objectForKey:UnitsOfMeasure];
	for (int i; i<[unitsOfMeasure count];i++){
		[uOfMPopUp addItemWithTitle:[unitsOfMeasure objectAtIndex:i]];
	}
		
	[partNumberField setStringValue:[inPart partNumber]];
	[manufacturerField setStringValue:[inPart manufacturer]];
	if ([inPart partDescription] != nil) {
		[partDescriptionField setStringValue:[inPart partDescription]];		
	} else {
		[partDescriptionField setStringValue:@" "];
	}
	
	[availableField setIntValue:[[inPart available] intValue]];
	[onHandField setIntValue:[[inPart onHand] intValue]];
	[committedField setIntValue:[[inPart allocated] intValue]];
	[onOrderField setIntValue:[[inPart onOrder] intValue]];
	[uOfMPopUp selectItemWithTitle:[inPart uOfM]];
}

@end
