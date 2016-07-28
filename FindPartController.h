//
//  FindPartController.h
//  Inventory
//
//  Created by Chris Larsen on 12-07-08.
//  Copyright 2012 Chris Larsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Part.h"
#import "PartWindowController.h"
#import "CLFindManagedObjectController.h"

@interface FindPartController : CLFindManagedObjectController {

}

-(IBAction)newRecord:(id)sender;
-(IBAction)openRecord:(id)sender;

@end
