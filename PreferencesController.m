//
//  PreferencesController.m
//  Inventory
//
//  Created by Chris Larsen on 12-05-31.
//  Copyright 2012 Chris Larsen. All rights reserved.
//

#import "PreferencesController.h"

@implementation PreferencesController

@synthesize generalView, backUpView, usersView, box;
@synthesize mainPath, unitsView, unitsController;
@synthesize autoBackUp, backUpFrequency, backUpDate;
@synthesize admin;
	
-(void)awakeFromNib {
	self.admin = YES;	//Just for testing purposes
	
	[self showGeneralView:self];
	if (admin == YES) {
		NSToolbar *toolbar = [self.window toolbar];
		[toolbar insertItemWithItemIdentifier:@"Back Up" atIndex:[[toolbar items] count]];
		[toolbar insertItemWithItemIdentifier:@"Users" atIndex:[[toolbar items] count]];
	}
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *path = [defaults objectForKey:DatabaseLocation];
	[mainPath setURL:[NSURL fileURLWithPath:path]];
	NSArray *units = [defaults objectForKey:UnitsOfMeasure];
	[unitsController setContent:units];
}

-(IBAction)showGeneralView:(id)sender {
	NSView *oldView = self.box.contentView;
	NSSize oldSize = oldView.frame.size;
	NSSize newSize = generalView.frame.size;
	[self.box setContentView:generalView];	
	[self resizeWindowFrom: oldSize to:newSize];
	[self.window setTitle:@"General"];
}

-(IBAction)showBackUpView:(id)sender {
	NSView *oldView = self.box.contentView;
	NSSize oldSize = oldView.frame.size;
	NSSize newSize = backUpView.frame.size;
	[self.box setContentView:backUpView];	
	[self resizeWindowFrom: oldSize to:newSize];
	[self.window setTitle:@"Back Up"];
}

-(IBAction)showUsersView:(id)sender {
	NSView *oldView = self.box.contentView;
	NSSize oldSize = oldView.frame.size;
	NSSize newSize = usersView.frame.size;	
	[self.box setContentView:usersView];
	[self resizeWindowFrom: oldSize to:newSize];
	[self.window setTitle:@"Users"];
}

-(IBAction)resetDefaults:(id)sender {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults removeObjectForKey:UnitsOfMeasure];
	[defaults removeObjectForKey:DatabaseLocation];
}

-(IBAction)acceptChanges:(id)sender {
	//NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
}

-(void)resizeWindowFrom:(NSSize)currentSize to:(NSSize)newSize {
	// Since Apple's origin is the bottom left, and resizing looks better with the upper left corner anchored, a little code is needed to make it right.
	
	float deltaWidth = newSize.width - currentSize.width;
	float deltaHeight = newSize.height - currentSize.height;
	NSRect windowFrame = self.window.frame;
	windowFrame.size.height += deltaHeight;
	windowFrame.origin.y -= deltaHeight;
	windowFrame.size.width += deltaWidth;
	
	[self.window setFrame:windowFrame display:YES animate:YES];
}

@end
