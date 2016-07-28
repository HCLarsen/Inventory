//
//  CLManagingWindowController.m
//  CRM
//
//  Created by Chris Larsen on 11-03-19.
//  Copyright 2011 home. All rights reserved.
//

#import "CLManagingWindowController.h"

@implementation CLManagingWindowController

@synthesize managedObjectContext;
@synthesize managedObjectModel;

-(id)initWithWindowNibName:(NSString *)windowNibName withManagedObjectContext:(NSManagedObjectContext *)moc
{
	self = [super initWithWindowNibName:windowNibName];
	
	self.managedObjectContext = moc;
	self.managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    

	return self;
}

-(id)initWithWindowNibName:(NSString *)windowNibName withPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator
{
	if (![super initWithWindowNibName:windowNibName]) 
		return nil;
	
	self.managedObjectContext = [[NSManagedObjectContext alloc] init];
	[self.managedObjectContext setPersistentStoreCoordinator:coordinator];
	
	self.managedObjectModel = [coordinator managedObjectModel];
	
	return self;
}

-(void)dealloc
{
	[managedObjectModel release];
	[managedObjectContext release];
	
	[super dealloc];
}

@end
