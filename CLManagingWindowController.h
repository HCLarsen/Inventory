//
//  CLManagingWindowController.h
//  CRM
//
//  Created by Chris Larsen on 11-03-19.
//  Copyright 2011 home. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CLManagingWindowController : NSWindowController {
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;

-(id)initWithWindowNibName:(NSString *)windowNibName withPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;
-(id)initWithWindowNibName:(NSString *)windowNibName withManagedObjectContext:(NSManagedObjectContext *)moc;

@end
