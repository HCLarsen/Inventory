//
//  CLLockableWindowController.h
//  Inventory
//
//  Created by Chris Larsen on 10-10-20.
//  Copyright 2010 home. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CLManagingWindowController.h"

enum  {
	CLUnlockMenuItemTag = 120,
	CLLockMenuItemTag = 121,
};

@interface CLLockableWindowController : CLManagingWindowController {
	NSWindow *window;

	NSDictionary *mandatoryFields;
	
	BOOL newRecord;
	BOOL openForEditing;
}

-(IBAction)save:(id)sender;
-(IBAction)open:(id)sender;
-(IBAction)cancel:(id)sender;
-(NSArray *)allSubviews;

@property (nonatomic, assign) NSDictionary *mandatoryFields;
@property BOOL newRecord;
@property BOOL openForEditing;
@end
